// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;
import {IERC721A} from "lib/ERC721A/contracts/interfaces/IERC721A.sol";
import {ICre8ors} from "../interfaces/ICre8ors.sol";
import {IERC721Drop} from "../interfaces/IERC721Drop.sol";
import {ICollectionHolderMint} from "../interfaces/ICollectionHolderMint.sol";
import {FriendsAndFamilyMinter} from "../minter/FriendsAndFamilyMinter.sol";
import {IMinterUtilities} from "../interfaces/IMinterUtilities.sol";

contract MinterUtilities is IMinterUtilities {
    /// @dev The maximum quantity allowed for each address in the whitelist.
    uint256 public maxAllowlistQuantity = 8;

    /// @dev The maximum quantity allowed for public minting.
    uint256 public maxPublicMintQuantity = 18;

    /// @dev The address of the collection contract.
    address public collectionAddress;

    /// @dev Mapping to store tier information for each tier represented by an integer key.
    /// @notice Tier information includes price and lockup details.
    mapping(uint8 => TierInfo) public tierInfo;

    constructor(
        address _collectionAddress,
        uint256 _tier1Price,
        uint256 _tier2Price,
        uint256 _tier3Price
    ) {
        collectionAddress = _collectionAddress;
        tierInfo[1] = TierInfo(_tier1Price, 32 weeks);
        tierInfo[2] = TierInfo(_tier2Price, 8 weeks);
        tierInfo[3] = TierInfo(_tier3Price, 0 weeks);
    }

    /// @dev Calculates the total price based on the tier and quantity of items to be purchased.
    /// @param tier The tier of the item.
    /// @param quantity The quantity of the items to be purchased.
    /// @return The total price for the specified tier and quantity.
    function calculatePrice(
        uint8 tier,
        uint256 quantity
    ) public view returns (uint256) {
        uint256 tierPrice = tier > 0 && tier < 4
            ? tierInfo[tier].price
            : tierInfo[3].price;
        uint256 price = tierPrice * quantity;
        return price;
    }

    /// @dev Retrieves the quantity of items remaining that can be minted by the specified recipient.
    /// @param passportHolderMinter The address of the passport holder minter contract.
    /// @param friendsAndFamilyMinter The address of the friends and family minter contract.
    /// @param target The address of the ICre8ors contract.
    /// @param recipient The recipient address for which the quantity is to be calculated.
    /// @return The quantity of items that can be minted by the specified recipient.
    function quantityLeft(
        address passportHolderMinter,
        address friendsAndFamilyMinter,
        address target,
        address recipient
    ) external view returns (uint256) {
        ICre8ors cre8ors = ICre8ors(target);
        ICollectionHolderMint passportMinter = ICollectionHolderMint(
            passportHolderMinter
        );
        FriendsAndFamilyMinter friendsAndFamily = FriendsAndFamilyMinter(
            friendsAndFamilyMinter
        );

        uint256 totalMints = cre8ors.mintedPerAddress(recipient).totalMints;
        uint256 totalClaimed = passportMinter.totalClaimed(recipient) +
            friendsAndFamily.totalClaimed(recipient);
        uint256 maxQuantity = maxAllowedQuantity(totalClaimed);

        if (maxQuantity < totalMints) {
            return 0;
        }
        return maxQuantity - totalMints;
    }

    /// @dev Calculates the total cost of all items in the given carts array.
    /// @param carts An array of Cart structs containing information about each item in the cart.
    /// @return The total cost of all items in the carts array.
    function calculateTotalCost(
        Cart[] calldata carts
    ) external view returns (uint256) {
        uint256 totalCost = 0;
        for (uint256 i = 0; i < carts.length; i++) {
            totalCost += calculatePrice(carts[i].tier, carts[i].quantity);
        }
        return totalCost;
    }

    /// @dev Calculates the lockup date for a given tier.
    /// @param tier The tier for which the lockup date is being calculated.
    /// @return The lockup date for the specified tier, expressed as a Unix timestamp.
    function calculateLockupDate(uint8 tier) external view returns (uint256) {
        return block.timestamp + tierInfo[tier].lockup;
    }

    /// @dev Calculates the total quantity of items across all carts.
    /// @param carts An array of Cart structs containing information about each item in the cart.
    /// @return uint256 total quantity of items across all carts.
    function calculateTotalQuantity(
        Cart[] calldata carts
    ) public pure returns (uint256) {
        uint256 totalQuantity = 0;
        for (uint256 i = 0; i < carts.length; i++) {
            totalQuantity += carts[i].quantity;
        }
        return totalQuantity;
    }

    /**
     * @dev Calculates the unlock price for a given tier and minting option.
     * @param tier The tier for which to calculate the unlock price.
     * @param freeMint A boolean flag indicating whether the minting option is free or not.
     * @return The calculated unlock price in wei.
     */
    function calculateUnlockPrice(
        uint8 tier,
        bool freeMint
    ) external view returns (uint256) {
        if (freeMint) {
            return tierInfo[3].price - tierInfo[1].price;
        } else {
            return tierInfo[3].price - tierInfo[tier].price;
        }
    }

    /// @dev Updates the prices for all tiers.
    /// @param tierPrices A bytes array containing the new prices for tier 1, tier 2, and tier 3.
    ///                  The bytes array should be encoded using the `abi.encode` function with three uint256 values
    ///                  corresponding to the prices of tier 1, tier 2, and tier 3, respectively.
    /// @notice This function can only be called by the contract's admin.
    function updateAllTierPrices(bytes calldata tierPrices) external onlyAdmin {
        (uint256 tier1, uint256 tier2, uint256 tier3) = abi.decode(
            tierPrices,
            (uint256, uint256, uint256)
        );
        tierInfo[1].price = tier1;
        tierInfo[2].price = tier2;
        tierInfo[3].price = tier3;
    }

    /// @dev Sets new default lockup periods for all tiers.
    /// @param lockupInfo A bytes array containing the new lockup periods for tier 1, tier 2, and tier 3.
    ///                   The bytes array should be encoded using the `abi.encode` function with three uint256 values
    ///                   corresponding to the lockup periods of tier 1, tier 2, and tier 3, respectively.
    /// @notice This function can only be called by the contract's admin.
    function setNewDefaultLockups(
        bytes calldata lockupInfo
    ) external onlyAdmin {
        (uint256 tier1, uint256 tier2, uint256 tier3) = abi.decode(
            lockupInfo,
            (uint256, uint256, uint256)
        );
        tierInfo[1].lockup = tier1;
        tierInfo[2].lockup = tier2;
        tierInfo[3].lockup = tier3;
    }

    /// @dev Retrieves tier information for a given tier.
    /// @param tier The tier for which the information is being retrieved.
    /// @return TierInfo struct containing price and lockup information for the specified tier.
    function getTierInfo(uint8 tier) external view returns (TierInfo memory) {
        return tierInfo[tier];
    }

    /// @dev Retrieves tier information for all tiers.
    /// @return A bytes array containing the tier information for all tiers.
    function getTierInfo() external view returns (bytes memory) {
        TierInfo[] memory tierInfoArray = new TierInfo[](3);
        tierInfoArray[0] = tierInfo[1];
        tierInfoArray[1] = tierInfo[2];
        tierInfoArray[2] = tierInfo[3];
        return abi.encode(tierInfoArray);
    }

    /// @dev allows user to convert tier prices or tier unlock periods to bytes for using in update functions.
    /// @param tierOne The price(in wei) or lockup period (in seconds) for tier 1.
    /// @param tierTwo The price(in wei) or lockup period (in seconds) for tier 2.
    /// @param tierThree The price(in wei) or lockup period (in seconds) for tier 3.
    function convertTierInfoToBytes(
        uint256 tierOne,
        uint256 tierTwo,
        uint256 tierThree
    ) external pure returns (bytes memory) {
        return abi.encode(tierOne, tierTwo, tierThree);
    }

    /// @dev Updates the maximum allowed quantity for the whitelist.
    /// @param _maxAllowlistQuantity The new maximum allowed quantity for the whitelist.
    /// @notice This function can only be called by the contract's admin.
    function updateMaxAllowlistQuantity(
        uint256 _maxAllowlistQuantity
    ) external onlyAdmin {
        maxAllowlistQuantity = _maxAllowlistQuantity;
    }

    /// @dev Updates the maximum allowed quantity for the public mint.
    /// @param _maxPublicMintQuantity The new maximum allowed quantity for the public mint.
    /// @notice This function can only be called by the contract's admin.
    function updateMaxPublicMintQuantity(
        uint256 _maxPublicMintQuantity
    ) external onlyAdmin {
        maxPublicMintQuantity = _maxPublicMintQuantity;
    }

    //////////////////////////
    // MODIFIERS //
    //////////////////////////
    /// @dev Modifier that restricts access to only the contract's admin.
    modifier onlyAdmin() {
        require(
            ICre8ors(collectionAddress).isAdmin(msg.sender),
            "IERC721Drop: Access restricted to admin"
        );
        _;
    }

    //////////////////////////
    // INTERNAL FUNCTIONS ////
    //////////////////////////

    /// @dev Calculates the maximum allowed quantity based on the current timestamp and the public sale start time.
    /// @param totalClaimedFree The base starting point for calculating the maximum allowed quantity.
    /// @return The maximum allowed quantity based on the current timestamp and the public sale start time.
    function maxAllowedQuantity(
        uint256 totalClaimedFree
    ) internal view returns (uint256) {
        uint256 currentTimestamp = block.timestamp;
        uint256 publicSaleStart = ICre8ors(collectionAddress)
            .saleDetails()
            .publicSaleStart;
        uint256 preSaleStart = ICre8ors(collectionAddress)
            .saleDetails()
            .presaleStart;
        if (currentTimestamp < publicSaleStart) {
            return maxAllowlistQuantity + totalClaimedFree;
        }
        if (totalClaimedFree > 0) {
            return
                maxAllowlistQuantity + maxPublicMintQuantity + totalClaimedFree;
        }
        return maxPublicMintQuantity + totalClaimedFree;
    }
}

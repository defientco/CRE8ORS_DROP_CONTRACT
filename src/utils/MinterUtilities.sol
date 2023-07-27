// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;
import {IERC721A} from "lib/ERC721A/contracts/interfaces/IERC721A.sol";
import {ICre8ors} from "../interfaces/ICre8ors.sol";
import {IERC721Drop} from "../interfaces/IERC721Drop.sol";
import {ICollectionHolderMint} from "../interfaces/ICollectionHolderMint.sol";
import {FriendsAndFamilyMinter} from "../minter/FriendsAndFamilyMinter.sol";
import {IMinterUtilities} from "../interfaces/IMinterUtilities.sol";

contract MinterUtilities {
    /**
     * @dev Emitted when the price of a tier is updated.
     * @param tier The tier whose price is updated.
     * @param price The new price for the tier.
     */
    event TierPriceUpdated(uint256 tier, uint256 price);

    /**
     * @dev Emitted when the lockup period of a tier is updated.
     * @param tier The tier whose lockup period is updated.
     * @param lockup The new lockup period for the tier.
     */
    event TierLockupUpdated(uint256 tier, uint256 lockup);

    /**
     * @dev Represents pricing and lockup information for a specific tier.
     */
    struct TierInfo {
        uint256 price;
        uint256 lockup;
    }
    /**
     * @dev Represents a tier and quantity of NFTs.
     */
    struct Cart {
        uint8 tier;
        uint256 quantity;
    }

    uint256 private _tier1DefaultPrice = 50000000000000000 wei; // 0.05 ether
    uint256 private _tier2DefaultPrice = 100000000000000000 wei; // 0.1 ether
    uint256 private _tier3DefaultPrice = 150000000000000000 wei; // 0.15 ether

    uint256 public maxAllowlistQuantity = 8;
    uint256 public maxPublicMintQuantity = 18;

    address public collectionAddress;

    /* 08/10/2023 @ 7:59:59 am (EST) */
    uint256 public timeBeforePublicMint = 1691668799;

    mapping(uint8 => TierInfo) public tierInfo;

    constructor(address _collectionAddress) {
        collectionAddress = _collectionAddress;
        tierInfo[1] = TierInfo(_tier1DefaultPrice, 8 weeks);
        tierInfo[2] = TierInfo(_tier2DefaultPrice, 52 weeks);
        tierInfo[3] = TierInfo(_tier3DefaultPrice, 0 weeks);
    }

    /**
     * @dev Calculates the total price for a given quantity of NFTs in a specific tier.
     * @param tier The tier to calculate the price for.
     * @param quantity The quantity of NFTs to calculate the price for.
     * @return The total price in wei for the given quantity in the specified tier.
     */
    function calculatePrice(
        uint8 tier,
        uint256 quantity
    ) public view returns (uint256) {
        uint256 price = tierInfo[tier].price * quantity;
        return price;
    }

    /**
     * @dev Converts an amount from ether to gwei (1 ether = 10^9 gwei).
     * @param value The amount in ether to convert to gwei.
     * @return The equivalent amount in gwei.
     */
    function etherToGwei(uint256 value) public pure returns (uint256) {
        return value * 10 ** 9;
    }

    /**
     * @dev Returns the quantity of NFTs left that can be minted by the given recipient.
     * @param passportHolderMinter The address of the PassportHolderMinter contract.
     * @param friendsAndFamilyMinter The address of the FriendsAndFamilyMinter contract.
     * @param target The address of the target contract (ICre8ors contract).
     * @param recipient The recipient's address.
     * @return The quantity of NFTs that can still be minted by the recipient.
     */
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
        uint256 maxClaimedFree = passportMinter.maxClaimedFree(recipient) +
            friendsAndFamily.maxClaimedFree(recipient);
        uint256 maxQuantity = maxAllowedQuantity(maxClaimedFree);
        uint256 quantityRemaining = maxQuantity - totalMints;

        if (quantityRemaining < 0) {
            return 0;
        }
        return quantityRemaining;
    }

    function maxAllowedQuantity(
        uint256 startingPoint
    ) internal view returns (uint256) {
        if (block.timestamp < timeBeforePublicMint) {
            return maxAllowlistQuantity + startingPoint;
        }
        return maxPublicMintQuantity + startingPoint;
    }

    /**
     * @dev Calculates the total cost for a given list of NFTs in different tiers.
     * @param carts An array of Cart struct representing the tiers and quantities.
     * @return The total cost in wei for the given list of NFTs.
     */
    function calculateTotalCost(
        Cart[] calldata carts
    ) external view returns (uint256) {
        uint256 totalCost = 0;
        for (uint256 i = 0; i < carts.length; i++) {
            totalCost += calculatePrice(carts[i].tier, carts[i].quantity);
        }
        return totalCost;
    }

    /**
     * @dev Calculates the lockup period for a specific tier.
     * @param tier The tier to calculate the lockup period for.
     * @return The lockup period in seconds for the specified tier.
     */
    function calculateLockupDate(uint8 tier) external view returns (uint256) {
        if (tier == 1) {
            return 8 weeks;
        } else if (tier == 2) {
            return 52 weeks;
        }
    }

    /**
     * @dev Calculates the total quantity of NFTs in a given list of Cart structs.
     * @param carts An array of Cart struct representing the tiers and quantities.
     * @return The total quantity of NFTs in the given list of carts.
     */
    function calculateTotalQuantity(
        Cart[] calldata carts
    ) public view returns (uint256) {
        uint256 totalQuantity = 0;
        for (uint256 i = 0; i < carts.length; i++) {
            totalQuantity += carts[i].quantity;
        }
        return totalQuantity;
    }

    /**
     * @dev Updates the prices for all tiers in the MinterUtilities contract.
     * @param tierPrices A bytes array representing the new prices for all tiers (in wei).
     */
    function updateAllTierPrices(bytes calldata tierPrices) external onlyAdmin {
        (uint256 tier1, uint256 tier2, uint256 tier3) = abi.decode(
            tierPrices,
            (uint256, uint256, uint256)
        );
        tierInfo[1].price = tier1;
        tierInfo[2].price = tier2;
        tierInfo[3].price = tier3;
    }

    /**
     * @dev Updates the price for Tier 1.
     * @param _tier1 The new price for Tier 1 (in gwei).
     */
    function updateTierOnePrice(uint256 _tier1) external onlyAdmin {
        tierInfo[1].price = _tier1;
        emit TierPriceUpdated(1, _tier1);
    }

    /**
     * @dev Updates the price for Tier 2.
     * @param _tier2 The new price for Tier 2 (in gwei).
     */
    function updateTierTwoPrice(uint256 _tier2) external onlyAdmin {
        tierInfo[2].price = _tier2;
        emit TierPriceUpdated(2, _tier2);
    }

    /**
     * @dev Updates the price for Tier 3.
     * @param _tier3 The new price for Tier 3 (in gwei).
     */
    function updateTierThreePrice(uint256 _tier3) external onlyAdmin {
        tierInfo[3].price = _tier3;
        emit TierPriceUpdated(3, _tier3);
    }

    /**
     * @dev Sets new default lockup periods for all tiers.
     * @param lockupInfo A bytes array representing the new lockup periods for all tiers (in weeks).
     */
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

    function getTierInfo(uint8 tier) external view returns (TierInfo memory) {
        return tierInfo[tier];
    }

    /**
     * @dev Updates the lockup period for Tier 1.
     * @param _tier1 The new lockup period for Tier 1 (in weeks).
     */
    function updateTierOneLockup(uint256 _tier1) external onlyAdmin {
        tierInfo[1].lockup = _tier1;
        emit TierLockupUpdated(1, _tier1);
    }

    /**
     * @dev Updates the lockup period for Tier 2.
     * @param _tier2 The new lockup period for Tier 2 (in weeks).
     */
    function updateTierTwoLockup(uint256 _tier2) external onlyAdmin {
        tierInfo[2].lockup = _tier2;
        emit TierLockupUpdated(2, _tier2);
    }

    /**
     * @dev Updates the maximum allowed quantity for the allowlist.
     * @param _maxAllowlistQuantity The new maximum allowed quantity for the allowlist.
     */
    function updateMaxAllowlistQuantity(
        uint256 _maxAllowlistQuantity
    ) external onlyAdmin {
        maxAllowlistQuantity = _maxAllowlistQuantity;
    }

    function updateMaxPublicMintQuantity(
        uint256 _maxPublicMintQuantity
    ) external onlyAdmin {
        maxPublicMintQuantity = _maxPublicMintQuantity;
    }

    modifier onlyAdmin() {
        if (!ICre8ors(collectionAddress).isAdmin(msg.sender)) {
            revert IERC721Drop.Access_OnlyAdmin();
        }

        _;
    }
}

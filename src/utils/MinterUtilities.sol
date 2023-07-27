// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;
import {IERC721A} from "lib/ERC721A/contracts/interfaces/IERC721A.sol";
import {ICre8ors} from "../interfaces/ICre8ors.sol";
import {IERC721Drop} from "../interfaces/IERC721Drop.sol";
import {ICollectionHolderMint} from "../interfaces/ICollectionHolderMint.sol";
import {FriendsAndFamilyMinter} from "../minter/FriendsAndFamilyMinter.sol";
import {IMinterUtilities} from "../interfaces/IMinterUtilities.sol";

contract MinterUtilities {
    event TierPriceUpdated(uint256 tier, uint256 price);

    event TierLockupUpdated(uint256 tier, uint256 lockup);

    struct TierInfo {
        uint256 price;
        uint256 lockup;
    }

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
        tierInfo[1] = TierInfo(_tier1DefaultPrice, 32 weeks);
        tierInfo[2] = TierInfo(_tier2DefaultPrice, 8 weeks);
        tierInfo[3] = TierInfo(_tier3DefaultPrice, 0 weeks);
    }

    function calculatePrice(
        uint8 tier,
        uint256 quantity
    ) public view returns (uint256) {
        uint256 price = tierInfo[tier].price * quantity;
        return price;
    }

    function etherToGwei(uint256 value) public pure returns (uint256) {
        return value * 10 ** 9;
    }

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

    function calculateTotalCost(
        Cart[] calldata carts
    ) external view returns (uint256) {
        uint256 totalCost = 0;
        for (uint256 i = 0; i < carts.length; i++) {
            totalCost += calculatePrice(carts[i].tier, carts[i].quantity);
        }
        return totalCost;
    }

    function calculateLockupDate(uint8 tier) external view returns (uint256) {
        return block.timestamp + tierInfo[tier].lockup;
    }

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

    function updateAllTierPrices(bytes calldata tierPrices) external onlyAdmin {
        (uint256 tier1, uint256 tier2, uint256 tier3) = abi.decode(
            tierPrices,
            (uint256, uint256, uint256)
        );
        tierInfo[1].price = tier1;
        tierInfo[2].price = tier2;
        tierInfo[3].price = tier3;
    }

    function updateTierOnePrice(uint256 _tier1) external onlyAdmin {
        tierInfo[1].price = _tier1;
        emit TierPriceUpdated(1, _tier1);
    }

    function updateTierTwoPrice(uint256 _tier2) external onlyAdmin {
        tierInfo[2].price = _tier2;
        emit TierPriceUpdated(2, _tier2);
    }

    function updateTierThreePrice(uint256 _tier3) external onlyAdmin {
        tierInfo[3].price = _tier3;
        emit TierPriceUpdated(3, _tier3);
    }

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

    function updateTierOneLockup(uint256 _tier1) external onlyAdmin {
        tierInfo[1].lockup = _tier1;
        emit TierLockupUpdated(1, _tier1);
    }

    function updateTierTwoLockup(uint256 _tier2) external onlyAdmin {
        tierInfo[2].lockup = _tier2;
        emit TierLockupUpdated(2, _tier2);
    }

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

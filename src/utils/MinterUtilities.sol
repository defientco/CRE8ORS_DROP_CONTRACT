// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;
import {ICre8ors} from "../interfaces/ICre8ors.sol";
import {PassportHolderMinter} from "../minter/PassportHolderMinter.sol";
import {FriendsAndFamilyMinter} from "../minter/FriendsAndFamilyMinter.sol";

contract MinterUtilities {
    uint256 _tier3 = 0.15 ether;
    uint256 _tier2 = 0.05 ether;
    uint256 _tier1 = 0.01 ether;

    uint256 public maxAllowlistQuantity = 8;
    uint256 public maxPublicMintQuantity = 88;

    struct Cart {
        uint8 tier;
        uint256 quantity;
    }
    /* 08/10/2023 @ 7:59:59 am (EST) */
    uint256 public timeBeforePublicMint = 1691668799;

    mapping(uint8 => uint256) public tierPrices;

    function calculatePrice(
        uint8 tier,
        uint256 quantity
    ) view returns (uint256) {
        uint256 price = etherToWei(tierPrices[tier]) * quantity;
        return price;
    }

    function etherToWei(uint256 value) public pure returns (uint256) {
        return value * 10 ** 18;
    }

    function quantityLeft(
        address passportHolderMinter,
        address friendsAndFamilyMinter,
        address target,
        address recipient
    ) view returns (uint256) {
        ICre8ors cre8ors = ICre8ors(target);
        PassportHolderMinter passportMinter = PassportHolderMinter(
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

    function maxAllowedQuantity(uint256 startingPoint) view returns (uint256) {
        if (block.timestamp < timeBeforePublicMint) {
            return maxAllowlistQuantity + startingPoint;
        }
        return maxPublicMintQuantity + startingPoint;
    }

    function calculateTotalCost(Cart[] calldata carts) view returns (uint256) {
        uint256 totalCost = 0;
        for (uint256 i = 0; i < carts.length; i++) {
            totalCost += calculatePrice(carts[i].tier, carts[i].quantity);
        }
        return totalCost;
    }

    function calculateLockupDate(uint8 tier) view returns (uint256) {
        if (tier == 1) {
            return 8 weeks;
        } else if (tier == 2) {
            return 52 weeks;
        }
    }

    function calculateTotalQuantity(
        Cart[] calldata carts
    ) view returns (uint256) {
        uint256 totalQuantity = 0;
        for (uint256 i = 0; i < carts.length; i++) {
            totalQuantity += carts[i].quantity;
        }
        return totalQuantity;
    }
}

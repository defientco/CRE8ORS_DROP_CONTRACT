// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;
import {IMinterUtilities} from "../interfaces/IMinterUtilities.sol";
import {ILockup} from "../interfaces/ILockup.sol";
import {ICre8ors} from "../interfaces/ICre8ors.sol";

contract SharedPaidMinterFunctions {
    address public cre8orsNFT;
    address public minterUtility;
    modifier verifyCost(IMinterUtilities.Cart[] memory carts) {
        uint256 totalCost = IMinterUtilities(minterUtility).calculateTotalCost(
            carts
        );
        require(msg.value >= totalCost, "Not enough ETH sent");
        _;
    }

    function _lockUp(
        IMinterUtilities.Cart[] memory carts,
        uint256 startingTokenId
    ) internal {
        ILockup lockup = ICre8ors(cre8orsNFT).lockup();
        if (address(lockup) == address(0)) {
            return;
        }
        uint256 tokenId = startingTokenId;
        for (uint256 i = 0; i < carts.length; i++) {
            if (carts[i].tier == 3) {
                continue;
            }
            (uint256 lockupDate, uint256 tierPrice) = abi.decode(
                _getLockUpDateAndPrice(carts[i].tier),
                (uint256, uint256)
            );
            lockup.setUnlockInfo(
                cre8orsNFT,
                tokenId + i,
                abi.encode(lockupDate, tierPrice)
            );
        }
    }

    function _getLockUpDateAndPrice(
        uint256 tier
    ) internal view returns (bytes memory) {
        (
            IMinterUtilities.TierInfo memory tier1,
            IMinterUtilities.TierInfo memory tier2,
            IMinterUtilities.TierInfo memory tier3
        ) = abi.decode(
                IMinterUtilities(minterUtility).getTierInfo(),
                (
                    IMinterUtilities.TierInfo,
                    IMinterUtilities.TierInfo,
                    IMinterUtilities.TierInfo
                )
            );
        uint256 lockupDate;
        uint256 tierPrice;
        if (tier == 1) {
            lockupDate = block.timestamp + tier1.lockup;
            tierPrice = tier1.price;
        } else if (tier == 2) {
            lockupDate = block.timestamp + tier2.lockup;
            tierPrice = tier2.price;
        } else {
            lockupDate = block.timestamp + tier3.lockup;
            tierPrice = tier3.price;
        }
        return abi.encode(lockupDate, tierPrice);
    }
}

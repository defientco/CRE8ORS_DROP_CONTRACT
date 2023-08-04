// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;
import {IMinterUtilities} from "../interfaces/IMinterUtilities.sol";
import {ILockup} from "../interfaces/ILockup.sol";
import {ICre8ors} from "../interfaces/ICre8ors.sol";
import {IERC721Drop} from "../interfaces/IERC721Drop.sol";
import {ICre8ing} from "../interfaces/ICre8ing.sol";
import {ISharedPaidMinterFunctions} from "../interfaces/ISharedPaidMinterFunctions.sol";

contract SharedPaidMinterFunctions is ISharedPaidMinterFunctions {
    address public cre8orsNFT;
    address public minterUtility;
    address public collectionHolderMint;
    address public friendsAndFamilyMinter;

    modifier verifyCost(IMinterUtilities.Cart[] memory carts) {
        uint256 totalCost = IMinterUtilities(minterUtility).calculateTotalCost(
            carts
        );
        if (msg.value < totalCost) {
            revert IERC721Drop.Purchase_WrongPrice(totalCost);
        }
        _;
    }
    modifier onlyValidTier(uint256 tier) {
        if (tier < 1 || tier > 3) {
            revert InvalidTier();
        }
        _;
    }
    /// @dev Modifier that restricts access to only the contract's admin.
    modifier onlyAdmin() {
        if (!ICre8ors(cre8orsNFT).isAdmin(msg.sender)) {
            revert IERC721Drop.Access_OnlyAdmin();
        }
        _;
    }

    function _lockUp(
        IMinterUtilities.Cart[] memory carts,
        uint256 startingTokenId
    ) internal {
        uint256 tokenId = startingTokenId;
        for (uint256 i = 0; i < carts.length; i++) {
            if (carts[i].tier == 3) {
                continue;
            }
            (uint256 lockupDate, uint256 tierPrice) = abi.decode(
                _getLockUpDateAndPrice(carts[i].tier),
                (uint256, uint256)
            );
            uint256[] memory tokenIds = new uint256[](carts[i].quantity);
            for (uint256 j = 0; j < carts[i].quantity; j++) {
                tokenIds[j] = tokenId;
                tokenId++;
            }
            ICre8ors(cre8orsNFT).cre8ing().inializeStakingAndLockup(
                cre8orsNFT,
                tokenIds,
                abi.encode(lockupDate, tierPrice)
            );
        }
    }

    function _getLockUpDateAndPrice(
        uint256 tier
    ) internal view onlyValidTier(tier) returns (bytes memory) {
        IMinterUtilities.TierInfo[] memory tiers = abi.decode(
            IMinterUtilities(minterUtility).getTierInfo(),
            (IMinterUtilities.TierInfo[])
        );

        IMinterUtilities.TierInfo memory selectedTier = tiers[tier - 1];
        uint256 lockupDate = block.timestamp + selectedTier.lockup;
        uint256 tierPrice = selectedTier.price;

        return abi.encode(lockupDate, tierPrice);
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import {MinterUtilities} from "../utils/MinterUtilities.sol";
import {ICre8ors} from "../interfaces/ICre8ors.sol";
import {ILockup} from "../interfaces/ILockup.sol";
import {IERC721A} from "lib/ERC721A/contracts/interfaces/IERC721A.sol";
import {IERC721Drop} from "../interfaces/IERC721Drop.sol";
import {MerkleProof} from "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import {IMinterUtilities} from "../interfaces/IMinterUtilities.sol";
import {IAllowlistMinter} from "../interfaces/IAllowlistMinter.sol";

contract AllowlistMinter is IAllowlistMinter {
    address public cre8orsNFT;
    address public minterUtility;

    constructor(address _cre8orsNFT, address _minterUtility) {
        cre8orsNFT = _cre8orsNFT;
        minterUtility = _minterUtility;
    }

    function mintPfp(
        address recipient,
        IMinterUtilities.Cart[] memory carts,
        address passportHolderMinter,
        address friendsAndFamilyMinter,
        bytes32[] calldata merkleProof
    ) external payable returns (uint256) {
        if (
            !MerkleProof.verify(
                merkleProof,
                IERC721Drop(cre8orsNFT).saleDetails().presaleMerkleRoot,
                keccak256(
                    abi.encode(
                        recipient,
                        uint256(8),
                        uint256(150000000000000000)
                    )
                )
            )
        ) {
            revert IERC721Drop.Presale_MerkleNotApproved();
        }

        IMinterUtilities minterUtilities = IMinterUtilities(minterUtility);

        uint256 quantity = minterUtilities.calculateTotalQuantity(carts);
        uint256 remainingMints = minterUtilities.quantityLeft(
            passportHolderMinter,
            friendsAndFamilyMinter,
            cre8orsNFT,
            recipient
        );
        if (remainingMints == 0) {
            revert NoMoreMintsLeft();
        }

        if (quantity > remainingMints) {
            revert IERC721Drop.Presale_TooManyForAddress();
        }

        uint256 totalCost = minterUtilities.calculateTotalCost(carts);
        if (msg.value < totalCost) {
            revert IERC721Drop.Purchase_WrongPrice(totalCost);
        }

        uint256 pfpTokenId = ICre8ors(cre8orsNFT).adminMint(
            recipient,
            quantity
        );
        payable(address(cre8orsNFT)).call{value: msg.value}("");
        uint256 startingTokenId = pfpTokenId - quantity + 1;
        ILockup lockup = ICre8ors(cre8orsNFT).lockup();
        if (address(lockup) != address(0)) {
            _lockUp(lockup, carts, startingTokenId, minterUtilities);
        }
        return pfpTokenId;
    }

    function _lockUp(
        ILockup lockup,
        IMinterUtilities.Cart[] memory carts,
        uint256 startingTokenId,
        IMinterUtilities minterUtilities
    ) internal {
        uint256 tier1Lockupdate = minterUtilities.calculateLockupDate(1);
        uint256 tier2Lockupdate = minterUtilities.calculateLockupDate(2);
        uint256 tier3Lockupdate = minterUtilities.calculateLockupDate(3);
        uint256 tier1Price = minterUtilities.getTierInfo(1).price;
        uint256 tier2Price = minterUtilities.getTierInfo(2).price;
        uint256 tier3Price = minterUtilities.getTierInfo(3).price;
        for (uint256 i = 0; i < carts.length; i++) {
            if (carts[i].tier == 3) {
                continue;
            }
            uint256 lockupDate;
            uint256 tierPrice;
            if (carts[i].tier == 1) {
                lockupDate = tier1Lockupdate;
                tierPrice = tier1Price;
            } else if (carts[i].tier == 2) {
                lockupDate = tier2Lockupdate;
                tierPrice = tier2Price;
            } else if (carts[i].tier == 3) {
                lockupDate = tier3Lockupdate;
                tierPrice = tier3Price;
            }
            lockup.setUnlockInfo(
                cre8orsNFT,
                startingTokenId,
                abi.encode(lockupDate, tierPrice)
            );
            startingTokenId += 1;
        }
    }
}

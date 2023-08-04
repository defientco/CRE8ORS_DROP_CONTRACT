// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import {MinterUtilities} from "../utils/MinterUtilities.sol";
import {ICre8ors} from "../interfaces/ICre8ors.sol";
import {ILockup} from "../interfaces/ILockup.sol";
import {IERC721A} from "lib/ERC721A/contracts/interfaces/IERC721A.sol";
import {IERC721Drop} from "../interfaces/IERC721Drop.sol";
import {MerkleProof} from "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import {IMinterUtilities} from "../interfaces/IMinterUtilities.sol";
import {IFriendsAndFamilyMinter} from "../interfaces/IFriendsAndFamilyMinter.sol";
import {ICollectionHolderMint} from "../interfaces/ICollectionHolderMint.sol";
import {SharedPaidMinterFunctions} from "../utils/SharedPaidMinterFunctions.sol";

contract AllowlistMinter is SharedPaidMinterFunctions {
    constructor(
        address _cre8orsNFT,
        address _minterUtility,
        address _collectionHolderMint,
        address _friendsAndFamilyMinter
    ) {
        cre8orsNFT = _cre8orsNFT;
        minterUtility = _minterUtility;
        collectionHolderMint = _collectionHolderMint;
        friendsAndFamilyMinter = _friendsAndFamilyMinter;
    }

    function mintPfp(
        address recipient,
        IMinterUtilities.Cart[] memory carts,
        bytes32[] calldata merkleProof
    )
        external
        payable
        onlyPreSaleOrAlreadyMinted(recipient)
        checkProof(recipient, merkleProof)
        verifyCost(carts)
        returns (uint256)
    {
        uint256 quantity = IMinterUtilities(minterUtility)
            .calculateTotalQuantity(carts);
        address _recipient = recipient; /// @dev to avoid stack too deep error
        if (
            quantity >
            IMinterUtilities(minterUtility).quantityLeft(
                collectionHolderMint,
                friendsAndFamilyMinter,
                cre8orsNFT,
                _recipient
            )
        ) {
            revert IERC721Drop.Presale_TooManyForAddress();
        }

        uint256 pfpTokenId = ICre8ors(cre8orsNFT).adminMint(
            _recipient,
            quantity
        );
        payable(address(cre8orsNFT)).call{value: msg.value}("");

        _lockUp(carts, pfpTokenId - quantity + 1);

        return pfpTokenId;
    }

    modifier checkProof(address _recipient, bytes32[] calldata merkleProof) {
        if (
            !MerkleProof.verify(
                merkleProof,
                IERC721Drop(cre8orsNFT).saleDetails().presaleMerkleRoot,
                keccak256(
                    abi.encode(
                        _recipient,
                        uint256(8),
                        uint256(150000000000000000)
                    )
                )
            )
        ) {
            revert IERC721Drop.Presale_MerkleNotApproved();
        }
        _;
    }

    modifier onlyPreSaleOrAlreadyMinted(address recipient) {
        if (
            ICre8ors(cre8orsNFT).saleDetails().presaleStart > block.timestamp &&
            ICollectionHolderMint(collectionHolderMint).totalClaimed(
                recipient
            ) ==
            0 &&
            IFriendsAndFamilyMinter(friendsAndFamilyMinter).totalClaimed(
                recipient
            ) ==
            0
        ) {
            revert IERC721Drop.Presale_Inactive();
        }
        _;
    }
}

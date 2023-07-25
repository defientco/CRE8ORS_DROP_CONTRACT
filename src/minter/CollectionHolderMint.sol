// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;
import {IERC721A} from "lib/ERC721A/contracts/interfaces/IERC721A.sol";
import {ICre8ors} from "../interfaces/ICre8ors.sol";
import {ILockup} from "../interfaces/ILockup.sol";
import {MerkleProof} from "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

contract CollectionHolderMint {
    mapping(uint256 => bool) public freeMintClaimed;
    mapping(address => uint256) public quantityMinted;

    address public _collectionContractAddress;

    uint256 private _month = 4 weeks;

    constructor(address collectionContractAddress) {
        _collectionContractAddress = collectionContractAddress;
    }

    /**
    thrown when a user attempts to perform 
    an action on a token or an asset that they do not own 
    */
    error NotOwnerOfToken();

    /**
    thrown when a user attempts to claim a free mint or allocation, 
    but they have already done so previously.
    */
    error AlreadyClaimedFreeMint();

    /**
     * @dev Mint function to create a new token, assign it to the specified recipient, and trigger additional actions.
     *
     * This function creates a new token with the given `tokenId` and assigns it to the `recipient` address.
     * It requires the `tokenId` to be eligible for a free mint, and the caller must be the owner of the specified `tokenId`
     * to successfully execute the minting process.
     *
     * After the minting process, the function performs the following actions:
     * 1. Calls the `adminMint` function from the `ICre8ors` contract to create a corresponding PFP (Profile Picture) token
     *    for the `recipient` address. The newly minted PFP token ID is returned and stored in `pfpTokenId`.
     * 2. If a valid lockup contract is associated with the `target` address, this function sets the unlock information for
     *    the newly minted PFP token using the `setUnlockInfo` function of the `lockup` contract. The unlock information
     *    includes the lockup duration (8 weeks) and the lockup amount (0.15 ether).
     *
     * @param tokenId The ID of the token to be minted.
     * @param target The address of the `ICre8ors` contract that will handle the minting and PFP token creation.
     * @param recipient The address to whom the newly minted token will be assigned.
     * @return pfpTokenId The ID of the corresponding PFP token that was minted for the `recipient`.
     *
     * Requirements:
     * - The caller must be the owner of the token specified by `tokenId`.
     * - The `tokenId` must be eligible for a free mint, indicated by the `hasFreeMint` modifier.
     *
     * Note: This function is external, which means it can only be called from outside the contract.
     */
    function mint(
        uint256 tokenId,
        address target,
        address recipient,
        bytes32[] calldata merkleProof
    )
        external
        onlyTokenOwner(tokenId, recipient)
        hasFreeMint(tokenId)
        returns (uint256)
    {
        bytes32[] merkleRoot = ICre8ors(_collectionContractAddress)
            .salesConfig
            .presaleMerkleRoot;
        if (
            MerkleProof.verify(
                merkleProof,
                merkleRoot,
                keccak256(abi.encodePacked(tokenId, recipient))
            )
        ) {
            revert("Invalid Merkle Proof");
        }
        uint256 pfpTokenId = ICre8ors(target).adminMint(recipient, 1);
        quantityMinted[recipient] += 1;

        ILockup lockup = ICre8ors(target).lockup();
        if (address(lockup) != address(0)) {
            uint256 lockupDate = 8 weeks;
            bytes memory data = abi.encode(lockupDate, 0.15 ether);
            lockup.setUnlockInfo(target, pfpTokenId, data);
        }

        freeMintClaimed[tokenId] = true;
        return pfpTokenId;
    }

    /**
     * @dev Modifier to check if the caller is the owner of a specific token.
     *
     * This modifier is used to validate whether the `recipient` address provided as an argument is the actual owner
     * of the token with the given `tokenId`. If the condition is not met, the modifier will revert the transaction
     * with the "NotOwnerOfToken()" error.
     *
     * @param tokenId The ID of the token to check ownership for.
     * @param recipient The address that should be the owner of the token.
     *
     * Requirements:
     * - The `recipient` address must be the current owner of the token specified by `tokenId`.
     */
    modifier onlyTokenOwner(uint256 tokenId, address recipient) {
        if (
            IERC721A(_collectionContractAddress).ownerOf(tokenId) != recipient
        ) {
            revert NotOwnerOfToken();
        }
        _;
    }

    /**
     * @dev Modifier to check if a token is eligible for a free mint.
     *
     * This modifier is used to verify whether a token with the given `tokenId` is eligible for a free mint.
     * It checks if the `tokenId` has already been claimed for a free mint by accessing the `freeMintClaimed` mapping.
     * If the token has already been claimed, the modifier will revert the transaction with the "AlreadyClaimedFreeMint()" error.
     *
     * @param tokenId The ID of the token to check for free mint eligibility.
     *
     * Requirements:
     * - The `tokenId` must not have been claimed for a free mint.
     */
    modifier hasFreeMint(uint256 tokenId) {
        if (freeMintClaimed[tokenId]) {
            revert AlreadyClaimedFreeMint();
        }
        _;
    }
}

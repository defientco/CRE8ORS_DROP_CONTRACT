// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;
import {IERC721A} from "lib/ERC721A/contracts/interfaces/IERC721A.sol";
import {ICre8ors} from "../interfaces/ICre8ors.sol";
import {ILockup} from "../interfaces/ILockup.sol";
import {IERC721Drop} from "../interfaces/IERC721Drop.sol";
import {IMinterUtilities} from "../interfaces/IMinterUtilities.sol";

contract CollectionHolderMint {
    ///@notice Mapping to track whether a specific uint256 value (token ID) has been claimed or not.
    mapping(uint256 => bool) public freeMintClaimed;

    ///@notice The address of the collection contract that mints and manages the tokens.
    address public collectionContractAddress;

    ///@notice The address of the minter utility contract that contains shared utility info.
    address public minterUtilityContractAddress;

    ///@notice mapping of address to quantity of free mints claimed.
    mapping(address => uint256) public maxClaimedFree;

    /**
     * @param _collectionContractAddress The address of the collection contract that mints and manages the tokens.
     * @param _minterUtility The address of the minter utility contract that contains shared utility info.
     */
    constructor(address _collectionContractAddress, address _minterUtility) {
        collectionContractAddress = _collectionContractAddress;
        minterUtilityContractAddress = _minterUtility;
    }

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
     * @param passportContract The address of the Passport contract that will check if owner of passport is same as recipient.
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
        address passportContract,
        address recipient
    )
        external
        onlyTokenOwner(passportContract, tokenId, recipient)
        hasFreeMint(tokenId)
        returns (uint256)
    {
        uint256 pfpTokenId = ICre8ors(collectionContractAddress).adminMint(
            recipient,
            1
        );
        maxClaimedFree[recipient] += 1;

        ILockup lockup = ICre8ors(collectionContractAddress).lockup();
        if (address(lockup) != address(0)) {
            IMinterUtilities minterUtility = IMinterUtilities(
                minterUtilityContractAddress
            );

            uint256 lockupDate = block.timestamp + 8 weeks;
            uint256 unlockPrice = minterUtility.calculateUnlockPrice(1, true);
            bytes memory data = abi.encode(lockupDate, unlockPrice);
            lockup.setUnlockInfo(collectionContractAddress, pfpTokenId, data);
        }

        freeMintClaimed[tokenId] = true;
        return pfpTokenId;
    }

    /**
     * @notice Set New Minter Utility Contract Address
     * @notice Allows the admin to set a new address for the Minter Utility Contract.
     * @param _newMinterUtilityContractAddress The address of the new Minter Utility Contract.
     * @dev Only the admin can call this function.
     */
    function setNewMinterUtilityContractAddress(
        address _newMinterUtilityContractAddress
    ) external onlyAdmin {
        minterUtilityContractAddress = _newMinterUtilityContractAddress;
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
    modifier onlyTokenOwner(
        address passportContract,
        uint256 tokenId,
        address recipient
    ) {
        if (IERC721A(passportContract).ownerOf(tokenId) != recipient) {
            revert IERC721A.ApprovalCallerNotOwnerNorApproved();
        }
        _;
    }

    modifier onlyAdmin() {
        if (!ICre8ors(collectionContractAddress).isAdmin(msg.sender)) {
            revert IERC721Drop.Access_OnlyAdmin();
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

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;
import {ICollectionHolderMint} from "../interfaces/ICollectionHolderMint.sol";
import {ICre8ors} from "../interfaces/ICre8ors.sol";
import {IERC721A} from "lib/ERC721A/contracts/interfaces/IERC721A.sol";
import {IERC721Drop} from "../interfaces/IERC721Drop.sol";
import {IFriendsAndFamilyMinter} from "../interfaces/IFriendsAndFamilyMinter.sol";
import {ILockup} from "../interfaces/ILockup.sol";
import {IMinterUtilities} from "../interfaces/IMinterUtilities.sol";

contract CollectionHolderMint is ICollectionHolderMint {
    ///@notice Mapping to track whether a specific uint256 value (token ID) has been claimed or not.
    mapping(uint256 => bool) public freeMintClaimed;

    ///@notice The address of the collection contract that mints and manages the tokens.
    address public collectionContractAddress;

    ///@notice The address of the minter utility contract that contains shared utility info.
    address public minterUtilityContractAddress;

    ///@notice The address of the friends and family minter contract.
    address public friendsAndFamilyMinter;

    ///@notice mapping of address to quantity of free mints claimed.
    mapping(address => uint256) public totalClaimed;

    /**
     * @param _collectionContractAddress The address of the collection contract that mints and manages the tokens.
     * @param _minterUtility The address of the minter utility contract that contains shared utility info.
     */
    constructor(
        address _collectionContractAddress,
        address _minterUtility,
        address _friendsAndFamilyMinter
    ) {
        collectionContractAddress = _collectionContractAddress;
        minterUtilityContractAddress = _minterUtility;
        friendsAndFamilyMinter = _friendsAndFamilyMinter;
    }

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
     * @param tokenIds The IDs of passports.
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
        uint256[] calldata tokenIds,
        address passportContract,
        address recipient
    )
        external
        tokensPresentInList(tokenIds)
        onlyTokenOwner(passportContract, tokenIds, recipient)
        hasFreeMint(tokenIds)
        returns (uint256)
    {
        _friendsAndFamilyMint(recipient);

        return _passportMint(tokenIds, recipient);
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

    function setFriendsAndFamilyMinter(
        address _newfriendsAndFamilyMinterAddress
    ) external onlyAdmin {
        friendsAndFamilyMinter = _newfriendsAndFamilyMinterAddress;
    }

    /**
     * @notice toggle the free mint claim status of a token
     * @param tokenId passport token ID to toggle free mint claim status.
     */
    function toggleHasClaimedFreeMint(uint256 tokenId) external onlyAdmin {
        freeMintClaimed[tokenId] = !freeMintClaimed[tokenId];
    }

    ////////////////////////////////////////
    ////////////// MODIFIERS //////////////
    ///////////////////////////////////////

    modifier onlyTokenOwner(
        address passportContract,
        uint256[] calldata tokenIds,
        address recipient
    ) {
        for (uint256 i = 0; i < tokenIds.length; i++) {
            if (IERC721A(passportContract).ownerOf(tokenIds[i]) != recipient) {
                revert IERC721A.ApprovalCallerNotOwnerNorApproved();
            }
        }
        _;
    }

    modifier onlyAdmin() {
        if (!ICre8ors(collectionContractAddress).isAdmin(msg.sender)) {
            revert IERC721Drop.Access_OnlyAdmin();
        }

        _;
    }

    modifier hasFreeMint(uint256[] calldata tokenIds) {
        for (uint256 i = 0; i < tokenIds.length; i++) {
            if (freeMintClaimed[tokenIds[i]]) {
                revert AlreadyClaimedFreeMint();
            }
        }
        _;
    }

    modifier tokensPresentInList(uint256[] calldata tokenIds) {
        if (tokenIds.length == 0) {
            revert NoTokensProvided();
        }
        _;
    }

    ////////////////////////////////////////
    ////////// INTERNALFUNCTIONS //////////
    ///////////////////////////////////////

    function _setTokenIdsToClaimed(uint256[] calldata tokenIds) internal {
        for (uint256 i = 0; i < tokenIds.length; i++) {
            freeMintClaimed[tokenIds[i]] = true;
        }
    }

    function _lockAndStakeTokens(uint256[] calldata _tokenIds) internal {
        IMinterUtilities minterUtility = IMinterUtilities(
            minterUtilityContractAddress
        );
        uint256 lockupDate = block.timestamp + 8 weeks;
        uint256 unlockPrice = minterUtility.calculateUnlockPrice(1, true);
        bytes memory data = abi.encode(lockupDate, unlockPrice);
        ICre8ors(collectionContractAddress).cre8ing().inializeStakingAndLockup(
            collectionContractAddress,
            _tokenIds,
            data
        );
    }

    function _passportMint(
        uint256[] calldata _tokenIds,
        address recipient
    ) internal returns (uint256) {
        uint256 pfpTokenId = ICre8ors(collectionContractAddress).adminMint(
            recipient,
            _tokenIds.length
        );
        totalClaimed[recipient] += _tokenIds.length;
        _lockAndStakeTokens(_tokenIds);
        _setTokenIdsToClaimed(_tokenIds);
        return pfpTokenId;
    }

    function _friendsAndFamilyMint(address buyer) internal {
        IFriendsAndFamilyMinter ffMinter = IFriendsAndFamilyMinter(
            friendsAndFamilyMinter
        );

        if (ffMinter.hasDiscount(buyer)) {
            ffMinter.mint(buyer);
        }
    }
}

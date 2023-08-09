// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import {ICre8ors} from "../interfaces/ICre8ors.sol";
import {IERC721A} from "lib/ERC721A/contracts/interfaces/IERC721A.sol";
import {IERC721Drop} from "../interfaces/IERC721Drop.sol";
import {ILockup} from "../interfaces/ILockup.sol";
import {IMinterUtilities} from "../interfaces/IMinterUtilities.sol";
import {IFreeMinter} from "../interfaces/IFreeMinter.sol";
import {IERC721ACH} from "ERC721H/interfaces/IERC721ACH.sol";

contract FreeMinter is IFreeMinter {
    ///@notice Mapping to track whether a specific uint256 value (token ID) has been claimed or not.
    mapping(uint256 => bool) public freeMintClaimed;

    ///@notice The address of the collection contract that mints and manages the tokens.
    address public cre8orsNFT;

    ///@notice The address of the passport contract.
    address public passportContractAddress;

    ///@notice mapping of address to quantity of free mints claimed.
    mapping(address => uint256) public totalClaimed;

    ///@notice Mapping to track whether an address has discount for free mint.
    mapping(address => bool) public hasDiscount;

    constructor(
        address _cre8orsNFT,
        address _passportContractAddress,
        uint256[] memory _usedPassportTokenIds,
        address[] memory _discountClaimedAddresses
    ) {
        cre8orsNFT = _cre8orsNFT;
        passportContractAddress = _passportContractAddress;

        // set passports to have claimed a free mint
        for (uint256 i = 0; i < _usedPassportTokenIds.length; ) {
            freeMintClaimed[_usedPassportTokenIds[i]] = true;
            unchecked {
                ++i;
            }
        }

        // set addresses to have claimed a free mint
        for (uint256 i = 0; i < _usedPassportTokenIds.length; ) {
            address owner = IERC721A(_passportContractAddress).ownerOf(
                _usedPassportTokenIds[i]
            );
            totalClaimed[owner]++;
            unchecked {
                ++i;
            }
        }

        // set addresses to have used discount
        for (uint256 i = 0; i < _discountClaimedAddresses.length; ) {
            totalClaimed[_discountClaimedAddresses[i]]++;
            unchecked {
                ++i;
            }
        }
    }

    function mint(
        uint256[] calldata passportTokenIDs,
        address recipient
    )
        external
        noDuplicates(passportTokenIDs)
        onlyTokenOwner(passportTokenIDs, recipient)
        hasFreeMint(passportTokenIDs, recipient)
    {
        uint256 totalQuantity = _getTotalMintQuantity(
            passportTokenIDs,
            recipient
        );

        uint256[] memory _pfpTokenIds = _mint(recipient, totalQuantity);

        _lockup(_pfpTokenIds);

        totalClaimed[recipient] += totalQuantity;
        _setpassportTokenIDsToClaimed(passportTokenIDs);
        // Reset discount for the recipient
        hasDiscount[recipient] = false;
    }

    /// @dev Grants a discount to the specified array of recipients, allowing them to mint tokens without paying the regular price.
    /// @param recipient The address of the recipients who will receive the discount.
    function addDiscount(address[] memory recipient) external onlyAdmin {
        for (uint256 i = 0; i < recipient.length; ) {
            if (!hasDiscount[recipient[i]]) {
                hasDiscount[recipient[i]] = true;
            }
            unchecked {
                ++i;
            }
        }
    }

    /// @dev Removes the discount from the specified recipient, preventing them from minting tokens with a discount.
    /// @param recipient The address of the recipient whose discount will be removed.
    function removeDiscount(
        address recipient
    ) external onlyAdmin onlyExistingDiscount(recipient) {
        hasDiscount[recipient] = false;
    }

    //////////////////////////////////////////
    ////////////Internal Functions////////////
    //////////////////////////////////////////

    function _mint(
        address recipient,
        uint256 totalMintQuantity
    ) internal returns (uint256[] memory _pfpTokenIds) {
        uint256 pfpTokenId = ICre8ors(cre8orsNFT).adminMint(
            recipient,
            totalMintQuantity
        );
        _pfpTokenIds = new uint256[](totalMintQuantity);
        uint256 startingTokenId = pfpTokenId - totalMintQuantity + 1;
        for (uint256 i = 0; i < totalMintQuantity; ) {
            _pfpTokenIds[i] = startingTokenId + i;
            unchecked {
                ++i;
            }
        }
        return _pfpTokenIds;
    }

    function _lockup(uint256[] memory _pfpTokenIds) internal {
        ILockup lockup = ICre8ors(
            IERC721ACH(cre8orsNFT).getHook(
                IERC721ACH.HookType.BeforeTokenTransfers
            )
        ).cre8ing().lockUp(cre8orsNFT);
        uint256 lockupDate = block.timestamp + 8 weeks;
        uint256 unlockPrice = 0.15 ether;
        bytes memory data = abi.encode(lockupDate, unlockPrice);
        if (address(lockup) != address(0)) {
            for (uint256 i = 0; i < _pfpTokenIds.length; ) {
                lockup.setUnlockInfo(cre8orsNFT, _pfpTokenIds[i], data);
                unchecked {
                    ++i;
                }
            }
        }
    }

    function _getTotalMintQuantity(
        uint256[] calldata passportTokenIDs,
        address recipient
    ) internal view returns (uint256) {
        uint256 totalQuantity = passportTokenIDs.length;
        if (hasDiscount[recipient]) {
            totalQuantity += 1;
        }
        return totalQuantity;
    }

    function _setExistingTokenIdsClaimed(
        uint256[] memory _passportTokenIds
    ) internal {
        for (uint256 i = 0; i < _passportTokenIds.length; ) {
            freeMintClaimed[_passportTokenIds[i]] = true;
            unchecked {
                ++i;
            }
        }
    }

    function _hasDuplicates(
        uint[] calldata values
    ) internal pure returns (bool) {
        for (uint i = 0; i < values.length; ) {
            for (uint j = i + 1; j < values.length; ) {
                if (values[i] == values[j]) {
                    return true;
                }
                unchecked {
                    ++j;
                }
            }
            unchecked {
                ++i;
            }
        }
        return false;
    }

    function _setpassportTokenIDsToClaimed(
        uint256[] calldata passportTokenIDs
    ) internal {
        for (uint256 i = 0; i < passportTokenIDs.length; ) {
            freeMintClaimed[passportTokenIDs[i]] = true;
            unchecked {
                ++i;
            }
        }
    }

    //////////////////////////////////////////
    ////////////Modifiers/////////////////////
    //////////////////////////////////////////

    /**
     * @dev Modifier to ensure the caller owns the specified tokens or has appropriate approval.
     * @param passportTokenIDs An array of token IDs.
     * @param recipient The recipient address.
     */
    modifier onlyTokenOwner(
        uint256[] calldata passportTokenIDs,
        address recipient
    ) {
        for (uint256 i = 0; i < passportTokenIDs.length; ) {
            if (
                IERC721A(passportContractAddress).ownerOf(
                    passportTokenIDs[i]
                ) != recipient
            ) {
                revert IERC721A.ApprovalCallerNotOwnerNorApproved();
            }
            unchecked {
                ++i;
            }
        }
        _;
    }
    /**
     * @dev Modifier to ensure the caller is an admin.
     */
    modifier onlyAdmin() {
        if (!ICre8ors(cre8orsNFT).isAdmin(msg.sender)) {
            revert IERC721Drop.Access_OnlyAdmin();
        }
        _;
    }

    /**
     * @dev Modifier to ensure the specified token IDs are not duplicates.
     */
    modifier noDuplicates(uint[] calldata _passportpassportTokenIDs) {
        if (_hasDuplicates(_passportpassportTokenIDs)) {
            revert DuplicatesFound();
        }
        _;
    }
    /**
     * @dev Modifier to ensure the specified token IDs are eligible for a free mint.
     * @param passportTokenIDs An array of token IDs.
     */
    modifier hasFreeMint(
        uint256[] calldata passportTokenIDs,
        address recipient
    ) {
        bool NoFreeMint = !_hasPassportMint(passportTokenIDs) &&
            !hasDiscount[recipient];
        if (NoFreeMint) {
            revert FreeMintAlreadyClaimed();
        }
        _;
    }

    function _hasPassportMint(
        uint256[] calldata passportTokenIDs
    ) internal view returns (bool) {
        bool hasPassportMint = false;
        for (uint256 i = 0; i < passportTokenIDs.length; i++) {
            if (!freeMintClaimed[passportTokenIDs[i]]) {
                hasPassportMint = true;
                break;
            }
        }
        return hasPassportMint;
    }

    /// @dev Modifier that checks if the specified recipient has a discount.
    /// @param recipient The address of the recipient to check for the discount.
    modifier onlyExistingDiscount(address recipient) {
        if (!hasDiscount[recipient]) {
            revert MissingDiscount();
        }
        _;
    }
}

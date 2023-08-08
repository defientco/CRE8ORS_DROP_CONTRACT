// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import {IERC721A} from "lib/ERC721A/contracts/interfaces/IERC721A.sol";
import {ICre8ors} from "../interfaces/ICre8ors.sol";
import {IERC721Drop} from "../interfaces/IERC721Drop.sol";
import {ILockup} from "../interfaces/ILockup.sol";
import {IMinterUtilities} from "../interfaces/IMinterUtilities.sol";
import {IFriendsAndFamilyMinter} from "../interfaces/IFriendsAndFamilyMinter.sol";
import {IERC721ACH} from "ERC721H/interfaces/IERC721ACH.sol";

contract FriendsAndFamilyMinter is IFriendsAndFamilyMinter {
    ///@notice Mapping to track whether an address has discount for free mint.
    mapping(address => bool) public hasDiscount;

    ///@notice The address of the collection contract that mints and manages the tokens.
    address public cre8orsNFT;
    ///@notice The address of the minter utility contract that contains shared utility info.
    address public minterUtilityContractAddress;

    ///@notice mapping of address to quantity of free mints claimed.
    mapping(address => uint256) public totalClaimed;

    constructor(address _cre8orsNFT, address _minterUtilityContractAddress) {
        cre8orsNFT = _cre8orsNFT;
        minterUtilityContractAddress = _minterUtilityContractAddress;
    }

    /// @dev Mints a new token for the specified recipient and performs additional actions, such as setting the lockup (if applicable).
    /// @param recipient The address of the recipient who will receive the minted token.
    /// @return The token ID of the minted token.
    function mint(
        address recipient
    ) external onlyExistingDiscount(recipient) returns (uint256) {
        // Mint the token
        uint256 pfpTokenId = ICre8ors(cre8orsNFT).adminMint(recipient, 1);
        totalClaimed[recipient] += 1;

        // Reset discount for the recipient
        hasDiscount[recipient] = false;

        // Set lockup information (optional)
        IMinterUtilities minterUtility = IMinterUtilities(
            minterUtilityContractAddress
        );
        uint256 lockupDate = block.timestamp + 8 weeks;
        uint256 unlockPrice = minterUtility.getTierInfo(3).price;
        bytes memory data = abi.encode(lockupDate, unlockPrice);
        uint256[] memory tokenIDs = new uint256[](1);
        tokenIDs[0] = pfpTokenId;
        ICre8ors(
            IERC721ACH(cre8orsNFT).getHook(
                IERC721ACH.HookType.BeforeTokenTransfers
            )
        ).cre8ing().inializeStakingAndLockup(cre8orsNFT, tokenIDs, data);

        // Return the token ID of the minted token
        return pfpTokenId;
    }

    /// @dev Grants a discount to the specified recipient, allowing them to mint tokens without paying the regular price.
    /// @param recipient The address of the recipient who will receive the discount.
    function addDiscount(address recipient) external onlyAdmin {
        if (hasDiscount[recipient]) {
            revert ExistingDiscount();
        }
        hasDiscount[recipient] = true;
    }

    /// @dev Grants a discount to the specified array of recipients, allowing them to mint tokens without paying the regular price.
    /// @param recipient The address of the recipients who will receive the discount.
    function addDiscount(address[] memory recipient) external onlyAdmin {
        for (uint256 i = 0; i < recipient.length; ) {
            if (!hasDiscount[recipient[i]]) {
                hasDiscount[recipient[i]] = true;
            }
            unchecked {
                i += 1;
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

    /// @dev Sets a new address for the MinterUtilities contract.
    /// @param _newMinterUtilityContractAddress The address of the new MinterUtilities contract.
    function setNewMinterUtilityContractAddress(
        address _newMinterUtilityContractAddress
    ) external onlyAdmin {
        minterUtilityContractAddress = _newMinterUtilityContractAddress;
    }

    /// @dev Modifier that restricts access to only the contract's admin.
    modifier onlyAdmin() {
        if (!ICre8ors(cre8orsNFT).isAdmin(msg.sender)) {
            revert IERC721Drop.Access_OnlyAdmin();
        }
        _;
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

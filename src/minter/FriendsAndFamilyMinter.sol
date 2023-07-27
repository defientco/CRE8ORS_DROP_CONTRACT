// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import {IERC721A} from "lib/ERC721A/contracts/interfaces/IERC721A.sol";
import {ICre8ors} from "../interfaces/ICre8ors.sol";
import {IERC721Drop} from "../interfaces/IERC721Drop.sol";
import {ILockup} from "../interfaces/ILockup.sol";
import {IMinterUtilities} from "../interfaces/IMinterUtilities.sol";

contract FriendsAndFamilyMinter {
    ///@notice Mapping to track whether an address has discount for free mint.
    mapping(address => bool) public hasDiscount;

    ///@notice The address of the collection contract that mints and manages the tokens.
    address public cre8orsNFT;

    address public minterUtilityContractAddress;
    ///@notice The price in wei for unlocking free mint.
    uint256 public unlockPriceInWei = 150000000000000000; // 0.15 ether

    mapping(address => uint256) public maxClaimedFree;

    error MissingDiscount();
    error ExistingDiscount();

    constructor(address _cre8orsNFT, address _minterUtilityContractAddress) {
        cre8orsNFT = _cre8orsNFT;
        minterUtilityContractAddress = _minterUtilityContractAddress;
    }

    function mint(
        address recipient
    ) external onlyExistingDiscount(recipient) returns (uint256) {
        // Mint
        uint256 pfpTokenId = ICre8ors(cre8orsNFT).adminMint(recipient, 1);
        maxClaimedFree[recipient] += 1;

        // Reset discount
        hasDiscount[recipient] = false;

        // Lockup (optional)
        ILockup lockup = ICre8ors(cre8orsNFT).lockup();
        if (address(lockup) != address(0)) {
            IMinterUtilities minterUtility = IMinterUtilities(
                minterUtilityContractAddress
            );
            IMinterUtilities.TierInfo memory tierInfo = minterUtility
                .getTierInfo(1);
            uint256 lockupDate = tierInfo.lockup;
            uint256 unlockPrice = tierInfo.price;
            bytes memory data = abi.encode(lockupDate, unlockPrice);
            lockup.setUnlockInfo(cre8orsNFT, pfpTokenId, data);
        }

        // Return tokenId
        return pfpTokenId;
    }

    function addDiscount(address recipient) external onlyAdmin {
        if (hasDiscount[recipient]) {
            revert ExistingDiscount();
        }
        hasDiscount[recipient] = true;
    }

    function removeDiscount(
        address recipient
    ) external onlyAdmin onlyExistingDiscount(recipient) {
        hasDiscount[recipient] = false;
    }

    function setNewMinterUtilityContractAddress(
        address _newMinterUtilityContractAddress
    ) external onlyAdmin {
        minterUtilityContractAddress = _newMinterUtilityContractAddress;
    }

    modifier onlyAdmin() {
        if (!ICre8ors(cre8orsNFT).isAdmin(msg.sender)) {
            revert IERC721Drop.Access_OnlyAdmin();
        }

        _;
    }

    modifier onlyExistingDiscount(address recipient) {
        if (!hasDiscount[recipient]) {
            revert MissingDiscount();
        }

        _;
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import {IERC721A} from "lib/ERC721A/contracts/interfaces/IERC721A.sol";
import {ICre8ors} from "../interfaces/ICre8ors.sol";
import {ILockup} from "../interfaces/ILockup.sol";

contract FriendsAndFamilyMinter {
    mapping(address => bool) public hasDiscount;
    address public cre8orsNFT;

    error MissingDiscount();
    error ExistingDiscount();

    uint256 private _month = 4 weeks;

    constructor(address _cre8orsNFT) {
        cre8orsNFT = _cre8orsNFT;
    }

    function mint(
        address recipient
    ) external onlyExistingDiscount(recipient) returns (uint256) {
        // Mint
        uint256 pfpTokenId = ICre8ors(cre8orsNFT).adminMint(recipient, 1);

        // Reset discount
        hasDiscount[recipient] = false;

        // Lockup (optional)
        ILockup lockup = ICre8ors(cre8orsNFT).lockup();
        if (address(lockup) != address(0)) {
            uint256 lockupDate = 8 * _week;
            bytes memory data = abi.encode(lockupDate, 0.15 ether);
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

    modifier onlyAdmin() {
        if (!ICre8ors(cre8orsNFT).isAdmin(msg.sender)) {
            revert ICre8ors.Access_OnlyAdmin();
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

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import {IERC721A} from "lib/ERC721A/contracts/interfaces/IERC721A.sol";
import {ICre8ors} from "../interfaces/ICre8ors.sol";
import {ILockup} from "../interfaces/ILockup.sol";

contract FriendsAndFamilyMinter {
    mapping(address => bool) private _hasDiscount;
    mapping(address => uint256) public quantityClaimedFree;
    address public cre8orsNFT;

    constructor(address _cre8orsNFT) {
        cre8orsNFT = _cre8orsNFT;
    }

    function mintPfp(address recipient) external returns (uint256) {
        require(_hasDiscount[recipient], "You do not have a discount");
        uint256 pfpTokenId = ICre8ors(cre8orsNFT).adminMint(recipient, 1);
        _hasDiscount[recipient] = false;
        quantityClaimedFree[recipient] += 1;
        ILockup lockup = ICre8ors(cre8orsNFT).lockup();
        if (address(lockup) != address(0)) {
            uint256 lockupDate = 8 weeks;
            bytes memory data = abi.encode(lockupDate, 0.15 ether);
            lockup.setUnlockInfo(cre8orsNFT, pfpTokenId, data);
        }

        return pfpTokenId;
    }

    function addDiscount(address recipient) external {
        require(
            ICre8ors(cre8orsNFT).isAdmin(msg.sender),
            "You are not an admin"
        );
        require(!_hasDiscount[recipient], "You already have a discount");
        _hasDiscount[recipient] = true;
    }

    function removeDiscount(address recipient) external {
        require(
            ICre8ors(cre8orsNFT).isAdmin(msg.sender),
            "You are not an admin"
        );
        _hasDiscount[recipient] = false;
    }

    function hasDiscount(address recipient) external view returns (bool) {
        return _hasDiscount[recipient];
    }
}

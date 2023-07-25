// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;
import {IERC721A} from "lib/ERC721A/contracts/interfaces/IERC721A.sol";
import {ICre8ors} from "../interfaces/ICre8ors.sol";
import {ILockup} from "../interfaces/ILockup.sol";

contract CollectionHolderMint {
    mapping(uint256 => bool) public freeMintClaimed;
    address public _collectionContractAddress;

    uint256 private _month = 4 weeks;

    constructor(address collectionContractAddress) {
        _collectionContractAddress = collectionContractAddress;
    }

    function mint(
        uint256 tokenId,
        address target,
        address recipient
    ) external returns (uint256) {
        require(
            IERC721A(_collectionContractAddress).ownerOf(tokenId) == recipient,
            "CollectionHolderMint: Not owner of token"
        );
        require(freeMintClaimed[tokenId] == false, "Already claimed free mint");
        uint256 pfpTokenId = ICre8ors(target).adminMint(recipient, 1);

        ILockup lockup = ICre8ors(target).lockup();
        if (address(lockup) != address(0)) {
            uint256 lockupDate = 8 weeks;
            bytes memory data = abi.encode(lockupDate, 0.15 ether);
            lockup.setUnlockInfo(target, pfpTokenId, data);
        }

        freeMintClaimed[tokenId] = true;
        return pfpTokenId;
    }
}

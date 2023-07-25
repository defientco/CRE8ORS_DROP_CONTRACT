// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;
import {IERC721A} from "lib/ERC721A/contracts/interfaces/IERC721A.sol";
import {ICre8ors} from "../interfaces/ICre8ors.sol";
import {ILockup} from "../interfaces/ILockup.sol";

contract CollectionHolderMint {
    mapping(uint256 => bool) private _freeMintClaimed;

    address private _passportContractAddress;
    uint256 private _month = 4 weeks;

    constructor(address passportContractAddress) {
        _passportContractAddress = passportContractAddress;
    }

    function mintPfp(
        uint256 passportTokenId,
        address target,
        address recipient
    ) external returns (uint256) {
        require(
            !_freeMintClaimed[passportTokenId],
            "This passport has already claimed a free mint"
        );
        require(
            IERC721A(_passportContractAddress).ownerOf(passportTokenId) ==
                recipient,
            "You do not own this passport"
        );
        uint256 pfpTokenId = ICre8ors(target).adminMint(recipient, 1);

        ILockup lockup = ICre8ors(target).lockup();
        if (address(lockup) != address(0)) {
            uint256 lockupDate = 8 * _week;
            bytes memory data = abi.encode(lockupDate, 0.15 ether);
            lockup.setUnlockInfo(target, pfpTokenId, data);
        }

        _freeMintClaimed[passportTokenId] = true;
        return pfpTokenId;
    }

    function freeMintClaimed(
        uint256 passportTokenId
    ) external view returns (bool) {
        return _freeMintClaimed[passportTokenId];
    }
}

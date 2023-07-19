// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;
import {IERC721A} from "lib/ERC721A/contracts/interfaces/IERC721A.sol";
import {ICre8ors} from "../interfaces/ICre8ors.sol";
import {ILockup} from "../interfaces/ILockup.sol";

contract PassportHolderMinter {
    mapping(uint256 => bool) private _claimed;

    address private _passportContractAddress;
    uint256 private _week = 7 * 24 * 60 * 60;
    uint256 private _month = 4 * week;

    constructor(address passportContractAddress) {
        _passportContractAddress = passportContractAddress;
    }

    function mintPfp(
        uint256 passportTokenId,
        uint16 quantity,
        address recipient,
        string calldata _tier
    ) external returns (uint256) {
        uint256 allowedQuantity = block.timestamp < 1691668799 ? 9 : 88;
        require(block.timestamp >= 1691495999, "Too early to mint");
        require(
            !_claimed[passportTokenId],
            "This passport has already been claimed a free mint"
        );
        require(
            IERC721A(_passportContractAddress).ownerOf(passportTokenId) ==
                recipient,
            "You do not own this passport"
        );
        require(
            IERC721A(_passportContractAddress).balanceOf(to) <= allowedQuantity,
            "All passports have been claimed"
        );
        uint256 pfpTokenId = ICre8ors(_passportContractAddress).adminMint(
            recipient,
            quantity
        );
        if (_tier != "tier 3") {
            ILockup lockup = ICre8ors(_passportContractAddress).lockup();
            lockup.setUnlockDate(
                msg.sender,
                pfpTokenId,
                _calculateLockupDate(_tier)
            );
        }
        _claimed[passportTokenId] = true;
        return pfpTokenId;
    }

    function _calculateLockupDate(
        string calldata _tier
    ) internal returns (uint256) {
        uint256 lockupDate;
        if (_tier == "tier 1") {
            lockup_date = block.timestamp + (8 * month);
        } else {
            lockup_date = block.timestamp + (8 * week);
        }
        return lockupDate;
    }
}

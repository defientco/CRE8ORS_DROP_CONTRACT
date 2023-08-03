// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import {ILockup} from "../interfaces/ILockup.sol";
import {ICre8ors} from "../interfaces/ICre8ors.sol";
import {IERC721Drop} from "../interfaces/IERC721Drop.sol";
import {MetadataRenderAdminCheck} from "../metadata/MetadataRenderAdminCheck.sol";
import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";

/**
 ██████╗██████╗ ███████╗ █████╗  ██████╗ ██████╗ ███████╗
██╔════╝██╔══██╗██╔════╝██╔══██╗██╔═══██╗██╔══██╗██╔════╝
██║     ██████╔╝█████╗  ╚█████╔╝██║   ██║██████╔╝███████╗
██║     ██╔══██╗██╔══╝  ██╔══██╗██║   ██║██╔══██╗╚════██║
╚██████╗██║  ██║███████╗╚█████╔╝╚██████╔╝██║  ██║███████║
 ╚═════╝╚═╝  ╚═╝╚══════╝ ╚════╝  ╚═════╝ ╚═╝  ╚═╝╚══════╝                                                     
 */
contract Lockup is ILockup, MetadataRenderAdminCheck {
    /// @notice Access control roles
    bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
    bytes32 public immutable MINTER_ROLE = keccak256("MINTER");

    /// @notice Lockup information mapping storage
    mapping(address => mapping(uint256 => TokenLockupInfo))
        internal _lockupInfos;

    /// @notice retieves unlock date for token
    /// @param _target contract target
    /// @param _tokenId tokenId to retrieve unlock date
    function unlockInfo(
        address _target,
        uint256 _tokenId
    ) public view returns (TokenLockupInfo memory info) {
        info = _lockupInfos[_target][_tokenId];
    }

    /// @notice retrieves locked state for token
    /// @param _target contract target
    /// @param _tokenId tokenId to retrieve lock state
    function isLocked(
        address _target,
        uint256 _tokenId
    ) external view returns (bool) {
        return block.timestamp < unlockInfo(_target, _tokenId).unlockDate;
    }

    /// @notice sets unlock tier for token
    /// @param _target target contract
    /// @param _tokenId tokenId to set unlock date for
    /// @param _unlockData unlock information
    function setUnlockInfo(
        address _target,
        uint256 _tokenId,
        bytes memory _unlockData
    ) external onlyMinterOrAdmin(_target) {
        _setUnlockInfo(_target, _tokenId, _unlockData);
    }

    /// @notice unlocks token
    /// @param _target target contract
    /// @param _tokenId tokenId to unlock
    function unlock(address _target, uint256 _tokenId) private {
        uint64 newUnlockDate = uint64(block.timestamp);
        bytes memory data = abi.encode(newUnlockDate, 0);
        _setUnlockInfo(_target, _tokenId, data);
    }

    /// @notice sets unlock tier for token
    /// @param _target target contract
    /// @param _tokenId tokenId to set unlock date for
    /// @param _unlockData unlock information
    function _setUnlockInfo(
        address _target,
        uint256 _tokenId,
        bytes memory _unlockData
    ) private {
        // data format: uint64 unlockDate, uint256 priceToUnlock
        (uint64 _unlockDate, uint256 _priceToUnlock) = abi.decode(
            _unlockData,
            (uint64, uint256)
        );
        _lockupInfos[_target][_tokenId] = TokenLockupInfo({
            unlockDate: _unlockDate,
            priceToUnlock: _priceToUnlock
        });

        emit TokenLockupUpdated({
            target: _target,
            tokenId: _tokenId,
            unlockDate: _unlockDate,
            priceToUnlock: _priceToUnlock
        });
    }

    /// @notice pay to unlock a locked token
    /// @param _target target contract
    /// @param _tokenId tokenId to unlock
    function payToUnlock(
        address payable _target,
        uint256 _tokenId
    ) public payable {
        // verify paid unlock price
        uint256 priceToPay = _lockupInfos[_target][_tokenId].priceToUnlock;
        if (msg.value < priceToPay) {
            revert Unlock_WrongPrice(priceToPay);
        }

        // unlock token
        unlock(_target, _tokenId);

        // send funds to the target
        (bool success, ) = _target.call{value: priceToPay}("");
        require(success, "Transfer failed.");

        // if the payment is more than the unlock price, refund the extra
        if (msg.value > priceToPay) {
            uint256 refundAmount = msg.value - priceToPay;
            (bool refundSuccess, ) = msg.sender.call{value: refundAmount}("");
            require(refundSuccess, "Refund failed.");
        }
    }

    /// @notice Modifier to require the sender to be an admin
    /// @param target address that the user wants to modify
    modifier onlyMinterOrAdmin(address target) {
        if (
            target != msg.sender &&
            !ICre8ors(target).hasRole(DEFAULT_ADMIN_ROLE, msg.sender) &&
            !ICre8ors(target).hasRole(MINTER_ROLE, msg.sender)
        ) {
            revert AdminAccess_MissingMinterOrAdmin();
        }

        _;
    }
}

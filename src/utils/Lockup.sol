// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import {ILockup} from "../interfaces/ILockup.sol";
import {MetadataRenderAdminCheck} from "../metadata/MetadataRenderAdminCheck.sol";

/**
 ██████╗██████╗ ███████╗ █████╗  ██████╗ ██████╗ ███████╗
██╔════╝██╔══██╗██╔════╝██╔══██╗██╔═══██╗██╔══██╗██╔════╝
██║     ██████╔╝█████╗  ╚█████╔╝██║   ██║██████╔╝███████╗
██║     ██╔══██╗██╔══╝  ██╔══██╗██║   ██║██╔══██╗╚════██║
╚██████╗██║  ██║███████╗╚█████╔╝╚██████╔╝██║  ██║███████║
 ╚═════╝╚═╝  ╚═╝╚══════╝ ╚════╝  ╚═════╝ ╚═╝  ╚═╝╚══════╝                                                     
 */
contract Lockup is ILockup, MetadataRenderAdminCheck {
    /// @notice Lockup information mapping storage
    mapping(address => mapping(uint256 => uint64)) internal _lockupInfos;

    /// @notice retieves unlock date for token
    /// @param _target contract target
    /// @param _tokenId tokenId to retrieve unlock date
    function unlockDate(
        address _target,
        uint256 _tokenId
    ) public view returns (uint64) {
        return _lockupInfos[_target][_tokenId];
    }

    /// @notice retrieves locked state for token
    /// @param _target contract target
    /// @param _tokenId tokenId to retrieve lock state
    function isLocked(
        address _target,
        uint256 _tokenId
    ) external view returns (bool) {
        return unlockDate(_target, _tokenId) > block.timestamp;
    }

    /// @notice sets unlock date for token
    /// @param _target contract target
    /// @param _tokenId tokenId to set unlock date for
    /// @param _unlockEpoch time to unlock
    function setUnlockDate(
        address _target,
        uint256 _tokenId,
        uint64 _unlockEpoch
    ) external requireSenderAdmin(_target) {
        _lockupInfos[_target][_tokenId] = _unlockEpoch;
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import {IPayToUnlock} from "../interfaces/IPayToUnlock.sol";
import {MetadataRenderAdminCheck} from "../metadata/MetadataRenderAdminCheck.sol";
import {ICre8ors} from "../interfaces/ICre8ors.sol";
import {ILockup} from "../interfaces/ILockup.sol";

/**
 ██████╗██████╗ ███████╗ █████╗  ██████╗ ██████╗ ███████╗
██╔════╝██╔══██╗██╔════╝██╔══██╗██╔═══██╗██╔══██╗██╔════╝
██║     ██████╔╝█████╗  ╚█████╔╝██║   ██║██████╔╝███████╗
██║     ██╔══██╗██╔══╝  ██╔══██╗██║   ██║██╔══██╗╚════██║
╚██████╗██║  ██║███████╗╚█████╔╝╚██████╔╝██║  ██║███████║
 ╚═════╝╚═╝  ╚═╝╚══════╝ ╚════╝  ╚═════╝ ╚═╝  ╚═╝╚══════╝                                                     
 */
contract PayToUnlock is IPayToUnlock, MetadataRenderAdminCheck {
    /// @notice Lockup information mapping storage
    mapping(address => mapping(uint256 => uint64)) internal _lockupInfos;

    /// @notice find the lockup for a contract
    /// @param _target contract to lookup lockup
    function lockup(address _target) public view returns (ILockup) {
        return ICre8ors(_target).lockup();
    }

    /// @notice price to pay, in wei, to unlock a given tokenId
    /// @param _target contract to unlock
    /// @param _tokenId tokenId to unlock
    function amountToUnlock(
        address _target,
        uint256 _tokenId
    ) external view returns (uint256) {
        ILockup lock = ILockup(lockup(_target));
        if (address(lock) != address(0)) {
            uint64 unlockDate = lock.unlockInfo(_target, _tokenId).unlockDate;
            // TODO: use BOTH unlockDate & lockStart to determine total length of lockup
            // unlockDate
            // lockStart
            // lockDuration
        }
    }

    function payToUnlock(address, uint256) external {}
}

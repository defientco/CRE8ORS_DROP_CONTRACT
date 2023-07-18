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

    function lockup(address _target) external view returns (ILockup) {
        return ICre8ors(_target).lockup();
    }

    function amountToUnlock(address, uint256) external view returns (uint256) {}

    function payToUnlock(address, uint256) external {}
}

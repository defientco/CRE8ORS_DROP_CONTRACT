// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

/**
 ██████╗██████╗ ███████╗ █████╗  ██████╗ ██████╗ ███████╗
██╔════╝██╔══██╗██╔════╝██╔══██╗██╔═══██╗██╔══██╗██╔════╝
██║     ██████╔╝█████╗  ╚█████╔╝██║   ██║██████╔╝███████╗
██║     ██╔══██╗██╔══╝  ██╔══██╗██║   ██║██╔══██╗╚════██║
╚██████╗██║  ██║███████╗╚█████╔╝╚██████╔╝██║  ██║███████║
 ╚═════╝╚═╝  ╚═╝╚══════╝ ╚════╝  ╚═════╝ ╚═╝  ╚═╝╚══════╝                                                     
 */
interface ILockup {
    function isLocked(uint256) external view returns (bool);

    function unlockDate(uint256) external view returns (uint64);

    function setUnlockDate(uint256, uint64) external;
}

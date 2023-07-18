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
    /// @notice Storage for token edition information
    struct TokenLockupInfo {
        uint64 unlockDate;
        uint256 priceToUnlock;
    }

    /// @notice Locked
    error Lockup_Locked();

    /// @notice Wrong price for unlock
    error Unlock_WrongPrice(uint256 correctPrice);

    /// @notice Event for updated Lockup
    event TokenLockupUpdated(
        address indexed target,
        uint256 tokenId,
        uint64 unlockDate,
        uint256 priceToUnlock
    );

    function isLocked(address, uint256) external view returns (bool);

    function unlockInfo(
        address,
        uint256
    ) external view returns (TokenLockupInfo memory);

    function setUnlockInfo(address, uint256, bytes memory) external;

    function payToUnlock(address, uint256) external payable;
}

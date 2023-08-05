// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

/// @title Base
/// @notice A base abstract contract implementing common functionality for other contracts.
abstract contract Base {
    /// @notice given address is invalid.
    error AddressCannotBeZero();

    /// @dev Modifier to check if the provided address is not the zero address.
    /// @param addr The address to be checked.
    modifier notZeroAddress(address addr) {
        if (addr == address(0)) {
            revert AddressCannotBeZero();
        }

        _;
    }
}

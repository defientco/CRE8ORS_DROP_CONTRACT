// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

/// @title Payment System Interface
/// @notice An interface for the PaymentSystem contract.
interface IPaymentSystem {
    /// @notice Error message for zero value.
    error ValueCannotBeZero();

    /// @notice Error message for failed ETH transfer.
    error ETHTransferFailed();

    /// @dev Emitted when the native currency price is updated.
    /// @param newPrice The new price per second of the native currency.
    event PricePerSecondUpdated(uint256 newPrice);

    /// @notice Sets the price per second of the native currency.
    /// @param target The address of the contract implementing the access control.
    /// @param newPrice The new price per second to be set.
    function setPricePerSecond(address target, uint256 newPrice) external;
}

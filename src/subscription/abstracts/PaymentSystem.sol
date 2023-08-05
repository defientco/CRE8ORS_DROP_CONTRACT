// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import {IPaymentSystem} from "../interfaces/IPaymentSystem.sol";
import {Admin} from "./Admin.sol";

abstract contract PaymentSystem is IPaymentSystem, Admin {
    /*//////////////////////////////////////////////////////////////
                             PUBLIC STORAGE
    //////////////////////////////////////////////////////////////*/

    /// @notice The price per second for the subscription in native currency.
    uint256 public pricePerSecond;

    /*//////////////////////////////////////////////////////////////
                               CONSTRUCTOR
    //////////////////////////////////////////////////////////////*/

    /// @param pricePerSecond_ The price per second for the subscription, can be zero.
    constructor(uint256 pricePerSecond_) {
        pricePerSecond = pricePerSecond_;
    }

    /*//////////////////////////////////////////////////////////////
                    ONLY-ADMIN NON-CONSTANT FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    /// @inheritdoc IPaymentSystem
    function setPricePerSecond(address target, uint256 newPrice) external override onlyAdmin(target) {
        pricePerSecond = newPrice;
        emit PricePerSecondUpdated(newPrice);
    }

    function _sendValue(address payable to, uint256 amount) internal {
        (bool success,) = to.call{value: amount}("");
        if (!success) revert ETHTransferFailed();
    }
}

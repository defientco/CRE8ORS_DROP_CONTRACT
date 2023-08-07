// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import {IHookBase} from "../interfaces/IHookBase.sol";
import {IERC721Drop} from "../interfaces/IERC721Drop.sol";

/// @title HookBase Contract
/// @notice A base contract for hooks
abstract contract HookBase is IHookBase {
    /// @dev Subscription contract address
    ///     address(0) means subscription is turned off
    address public override subscription;

    /// @dev Setter function for subscription contract address.
    ///     - if we want to turn off subscription: `setSubscription(address(0))`
    ///     - if we want to enable subscription: `setSubscription(address(Subscription))`
    /// @param _target Target ERC721 contract.
    /// @param _newSubscription New subscription contract address.
    function setSubscription(
        address _target,
        address _newSubscription
    ) external override onlyAdmin(_target) {
        subscription = _newSubscription;
    }

    /// @notice Only allow for users with admin access
    /// @param _target target ERC721 contract
    modifier onlyAdmin(address _target) {
        if (!isAdmin(_target, msg.sender)) {
            revert IERC721Drop.Access_OnlyAdmin();
        }

        _;
    }

    /// @notice Getter for admin role associated with the contract to handle minting
    /// @param _target target ERC721 contract
    /// @param user user address
    /// @return boolean if address is admin
    function isAdmin(address _target, address user) public view returns (bool) {
        return IERC721Drop(_target).isAdmin(user);
    }
}

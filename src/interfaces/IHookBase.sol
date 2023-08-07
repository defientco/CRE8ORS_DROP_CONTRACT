// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

interface IHookBase {
    /// @dev Subscription contract address
    ///     address(0) means subscription is turned off
    function subscription() external view returns (address);

    /// @dev Setter function for subscription contract address.
    ///     - if we want to turn off subscription: `setSubscription(address(0))`
    ///     - if we want to enable subscription: `setSubscription(address(Subscription))`
    /// @param _target Target ERC721 contract.
    /// @param _newSubscription New subscription contract address.
    function setSubscription(address _target, address _newSubscription) external;
}

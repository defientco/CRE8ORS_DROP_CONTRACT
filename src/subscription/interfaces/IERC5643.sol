// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

/// @title IERC5643
/// @notice https://eips.ethereum.org/EIPS/eip-5643
/// @dev type(IERC5643).interfaceId should return 0x8c65f84d
interface IERC5643 {
    /*//////////////////////////////////////////////////////////////
                             ERRORS
    //////////////////////////////////////////////////////////////*/

    /// @notice The duration provided for renewal is too short to extend the subscription.
    error RenewalTooShort();

    /// @notice The duration provided for renewal exceeds the allowed maximum for subscription extension.
    error RenewalTooLong();

    /// @notice The payment received for the subscription renewal is insufficient.
    error InsufficientPayment();

    /// @notice The subscription associated with the token is not renewable and cannot be extended.
    error SubscriptionNotRenewable();

    /// @notice The duration provided for renewal price calculation cannot be zero.
    error DurationForRenewalPriceCannotBeZero();

    /*//////////////////////////////////////////////////////////////
                                 EVENTS
    //////////////////////////////////////////////////////////////*/

    /// @notice Emitted when a subscription expiration changes
    /// @dev When a subscription is canceled, the expiration value should also be 0.
    event SubscriptionUpdate(uint256 indexed tokenId, uint64 expiration);

    /*//////////////////////////////////////////////////////////////
                           CONSTANT FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    /// @notice Gets the expiration date of a subscription
    /// @dev Throws if `tokenId` is not a valid NFT
    /// @param tokenId The NFT to get the expiration date of
    /// @return The expiration date of the subscription
    function expiresAt(uint256 tokenId) external view returns (uint64);

    /// @notice Determines whether a subscription can be renewed
    /// @dev Throws if `tokenId` is not a valid NFT
    /// @param tokenId The NFT to get the expiration date of
    /// @return The renewability of a the subscription
    function isRenewable(uint256 tokenId) external view returns (bool);

    /*//////////////////////////////////////////////////////////////
                         NON-CONSTANT FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    /// @notice Renews the subscription to an NFT
    /// Throws if `tokenId` is not a valid NFT
    /// @param tokenId The NFT to renew the subscription for
    /// @param duration The number of seconds to extend a subscription for
    function renewSubscription(uint256 tokenId, uint64 duration) external payable;

    /// @notice Cancels the subscription of an NFT
    /// @dev Throws if `tokenId` is not a valid NFT
    /// @param tokenId The NFT to cancel the subscription for
    function cancelSubscription(uint256 tokenId) external payable;
}

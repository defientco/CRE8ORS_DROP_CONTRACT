// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import {IERC721} from "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import {IERC5643} from "../interfaces/IERC5643.sol";
import {PaymentSystem} from "../abstracts/PaymentSystem.sol";
import {IERC721Drop} from "../../interfaces/IERC721Drop.sol";

/// @title ERC5643
/// @notice An abstract contract implementing the IERC5643 interface for managing subscriptions to ERC721 tokens.
abstract contract ERC5643 is IERC5643, PaymentSystem {
    /*//////////////////////////////////////////////////////////////
                             PRIVATE STORAGE
    //////////////////////////////////////////////////////////////*/

    /// @notice Mapping to store the expiration timestamps for each tokenId representing an active subscription.
    mapping(uint256 => uint64) private _expirations;

    /*//////////////////////////////////////////////////////////////
                             PUBLIC STORAGE
    //////////////////////////////////////////////////////////////*/

    /// @notice The minimum duration allowed for subscription renewal.
    uint64 public minRenewalDuration;

    /// @notice The maximum duration allowed for subscription renewal. A value of 0 means lifetime extension is allowed.
    uint64 public maxRenewalDuration; // 0 value means lifetime extension

    ///@notice The address of the collection contract that mints and manages the tokens.
    address public cre8orsNFT;

    /*//////////////////////////////////////////////////////////////
                                MODIFIERS
    //////////////////////////////////////////////////////////////*/

    /// @dev Modifier to check if `spender` is the owner or approved for the `tokenId`.
    modifier onlyApprovedOrOwner(address spender, uint256 tokenId) {
        if (!_isApprovedOrOwner(spender, tokenId)) {
            revert IERC721Drop.Access_MissingOwnerOrApproved();
        }

        _;
    }

    /// @dev Modifier to check if the `duration` is between `minRenewalDuration` and `maxRenewalDuration`.
    modifier isDurationBetweenMinAndMax(uint64 duration) {
        if (duration < minRenewalDuration) {
            revert RenewalTooShort();
        } else if (maxRenewalDuration != 0 && duration > maxRenewalDuration) {
            revert RenewalTooLong();
        }

        _;
    }

    /// @dev Modifier to check if the payment for `duration` is valid.
    modifier isRenewalPriceValid(uint256 value, uint64 duration) {
        if (duration == 0) {
            revert DurationForRenewalPriceCannotBeZero();
        }

        if (value < _getRenewalPrice(duration)) {
            revert InsufficientPayment();
        }

        _;
    }

    /*//////////////////////////////////////////////////////////////
                               CONSTRUCTOR
    //////////////////////////////////////////////////////////////*/

    /// @dev Checks zero address validation
    /// @param cre8orsNFT_ The address of the cre8orsNFT contract.
    /// @param minRenewalDuration_ The minimum duration allowed for subscription renewal, can be zero.
    /// @param pricePerSecond_ The price per second for the subscription, can be zero.
    constructor(
        address cre8orsNFT_,
        uint64 minRenewalDuration_,
        uint256 pricePerSecond_
    ) notZeroAddress(cre8orsNFT_) PaymentSystem(pricePerSecond_) {
        cre8orsNFT = cre8orsNFT_;
        minRenewalDuration = minRenewalDuration_;
    }

    /*//////////////////////////////////////////////////////////////
                     USER-FACING CONSTANT FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    /// @inheritdoc IERC5643
    function isRenewable(
        uint256 /*tokenId*/
    ) external view virtual override returns (bool) {
        return _isRenewable();
    }

    /// @inheritdoc IERC5643
    function expiresAt(
        uint256 tokenId
    ) public view virtual override returns (uint64) {
        return _expirations[tokenId];
    }

    /// @dev See {IERC165-supportsInterface}.
    function supportsInterface(
        bytes4 interfaceId
    ) public view virtual returns (bool) {
        return
            interfaceId == type(IERC5643).interfaceId ||
            IERC721(cre8orsNFT).supportsInterface(interfaceId);
    }

    /*//////////////////////////////////////////////////////////////
                   USER-FACING NON-CONSTANT FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    /// @inheritdoc IERC5643
    function renewSubscription(
        uint256 tokenId,
        uint64 duration
    )
        external
        payable
        virtual
        override
        isDurationBetweenMinAndMax(duration)
        isRenewalPriceValid(msg.value, duration)
    {
        // extend subscription
        _updateSubscriptionExpiration(tokenId, duration);
    }

    /// @inheritdoc IERC5643
    function cancelSubscription(
        uint256 tokenId
    )
        external
        payable
        virtual
        override
        onlyApprovedOrOwner(msg.sender, tokenId)
    {
        delete _expirations[tokenId];

        emit SubscriptionUpdate(tokenId, 0);
    }

    /*//////////////////////////////////////////////////////////////
                    ONLY-ADMIN NON-CONSTANT FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    /// @notice Set the address of the cre8ors contract.
    /// @dev This function can only be called by the contract admin.
    /// @param target The address of the new cre8ors contract.
    function setCre8orsNFT(address target) external onlyAdmin(target) {
        cre8orsNFT = target;
    }

    /*//////////////////////////////////////////////////////////////
                       INTERNAL CONSTANT FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    /// @notice Checks whether the subscription is renewable.
    /// @dev This Internal function should be implemented in derived contracts to determine if renewability should be
    /// disabled for all or some tokens.
    /// @return A boolean value indicating whether the subscription can be renewed (true) or not (false).
    function _isRenewable() internal view virtual returns (bool);

    /// @notice Gets the price to renew a subscription for a specified `duration` in seconds.
    /// @dev This Internal function should be implemented in derived contracts to calculate the renewal price for the
    /// subscription.
    /// @param duration The duration (in seconds) for which the subscription is to be extended.
    /// @return The price (in native currency) required to renew the subscription for the given duration.
    function _getRenewalPrice(
        uint64 duration
    ) internal view virtual returns (uint256);

    /*//////////////////////////////////////////////////////////////
                     INTERNAL NON-CONSTANT FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    /// @notice Updates the expiration timestamp for a subscription represented by the given `tokenId`.
    /// @dev this function won't check that the tokenId is valid, responsibility is delegated to the caller.
    /// @param tokenId The unique identifier of the subscription token.
    /// @param duration The duration (in seconds) to extend the subscription from the current timestamp.
    function _updateSubscriptionExpiration(
        uint256 tokenId,
        uint64 duration
    ) internal virtual {
        uint64 currentExpiration = _expirations[tokenId];
        uint64 newExpiration;

        // Check if the current subscription is new or has expired
        if ((currentExpiration == 0) || (currentExpiration < block.timestamp)) {
            newExpiration = uint64(block.timestamp) + duration;
        } else {
            // If current subscription not expired (extend)
            if (!_isRenewable()) {
                revert SubscriptionNotRenewable();
            }
            newExpiration = currentExpiration + duration;
        }

        _expirations[tokenId] = newExpiration;

        _sendValue(payable(cre8orsNFT), msg.value);

        emit SubscriptionUpdate(tokenId, newExpiration);
    }

    /// @dev Internal function to set the minimum renewal duration.
    /// @param duration The new minimum renewal duration (in seconds).
    function _setMinimumRenewalDuration(uint64 duration) internal virtual {
        minRenewalDuration = duration;
    }

    /// @dev Internal function to set the maximum renewal duration.
    /// @param duration The new maximum renewal duration (in seconds).
    function _setMaximumRenewalDuration(uint64 duration) internal virtual {
        maxRenewalDuration = duration;
    }

    /// @notice Requires that spender owns or is approved for the token.
    function _isApprovedOrOwner(
        address spender,
        uint256 tokenId
    ) internal view virtual returns (bool) {
        address cre8orsNFT_ = cre8orsNFT;
        address owner = IERC721(cre8orsNFT_).ownerOf(tokenId);
        return (spender == owner ||
            IERC721(cre8orsNFT_).isApprovedForAll(owner, spender) ||
            IERC721(cre8orsNFT_).getApproved(tokenId) == spender);
    }
}

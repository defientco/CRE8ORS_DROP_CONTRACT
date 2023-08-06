// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import {ISubscription} from "./interfaces/ISubscription.sol";
import {ERC5643} from "./abstracts/ERC5643.sol";

contract Subscription is ISubscription, ERC5643 {
    /*//////////////////////////////////////////////////////////////
                             PRIVATE STORAGE
    //////////////////////////////////////////////////////////////*/

    /// @notice A boolean value indicating whether the subscription can be renewed
    bool private _renewable = true;

    /*//////////////////////////////////////////////////////////////
                               CONSTRUCTOR
    //////////////////////////////////////////////////////////////*/

    /// @param cre8orsNFT_ The address of the cre8orsNFT contract.
    /// @param minRenewalDuration_ The minimum duration allowed for subscription renewal, can be zero.
    /// @param pricePerSecond_ The price per second for the subscription, can be zero.
    constructor(address cre8orsNFT_, uint64 minRenewalDuration_, uint256 pricePerSecond_)
        ERC5643(cre8orsNFT_, minRenewalDuration_, pricePerSecond_)
    {}

    /*//////////////////////////////////////////////////////////////
                     USER-FACING CONSTANT FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    /// @inheritdoc ISubscription
    function checkSubscription(uint256 tokenId) external view override {
        bool isValid = isSubscriptionValid(tokenId);

        if (!isValid) {
            revert InvalidSubscription();
        }
    }

    /// @inheritdoc ISubscription
    function isSubscriptionValid(uint256 tokenId) public view override returns (bool) {
        return expiresAt(tokenId) > block.timestamp;
    }

    /*//////////////////////////////////////////////////////////////
                    ONLY-ADMIN NON-CONSTANT FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    /// @notice Sets the renewability status of subscriptions.
    /// @dev This function can only be called by the admin.
    /// @param renewable Boolean flag to indicate if subscriptions are renewable.
    function setRenewable(address target, bool renewable) external onlyAdmin(target) {
        _renewable = renewable;
        emit RenewableUpdate(renewable);
    }

    /// @notice Sets the minimum duration for subscription renewal.
    /// @dev This function can only be called by the admin.
    /// @param duration The minimum duration (in seconds) for subscription renewal.
    function setMinRenewalDuration(address target, uint64 duration) external onlyAdmin(target) {
        _setMinimumRenewalDuration(duration);
        emit MinRenewalDurationUpdate(duration);
    }

    /// @notice Sets the maximum duration for subscription renewal.
    /// @dev This function can only be called by the admin.
    /// @param duration The maximum duration (in seconds) for subscription renewal.
    function setMaxRenewalDuration(address target, uint64 duration) external onlyAdmin(target) {
        _setMaximumRenewalDuration(duration);
        emit MaxRenewalDurationUpdate(duration);
    }

    /*//////////////////////////////////////////////////////////////
               ONLY-ADMIN-OR-MINTER NON-CONSTANT FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    /*//////////   updateSubscriptionForFree variants   //////////*/

    /// @inheritdoc ISubscription
    function updateSubscriptionForFree(address target, uint64 duration, uint256 tokenId)
        external
        override
        onlyRoleOrAdmin(target, MINTER_ROLE)
        isDurationBetweenMinAndMax(duration)
    {
        _updateSubscriptionExpiration(tokenId, duration);
    }

    /// @inheritdoc ISubscription
    function updateSubscriptionForFree(address target, uint64 duration, uint256[] calldata tokenIds)
        external
        override
        onlyRoleOrAdmin(target, MINTER_ROLE)
        isDurationBetweenMinAndMax(duration)
    {
        uint256 tokenId;

        for (uint256 i = 0; i < tokenIds.length;) {
            tokenId = tokenIds[i];

            _updateSubscriptionExpiration(tokenId, duration);

            unchecked {
                ++i;
            }
        }
    }

    /*//////////////   updateSubscription variants   /////////////*/

    /// @inheritdoc ISubscription
    function updateSubscription(address target, uint64 duration, uint256 tokenId)
        external
        payable
        override
        onlyRoleOrAdmin(target, MINTER_ROLE)
        isDurationBetweenMinAndMax(duration)
        isRenewalPriceValid(msg.value, duration)
    {
        // extend subscription
        _updateSubscriptionExpiration(tokenId, duration);
    }

    /// @inheritdoc ISubscription
    /// @dev No need to check for `tokenIds.length` as `isRenewalPriceValid` checks duration to not be zero.
    function updateSubscription(address target, uint64 duration, uint256[] calldata tokenIds)
        external
        payable
        override
        onlyRoleOrAdmin(target, MINTER_ROLE)
        isDurationBetweenMinAndMax(duration)
        isRenewalPriceValid(msg.value, uint64(tokenIds.length * duration))
    {
        uint256 tokenId;

        for (uint256 i = 0; i < tokenIds.length;) {
            tokenId = tokenIds[i];

            _updateSubscriptionExpiration(tokenId, duration);

            unchecked {
                ++i;
            }
        }
    }

    /*//////////////////////////////////////////////////////////////
                       INTERNAL CONSTANT FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    /// @inheritdoc ERC5643
    function _isRenewable() internal view override returns (bool) {
        return _renewable;
    }

    /// @inheritdoc ERC5643
    function _getRenewalPrice(uint64 duration) internal view override returns (uint256) {
        return duration * pricePerSecond;
    }
}

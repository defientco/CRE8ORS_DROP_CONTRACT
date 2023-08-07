// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import {IOwnerOfHook} from "ERC721H/interfaces/IOwnerOfHook.sol";
import {ICre8ors} from "../interfaces/ICre8ors.sol";
import {ISubscription} from "../subscription/interfaces/ISubscription.sol";
import {IERC721Drop} from "../interfaces/IERC721Drop.sol";
import {HookBase} from "./HookBase.sol";

contract OwnerOfHook is IOwnerOfHook, HookBase {
    /// @notice A boolean flag indicating whether the default owner of return is enabled.
    bool public isDefaultOwnerOfReturnEnabled = true;

    /// @dev The address that gets returns if the subscription of a tokenId is expired.
    ///     By default: address(0)
    address public defaultOwnerOfReturn;

    /// @notice mapping of ownerOf return values according to tokenId 
    ///     if subscription expired.
    /// by default address(0)
    mapping(uint256 => address) public ownerOfReturns;

    /// @inheritdoc IOwnerOfHook
    function ownerOfHook(
        uint256 tokenId
    ) external view returns (address, bool) {
        if (subscription == address(0)) {
            return (address(0), true);
        }

        // external call to subscription
        bool isSubscriptionValid = 
            ISubscription(subscription).isSubscriptionValid(tokenId);

        if (isSubscriptionValid) {
            return (address(0), true);
        }

        // subscription expired
        // do not run `super.ownerOf(tokenId)`

        // if default enabled then return default
        if (isDefaultOwnerOfReturnEnabled) {
            return (defaultOwnerOfReturn, false);
        }

        // otherwise return according to tokenId
        return (ownerOfReturns[tokenId], false);
    }

    /// @notice Set ownerOf return values according to tokenId if subscription expired.
    /// @param _target target ERC721 contract
    /// @param _tokenId ID of the token
    /// @param _ownerOfReturn return value of ownerOf if subscription expired.
    function setOwnerOfReturns(
        address _target,
        uint256 _tokenId,
        address _ownerOfReturn
    ) public onlyAdmin(_target) {
        ownerOfReturns[_tokenId] = _ownerOfReturn;
    }

    function setOwnerOfOverrideReturn(
        address _target,
        address _defaultOwnerOfReturn
    ) external onlyAdmin(_target) {
        defaultOwnerOfReturn = _defaultOwnerOfReturn;
    }

    function setIsDefaultOwnerOfReturnEnabled(
        address _target,
        bool _enabled
    ) external onlyAdmin(_target) {
        isDefaultOwnerOfReturnEnabled = _enabled;
    }
}

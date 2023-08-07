// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import {IOwnerOfHook} from "ERC721H/interfaces/IOwnerOfHook.sol";
import {ICre8ors} from "../interfaces/ICre8ors.sol";
import {ISubscription} from "../subscription/interfaces/ISubscription.sol";
import {IERC721Drop} from "../interfaces/IERC721Drop.sol";

contract OwnerOfHook is IOwnerOfHook {

    /// @notice mapping of ERC721 to bool whether to use ownerOfHook
    mapping(address => bool) public ownerOfHookEnabled;

    /// @notice mapping of ownerOf return values according to tokenId 
    ///     if subscription expired.
    /// by default address(0)
    mapping(uint256 => address) public ownerOfReturns;

    /// @inheritdoc IOwnerOfHook
    function ownerOfHook(
        uint256 tokenId
    ) external view returns (address, bool) {
        // msg.sender is the ERC721 contract e.g. Cre8ors
        address subscription = ICre8ors(msg.sender).subscription();

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
        return (ownerOfReturns[tokenId], false);
    }

    /// @notice Toggle ownerOf hook.
    /// @param _target target ERC721 contract
    /// @param _enabled enable ownerOfHook
    function setOwnerOfHookEnabled(
        address _target,
        bool _enabled
    ) public onlyAdmin(_target) {
        ownerOfHookEnabled[_target] = _enabled;
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

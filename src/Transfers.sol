// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import {Cre8orsERC6551} from "./utils/Cre8orsERC6551.sol";
import {ICre8ors} from "./interfaces/ICre8ors.sol";
import {IERC721Drop} from "./interfaces/IERC721Drop.sol";

contract TransferHook is Cre8orsERC6551 {
    mapping(address => bool) public afterTokenTransfersHookEnabled;
    mapping(address => bool) public beforeTokenTransfersHookEnabled;

    /// @notice Set ERC6551 registry
    /// @param _target target ERC721 contract
    /// @param _registry ERC6551 registry
    function setErc6551Registry(
        address _target,
        address _registry
    ) public onlyAdmin(_target) {
        erc6551Registry[_target] = _registry;
    }

    /// @notice Set ERC6551 account implementation
    /// @param _target target ERC721 contract
    /// @param _implementation ERC6551 account implementation
    function setErc6551Implementation(
        address _target,
        address _implementation
    ) public onlyAdmin(_target) {
        erc6551AccountImplementation[_target] = _implementation;
    }

    /// @notice Toggle afterTokenTransfers hook.
    /// add admin only
    /// @param _target target ERC721 contract
    /// @param _enabled enable afterTokenTransferHook
    function setAfterTokenTransfersEnabled(
        address _target,
        bool _enabled
    ) public onlyAdmin(_target) {
        afterTokenTransfersHookEnabled[_target] = _enabled;
    }

    /// @notice Check if the AfterTokenTransfers function should use the hook.
    function useAfterTokenTransfersHook(
        address,
        address,
        uint256,
        uint256
    ) external view returns (bool) {
        return afterTokenTransfersHookEnabled[msg.sender];
    }

    /// @notice Custom implementation for AfterTokenTransfers Hook.
    function afterTokenTransfersOverrideHook(
        address from,
        address,
        uint256 startTokenId,
        uint256 quantity
    ) external {
        if (from == address(0) && erc6551Registry[msg.sender] != address(0)) {
            createTokenBoundAccounts(msg.sender, startTokenId, quantity);
        }
    }

    /// @notice Only allow for users with admin access
    modifier onlyAdmin(address _target) {
        if (!isAdmin(_target, msg.sender)) {
            revert IERC721Drop.Access_OnlyAdmin();
        }

        _;
    }

    /// @notice Getter for admin role associated with the contract to handle minting
    /// @param user user address
    /// @return boolean if address is admin
    function isAdmin(address _target, address user) public view returns (bool) {
        return IERC721Drop(_target).isAdmin(user);
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import {HookBase} from "../hooks/HookBase.sol";
import {IAfterTokenTransfersHook} from "ERC721H/interfaces/IAfterTokenTransfersHook.sol";
import {Cre8orsERC6551} from "../utils/Cre8orsERC6551.sol";
import {ICre8ors} from "../interfaces/ICre8ors.sol";
import {IERC721Drop} from "../interfaces/IERC721Drop.sol";
import {ISubscription} from "../subscription/interfaces/ISubscription.sol";

contract TransferHook is IAfterTokenTransfersHook, HookBase, Cre8orsERC6551 {
    /// @notice Represents the duration of one year in seconds.
    uint64 public constant ONE_YEAR_DURATION = 365 days;

    /// @notice mapping of ERC721 to bool whether to use afterTokenTransferHook
    mapping(address => bool) public afterTokenTransfersHookEnabled;
    /// @notice mapping of ERC721 to bool whether to use beforeTokenTransferHook
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

    /// @notice Custom implementation for AfterTokenTransfers Hook.
    function afterTokenTransfersHook(
        address from,
        address,
        uint256 startTokenId,
        uint256 quantity
    ) external {
        if (from != address(0)) {
            return;
        }

        // msg.sender is the ERC721 contract e.g. Cre8ors
        address _cre8orsNFT = msg.sender;

        if (erc6551Registry[_cre8orsNFT] != address(0)) {
            createTokenBoundAccounts(_cre8orsNFT, startTokenId, quantity);
        }

        // Subscription logic
        uint256[] memory tokenIds = getTokenIds(startTokenId, quantity);

        ISubscription(subscription).updateSubscriptionForFree({
            target: _cre8orsNFT,
            duration: ONE_YEAR_DURATION,
            tokenIds: tokenIds
        });
    }

    /// @notice Get an array of token IDs starting from a given token ID and up
    ///     to a specified quantity.
    /// @param startTokenId The starting token ID.
    /// @param quantity The number of token IDs to generate.
    /// @return tokenIds An array containing the generated token IDs.
    function getTokenIds(
        uint256 startTokenId,
        uint256 quantity
    ) public pure returns (uint256[] memory tokenIds) {
        tokenIds = new uint256[](quantity);
        for (uint256 i = 0; i < quantity; ) {
            tokenIds[i] = startTokenId + i;

            unchecked {
                ++i;
            }
        }
    }
}

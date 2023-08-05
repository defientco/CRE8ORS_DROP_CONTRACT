// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import {Cre8orsERC6551} from "./utils/Cre8orsERC6551.sol";
import {Cre8ing} from "./Cre8ing.sol";
import {ICre8ors} from "./interfaces/ICre8ors.sol";
import {ICre8ing} from "./interfaces/ICre8ing.sol";
import {IERC721Drop} from "./interfaces/IERC721Drop.sol";
import {ISubscription} from "./subscription/interfaces/ISubscription.sol";
import {ITransfers} from "./interfaces/ITransfers.sol";

contract TransferHook is Cre8orsERC6551 {
    /// @notice Represents the duration of one year in seconds.
    uint64 public constant ONE_YEAR_DURATION = 365 days;

    /// @notice To toggle free subscription in future
    bool public isFreeSubscriptionEnabled = true;

    /// @notice mapping of ERC721 to bool whether to use afterTokenTransferHook
    mapping(address => bool) public afterTokenTransfersHookEnabled;
    /// @notice mapping of ERC721 to bool whether to use beforeTokenTransferHook
    mapping(address => bool) public beforeTokenTransfersHookEnabled;

    /// @notice Toggle the status of the free subscription feature.
    /// @dev This function can only be called by an admin, identified by the
    ///     "cre8orsNFT" contract address.
    function toggleIsFreeSubscriptionEnabled() public onlyAdmin(msg.sender) {
        isFreeSubscriptionEnabled = !isFreeSubscriptionEnabled;
    }

    ICre8ing public cre8ing;

    /// @dev MUST only be modified by safeTransferWhileCre8ing(); if set to 2 then
    ///     the _beforeTokenTransfer() block while cre8ing is disabled.
    mapping(address => uint256) internal cre8ingTransfer;

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

    /// @notice Toggle beforeTokenTransfers hook.
    /// add admin only
    /// @param _target target ERC721 contract
    /// @param _enabled enable beforeTokenTransferHook
    function setBeforeTokenTransfersEnabled(
        address _target,
        bool _enabled
    ) public onlyAdmin(_target) {
        beforeTokenTransfersHookEnabled[_target] = _enabled;
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

    /// @notice Check if the BeforeTokenTransfers function should use the hook.
    function useBeforeTokenTransfersHook(
        address,
        address,
        uint256,
        uint256
    ) external view returns (bool) {
        return beforeTokenTransfersHookEnabled[msg.sender];
    }

    /// @notice Custom implementation for AfterTokenTransfers Hook.
    function afterTokenTransfersOverrideHook(
        address from,
        address,
        uint256 startTokenId,
        uint256 quantity
    ) external {
        if (from != address(0)) {
            return;
        }

        if (erc6551Registry[msg.sender] != address(0)) {
            createTokenBoundAccounts(msg.sender, startTokenId, quantity);
        }

        // Subscription logic
        uint256[] memory tokenIds = getTokenIds(startTokenId, quantity);
        address subscription = ICre8ors(msg.sender).subscription();

        if (isFreeSubscriptionEnabled) {
            ISubscription(subscription).updateSubscriptionForFree({
                target: msg.sender,
                duration: ONE_YEAR_DURATION,
                tokenIds: tokenIds
            });
        } else {
            ISubscription(subscription).updateSubscription({
                target: msg.sender,
                duration: ONE_YEAR_DURATION,
                tokenIds: tokenIds
            });
        }
    }

    /// @notice Custom implementation for BeforeTokenTransfers Hook.
    function beforeTokenTransfersOverrideHook(
        address,
        address,
        uint256 startTokenId,
        uint256 quantity
    ) external view {
        uint256 tokenId = startTokenId;
        for (uint256 end = tokenId + quantity; tokenId < end; ++tokenId) {
            if (
                cre8ing.getCre8ingStarted(msg.sender, tokenId) != 0 &&
                cre8ingTransfer[msg.sender] != 1
            ) {
                revert ICre8ing.Cre8ing_Cre8ing();
            }
        }
    }

    function setCre8ing(
        address _target,
        ICre8ing _cre8ing
    ) external virtual onlyAdmin(_target) {
        cre8ing = _cre8ing;
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

    /// @notice Transfer a token between addresses while the CRE8OR is cre8ing,
    ///     thus not resetting the cre8ing period.
    function safeTransferWhileCre8ing(
        address target,
        address from,
        address to,
        uint256 tokenId
    ) external {
        if (ICre8ors(target).ownerOf(tokenId) != msg.sender) {
            revert IERC721Drop.Access_OnlyOwner();
        }
        cre8ingTransfer[target] = 1;
        ICre8ors(target).safeTransferFrom(from, to, tokenId);
        cre8ingTransfer[target] = 0;
    }
}

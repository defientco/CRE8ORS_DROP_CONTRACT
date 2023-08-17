// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import {IAfterTokenTransfersHook} from "ERC721H/interfaces/IAfterTokenTransfersHook.sol";
import {IBeforeTokenTransfersHook} from "ERC721H/interfaces/IBeforeTokenTransfersHook.sol";
import {ICre8ors} from "../interfaces/ICre8ors.sol";
import {ICre8ingV2} from "../interfaces/ICre8ingV2.sol";
import {IERC721Drop} from "../interfaces/IERC721Drop.sol";
import {Cre8orsAccessControl} from "../utils/Cre8orsAccessControl.sol";

/**
 ██████╗██████╗ ███████╗ █████╗  ██████╗ ██████╗ ███████╗
██╔════╝██╔══██╗██╔════╝██╔══██╗██╔═══██╗██╔══██╗██╔════╝
██║     ██████╔╝█████╗  ╚█████╔╝██║   ██║██████╔╝███████╗
██║     ██╔══██╗██╔══╝  ██╔══██╗██║   ██║██╔══██╗╚════██║
╚██████╗██║  ██║███████╗╚█████╔╝╚██████╔╝██║  ██║███████║
 ╚═════╝╚═╝  ╚═╝╚══════╝ ╚════╝  ╚═════╝ ╚═╝  ╚═╝╚══════╝                                                       
 */
/// @title Transfer Hook for Cre8ors
/// @notice This contract defines the behavior of token transfers for the Cre8ors platform,
///         both before and after the actual transfer.
/// @dev Implements the IAfterTokenTransfersHook and IBeforeTokenTransfersHook interfaces.
contract TransferHookv0_1 is
    IAfterTokenTransfersHook,
    IBeforeTokenTransfersHook,
    Cre8orsAccessControl
{
    /// @notice Event emitted when a token is locked.
    event Locked(uint256 tokenId);
    /// @notice Event emitted when a token is unlocked.
    event Unlocked(uint256 tokenId);

    ///@notice The address of the collection contract that mints and manages the tokens.
    address public cre8orsNFT;
    ///@notice The address of the contract for Staking.
    address public cre8ing;

    /// @dev MUST only be modified by safeTransferWhileCre8ing(); if set to 1 then
    /// the _beforeTokenTransfer() block while cre8ing is disabled.
    uint256 cre8ingTransfer;

    /// @notice Initializes the contract with the address of the Cre8orsNFT contract.
    /// @param _cre8orsNFT The address of the Cre8orsNFT contract to be used.
    constructor(address _cre8orsNFT) {
        cre8orsNFT = _cre8orsNFT;
    }

    /// @notice Set the Cre8orsNFT contract address.
    /// @dev This function can only be called by an admin, identified by the
    ///     "cre8orsNFT" contract address.
    /// @param _cre8orsNFT The new address of the Cre8orsNFT contract to be set.
    function setCre8orsNFT(address _cre8orsNFT) public onlyAdmin(cre8orsNFT) {
        cre8orsNFT = _cre8orsNFT;
    }

    /// @notice Custom implementation for AfterTokenTransfers Hook.
    /// @param from Address from which tokens are transferred.
    /// @param to Address to which tokens are transferred.
    /// @param startTokenId The starting ID of the token being transferred.
    /// @param quantity The number of tokens to transfer.
    function afterTokenTransfersHook(
        address from,
        address to,
        uint256 startTokenId,
        uint256 quantity
    ) external {
        // ONE TIME LOCK EMMISSION
        if (isAdmin(cre8orsNFT, to)) {
            uint256 _lastMintedTokenId = ICre8ors(cre8orsNFT)
                ._lastMintedTokenId();
            for (uint256 i = 1; i <= _lastMintedTokenId; ) {
                if (ICre8ingV2(cre8ing).getCre8ingStarted(cre8orsNFT, i) == 0) {
                    emit Unlocked(i);
                } else {
                    emit Locked(i);
                }
                unchecked {
                    i++;
                }
            }
        }

        emit AfterTokenTransfersHookUsed(from, to, startTokenId, quantity);
    }

    /// @notice Custom implementation for BeforeTokenTransfers Hook.
    /// @param from Address from which tokens are transferred.
    /// @param to Address to which tokens are transferred.
    /// @param startTokenId The starting ID of the token being transferred.
    /// @param quantity The number of tokens to transfer.
    function beforeTokenTransfersHook(
        address from,
        address to,
        uint256 startTokenId,
        uint256 quantity
    ) external {
        // IF SENT TO SELF => TOGGLE STAKED
        if (from == to) {
            uint256[] memory tokenIds = getTokenIds(startTokenId, quantity);
            ICre8ingV2(cre8ing).toggleCre8ingTokens(cre8orsNFT, tokenIds);
            return;
        }

        // BLOCK STAKED TRANSFERS
        uint256 tokenId = startTokenId;
        for (uint256 end = tokenId + quantity; tokenId < end; ++tokenId) {
            if (
                ICre8ingV2(cre8ing).getCre8ingStarted(msg.sender, tokenId) !=
                0 &&
                cre8ingTransfer != 1
            ) {
                revert ICre8ingV2.Cre8ing_Locked(tokenId);
            }
        }

        emit BeforeTokenTransfersHookUsed(from, to, startTokenId, quantity);
    }

    /// @notice Transfer a token between addresses while the CRE8OR is cre8ing,
    ///         thus not resetting the cre8ing period.
    /// @param from The address sending the token.
    /// @param to The address receiving the token.
    /// @param tokenId The ID of the token to be transferred.
    function safeTransferWhileCre8ing(
        address from,
        address to,
        uint256 tokenId
    ) external {
        address _cre8orsNFT = cre8orsNFT;
        if (ICre8ors(_cre8orsNFT).ownerOf(tokenId) != msg.sender) {
            revert IERC721Drop.Access_OnlyOwner();
        }
        cre8ingTransfer = 1;
        ICre8ors(_cre8orsNFT).safeTransferFrom(from, to, tokenId);
        cre8ingTransfer = 0;
    }

    /// @notice Set the address of the Cre8ing contract.
    /// @param _cre8ing The address of the Cre8ing contract.
    function setCre8ing(
        address _cre8ing
    ) external virtual onlyAdmin(cre8orsNFT) {
        cre8ing = _cre8ing;
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

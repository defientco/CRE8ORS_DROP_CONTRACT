// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import {IAfterTokenTransfersHook} from "ERC721H/interfaces/IAfterTokenTransfersHook.sol";
import {IBeforeTokenTransfersHook} from "ERC721H/interfaces/IBeforeTokenTransfersHook.sol";
import {ICre8ors} from "../interfaces/ICre8ors.sol";
import {ICre8ing} from "../interfaces/ICre8ing.sol";
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
    ///@notice The address of the collection contract that mints and manages the tokens.
    address public cre8orsNFT;
    ///@notice The address of the contract for Staking.
    address public cre8ing;
    /// @dev MUST only be modified by safeTransferWhileCre8ing(); if set to 1 then
    /// the _beforeTokenTransfer() block while cre8ing is disabled.
    uint256 cre8ingTransfer;

    /// @notice Initializes the contract with the address of the Cre8orsNFT contract.
    /// @param _cre8orsNFT The address of the Cre8orsNFT contract to be used.
    /// @param _cre8ing The address of the Staking contract to be used.
    constructor(address _cre8orsNFT, address _cre8ing) {
        cre8orsNFT = _cre8orsNFT;
        cre8ing = _cre8ing;
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
        emit BeforeTokenTransfersHookUsed(from, to, startTokenId, quantity);

        // only allow 4444 mints
        if (startTokenId + quantity > 4445) {
            revert ICre8ors.Cre8ors_4444();
        }

        // save gas on mints
        if (from == address(0)) {
            return;
        }

        // block staked transfers
        uint256 tokenId = startTokenId;
        for (uint256 end = tokenId + quantity; tokenId < end; ++tokenId) {
            if (
                ICre8ing(cre8ing).getCre8ingStarted(msg.sender, tokenId) != 0 &&
                cre8ingTransfer != 1
            ) {
                revert ICre8ing.Cre8ing_Cre8ing();
            }
        }
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

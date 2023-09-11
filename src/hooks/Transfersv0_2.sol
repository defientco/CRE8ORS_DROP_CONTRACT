// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import {IBeforeTokenTransfersHook} from "ERC721H/interfaces/IBeforeTokenTransfersHook.sol";
import {ICre8ors} from "../interfaces/ICre8ors.sol";
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
///         before the actual transfer.
/// @dev Implements the IBeforeTokenTransfersHook interface.
contract TransferHookv0_2 is IBeforeTokenTransfersHook, Cre8orsAccessControl {
    ///@notice The address of the collection contract that mints and manages the tokens.
    address public cre8orsNFT;

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
    }
}

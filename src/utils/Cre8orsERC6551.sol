// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import {IERC6551Registry} from "../interfaces/IERC6551Registry.sol";

/**
 ██████╗██████╗ ███████╗ █████╗  ██████╗ ██████╗ ███████╗
██╔════╝██╔══██╗██╔════╝██╔══██╗██╔═══██╗██╔══██╗██╔════╝
██║     ██████╔╝█████╗  ╚█████╔╝██║   ██║██████╔╝███████╗
██║     ██╔══██╗██╔══╝  ██╔══██╗██║   ██║██╔══██╗╚════██║
╚██████╗██║  ██║███████╗╚█████╔╝╚██████╔╝██║  ██║███████║
 ╚═════╝╚═╝  ╚═╝╚══════╝ ╚════╝  ╚═════╝ ╚═╝  ╚═╝╚══════╝                                                       
 */
/// @dev inspiration: https://github.com/ourzora/zora-drops-contracts
contract Cre8orsERC6551 {
    /// @dev The address of ERC6551 Registry
    address internal erc6551Registry;

    /// @dev Gas limit to send funds
    address internal erc6551AccountImplementation;

    /// @dev Initial data for ERC6551 createAccount
    bytes public constant INIT_DATA = "0x8129fc1c";

    /// @notice creates TBA with ERC6551
    /// @param startTokenId tokenID to start from
    /// @param quantity number of tokens to createAccount for
    function createTokenBoundAccounts(
        uint256 startTokenId,
        uint256 quantity
    ) internal {
        IERC6551Registry registry = IERC6551Registry(erc6551Registry);
        address implementation = erc6551AccountImplementation;
        for (uint256 i = 0; i < quantity; i++) {
            registry.createAccount(
                implementation,
                block.chainid,
                address(this),
                startTokenId + i,
                0,
                INIT_DATA
            );
        }
    }
}

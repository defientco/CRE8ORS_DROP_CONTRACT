// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import {IERC6551Registry} from "lib/ERC6551/src/interfaces/IERC6551Registry.sol";
import "forge-std/console.sol";

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
    address public erc6551Registry;

    /// @dev Gas limit to send funds
    address public erc6551AccountImplementation;

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
        console.log("registry %s", address(registry));
        address implementation = erc6551AccountImplementation;
        console.log("implementation %s", address(implementation));

        for (uint256 i = 0; i < quantity; i++) {
            console.log("createAccount %s", startTokenId + i);

            registry.createAccount(
                implementation,
                block.chainid,
                address(this),
                startTokenId + i,
                0,
                INIT_DATA
            );
            console.log("createAccount successfull %s", startTokenId + i);
        }
    }
}

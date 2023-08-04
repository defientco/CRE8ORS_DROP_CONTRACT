// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import {IERC6551Registry} from "lib/ERC6551/src/interfaces/IERC6551Registry.sol";

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
    mapping(address => address) public erc6551Registry;

    /// @dev The address of ERC6551 Account Implementation
    mapping(address => address) public erc6551AccountImplementation;

    /// @dev Initial data for ERC6551 createAccount
    bytes public constant INIT_DATA = "0x8129fc1c";

    /// @notice creates TBA with ERC6551
    /// @param _target target ERC721 contract
    /// @param startTokenId tokenID to start from
    /// @param quantity number of tokens to createAccount for
    function createTokenBoundAccounts(
        address _target,
        uint256 startTokenId,
        uint256 quantity
    ) internal {
        IERC6551Registry registry = IERC6551Registry(erc6551Registry[_target]);
        address implementation = erc6551AccountImplementation[_target];
        for (uint256 i = 0; i < quantity; i++) {
            registry.createAccount(
                implementation,
                block.chainid,
                _target,
                startTokenId + i,
                0,
                INIT_DATA
            );
        }
    }
}

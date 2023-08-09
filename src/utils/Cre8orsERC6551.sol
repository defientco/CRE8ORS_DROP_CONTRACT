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
/// @title Cre8orsERC6551 contract for handling ERC6551 token-bound accounts.
/// @dev inspiration: https://github.com/ourzora/zora-drops-contracts
contract Cre8orsERC6551 {
    /// @notice The address of ERC6551 Registry contract.
    address public erc6551Registry;

    /// @notice The address of ERC6551 Account Implementation contract.
    address public erc6551AccountImplementation;

    /// @notice Initializes the Cre8orsERC6551 contract with ERC6551 Registry and Implementation addresses.
    /// @param _registry The address of the ERC6551 registry contract.
    /// @param _implementation The address of the ERC6551 account implementation contract.
    constructor(address _registry, address _implementation) {
        erc6551Registry = _registry;
        erc6551AccountImplementation = _implementation;
    }

    /// @dev Initial data for ERC6551 createAccount function.
    bytes public constant INIT_DATA = "0x8129fc1c";

    /// @notice Creates Token Bound Accounts (TBA) with ERC6551.
    /// @dev Internal function used to create TBAs for a given ERC721 contract.
    /// @param _target Target ERC721 contract address.
    /// @param startTokenId Token ID to start from.
    /// @param quantity Number of token-bound accounts to create.
    /// @return airdropList An array containing the addresses of the created TBAs.
    function createTokenBoundAccounts(
        address _target,
        uint256 startTokenId,
        uint256 quantity
    ) internal returns (address[] memory airdropList) {
        IERC6551Registry registry = IERC6551Registry(erc6551Registry);
        airdropList = new address[](quantity);
        for (uint256 i = 0; i < quantity; i++) {
            address smartWallet = registry.createAccount(
                erc6551AccountImplementation,
                block.chainid,
                _target,
                startTokenId + i,
                0,
                INIT_DATA
            );
            airdropList[i] = smartWallet;
        }
    }
}

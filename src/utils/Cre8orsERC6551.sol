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

    function createTokenBoundAccount(uint256 tokenId) public {
        bytes memory initData = "0x8129fc1c";
        IERC6551Registry(erc6551Registry).createAccount(
            erc6551AccountImplementation,
            block.chainid,
            address(this),
            tokenId,
            0,
            initData
        );
    }
}

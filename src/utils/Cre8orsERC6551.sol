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
    address public erc6551Registry = 0x02101dfB77FDE026414827Fdc604ddAF224F0921;

    /// @dev The address of ERC6551 Account Implementation
    address public erc6551AccountImplementation =
        0x2D25602551487C3f3354dD80D76D54383A243358;

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

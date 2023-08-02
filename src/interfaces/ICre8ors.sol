// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import {IERC721Drop} from "./IERC721Drop.sol";
import {ILockup} from "./ILockup.sol";
import {IERC721A} from "erc721a/contracts/IERC721A.sol";
import {ICre8ing} from "./ICre8ing.sol";

/**
 ██████╗██████╗ ███████╗ █████╗  ██████╗ ██████╗ ███████╗
██╔════╝██╔══██╗██╔════╝██╔══██╗██╔═══██╗██╔══██╗██╔════╝
██║     ██████╔╝█████╗  ╚█████╔╝██║   ██║██████╔╝███████╗
██║     ██╔══██╗██╔══╝  ██╔══██╗██║   ██║██╔══██╗╚════██║
╚██████╗██║  ██║███████╗╚█████╔╝╚██████╔╝██║  ██║███████║
 ╚═════╝╚═╝  ╚═╝╚══════╝ ╚════╝  ╚═════╝ ╚═╝  ╚═╝╚══════╝                                                       
*/
/// @notice Interface for Cre8ors Drops contract
interface ICre8ors is IERC721Drop, IERC721A {
    function cre8ing() external view returns (ICre8ing);
    /// @notice Getter for last minted token ID (gets next token id and subtracts 1)
    function _lastMintedTokenId() external view returns (uint256);

    function ownerOf(uint256 tokenId) external view  returns (address);
}

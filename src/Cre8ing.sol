// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import {ERC721A} from "lib/ERC721A/contracts/ERC721A.sol";
import {IERC721A} from "lib/ERC721A/contracts/IERC721A.sol";
import {AccessControl} from "lib/openzeppelin-contracts/contracts/access/AccessControl.sol";
import {IERC2981, IERC165} from "lib/openzeppelin-contracts/contracts/interfaces/IERC2981.sol";
import {ReentrancyGuard} from "lib/openzeppelin-contracts/contracts/security/ReentrancyGuard.sol";
import {MerkleProof} from "lib/openzeppelin-contracts/contracts/utils/cryptography/MerkleProof.sol";
import {IERC721Drop} from "./interfaces/IERC721Drop.sol";
import {IMetadataRenderer} from "./interfaces/IMetadataRenderer.sol";
import {ERC721DropStorageV1} from "./storage/ERC721DropStorageV1.sol";
import {OwnableSkeleton} from "./utils/OwnableSkeleton.sol";
import {IOwnable} from "./interfaces/IOwnable.sol";

/**
 ██████╗██████╗ ███████╗ █████╗  ██████╗ ██████╗ ███████╗
██╔════╝██╔══██╗██╔════╝██╔══██╗██╔═══██╗██╔══██╗██╔════╝
██║     ██████╔╝█████╗  ╚█████╔╝██║   ██║██████╔╝███████╗
██║     ██╔══██╗██╔══╝  ██╔══██╗██║   ██║██╔══██╗╚════██║
╚██████╗██║  ██║███████╗╚█████╔╝╚██████╔╝██║  ██║███████║
 ╚═════╝╚═╝  ╚═╝╚══════╝ ╚════╝  ╚═════╝ ╚═╝  ╚═╝╚══════╝                                                       
 */
/// @dev inspiration: https://etherscan.io/address/0x23581767a106ae21c074b2276d25e5c3e136a68b#code
contract Cre8ing {
    /// @dev tokenId to cre8ing start time (0 = not cre8ing).
    mapping(uint256 => uint256) private cre8ingStarted;
    /// @dev Cumulative per-token cre8ing, excluding the current period.
    mapping(uint256 => uint256) private cre8ingTotal;

    /// @notice Whether nesting is currently allowed.
    /// @dev If false then nesting is blocked, but unnesting is always allowed.
    bool public cre8ingOpen = false;

    /// @notice Returns the length of time, in seconds, that the CRE8OR has cre8ed.
    /// @dev Cre8ing is tied to a specific CRE8OR, not to the owner, so it doesn't
    ///     reset upon sale.
    /// @return cre8ing Whether the CRE8OR is currently cre8ing. MAY be true with
    ///     zero current cre8ing if in the same block as cre8ing began.
    /// @return current Zero if not currently cre8ing, otherwise the length of time
    ///     since the most recent cre8ing began.
    /// @return total Total period of time for which the CRE8OR has cre8ed across
    ///     its life, including the current period.
    function cre8ingPeriod(uint256 tokenId)
        external
        view
        returns (
            bool cre8ing,
            uint256 current,
            uint256 total
        )
    {
        uint256 start = cre8ingStarted[tokenId];
        if (start != 0) {
            cre8ing = true;
            current = block.timestamp - start;
        }
        total = current + cre8ingTotal[tokenId];
    }
}

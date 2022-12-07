// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import {Cre8iveAdmin} from "./Cre8iveAdmin.sol";

/**
 ██████╗██████╗ ███████╗ █████╗  ██████╗ ██████╗ ███████╗
██╔════╝██╔══██╗██╔════╝██╔══██╗██╔═══██╗██╔══██╗██╔════╝
██║     ██████╔╝█████╗  ╚█████╔╝██║   ██║██████╔╝███████╗
██║     ██╔══██╗██╔══╝  ██╔══██╗██║   ██║██╔══██╗╚════██║
╚██████╗██║  ██║███████╗╚█████╔╝╚██████╔╝██║  ██║███████║
 ╚═════╝╚═╝  ╚═╝╚══════╝ ╚════╝  ╚═════╝ ╚═╝  ╚═╝╚══════╝                                                       
 */
/// @dev inspiration: https://etherscan.io/address/0x23581767a106ae21c074b2276d25e5c3e136a68b#code
contract Cre8ing is Cre8iveAdmin {
    /// @dev tokenId to cre8ing start time (0 = not cre8ing).
    mapping(uint256 => uint256) internal cre8ingStarted;
    /// @dev Cumulative per-token cre8ing, excluding the current period.
    mapping(uint256 => uint256) internal cre8ingTotal;

    /// @dev Emitted when a CRE8OR begins cre8ing.
    event Cre8ed(uint256 indexed tokenId);

    /// @dev Emitted when a CRE8OR stops cre8ing; either through standard means or
    ///     by expulsion.
    event Uncre8ed(uint256 indexed tokenId);

    constructor(address _initialOwner) Cre8iveAdmin(_initialOwner) {}

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

    /// @notice Toggles the `nestingOpen` flag.
    function setCre8ingOpen(bool open)
        external
        onlyRoleOrAdmin(SALES_MANAGER_ROLE)
    {
        cre8ingOpen = open;
    }
}

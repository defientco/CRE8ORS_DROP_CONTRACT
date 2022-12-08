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
    /// @dev MUST only be modified by safeTransferWhileNesting(); if set to 2 then
    ///     the _beforeTokenTransfer() block while nesting is disabled.
    uint256 internal cre8ingTransfer = 1;

    /// @dev Emitted when a CRE8OR begins cre8ing.
    event Cre8ed(uint256 indexed tokenId);

    /// @dev Emitted when a CRE8OR stops cre8ing; either through standard means or
    ///     by expulsion.
    event Uncre8ed(uint256 indexed tokenId);

    /// @dev Emitted when a CRE8OR is expelled from the Warehouse.
    event Expelled(uint256 indexed tokenId);

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

    /// @notice Admin-only ability to expel a Moonbird from the nest.
    /// @dev As most sales listings use off-chain signatures it's impossible to
    ///     detect someone who has nested and then deliberately undercuts the floor
    ///     price in the knowledge that the sale can't proceed. This function allows for
    ///     monitoring of such practices and expulsion if abuse is detected, allowing
    ///     the undercutting bird to be sold on the open market. Since OpenSea uses
    ///     isApprovedForAll() in its pre-listing checks, we can't block by that means
    ///     because nesting would then be all-or-nothing for all of a particular owner's
    ///     Moonbirds.
    function expelFromWarehouse(uint256 tokenId)
        external
        onlyRole(EXPULSION_ROLE)
    {
        require(cre8ingStarted[tokenId] != 0, "Moonbirds: not nested");
        cre8ingTotal[tokenId] += block.timestamp - cre8ingStarted[tokenId];
        cre8ingStarted[tokenId] = 0;
        emit Uncre8ed(tokenId);
        emit Expelled(tokenId);
    }
}

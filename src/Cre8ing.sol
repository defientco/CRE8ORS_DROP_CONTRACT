// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import {ICre8ing} from "./interfaces/ICre8ing.sol";
import {ICre8ors} from "./interfaces/ICre8ors.sol";
import {ILockup} from "./interfaces/ILockup.sol";
import {IERC721Drop} from "./interfaces/IERC721Drop.sol";
import {IERC721A} from "erc721a/contracts/IERC721A.sol";

/**
 ██████╗██████╗ ███████╗ █████╗  ██████╗ ██████╗ ███████╗
██╔════╝██╔══██╗██╔════╝██╔══██╗██╔═══██╗██╔══██╗██╔════╝
██║     ██████╔╝█████╗  ╚█████╔╝██║   ██║██████╔╝███████╗
██║     ██╔══██╗██╔══╝  ██╔══██╗██║   ██║██╔══██╗╚════██║
╚██████╗██║  ██║███████╗╚█████╔╝╚██████╔╝██║  ██║███████║
 ╚═════╝╚═╝  ╚═╝╚══════╝ ╚════╝  ╚═════╝ ╚═╝  ╚═╝╚══════╝                                                       
 */
/// @dev inspiration: https://etherscan.io/address/0x23581767a106ae21c074b2276d25e5c3e136a68b#code
contract Cre8ing is ICre8ing {
    /// @dev tokenId to cre8ing start time (0 = not cre8ing).
    mapping(address => mapping(uint256 => uint256)) internal cre8ingStarted;
    /// @dev Cumulative per-token cre8ing, excluding the current period.
    mapping(address => mapping(uint256 => uint256)) internal cre8ingTotal;
    /// @dev Lockup for target.
    mapping(address => ILockup) public lockup;

    /// @notice Whether cre8ing is currently allowed.
    /// @dev If false then cre8ing is blocked, but uncre8ing is always allowed.
    mapping(address => bool) public cre8ingOpen;

    /// @notice Returns the length of time, in seconds, that the CRE8OR has cre8ed.
    /// @dev Cre8ing is tied to a specific CRE8OR, not to the owner, so it doesn't
    ///     reset upon sale.
    /// @return cre8ing Whether the CRE8OR is currently cre8ing. MAY be true with
    ///     zero current cre8ing if in the same block as cre8ing began.
    /// @return current Zero if not currently cre8ing, otherwise the length of time
    ///     since the most recent cre8ing began.
    /// @return total Total period of time for which the CRE8OR has cre8ed across
    ///     its life, including the current period.
    function cre8ingPeriod(
        address _target,
        uint256 tokenId
    ) external view returns (bool cre8ing, uint256 current, uint256 total) {
        uint256 start = cre8ingStarted[_target][tokenId];
        if (start != 0) {
            cre8ing = true;
            current = block.timestamp - start;
        }
        total = current + cre8ingTotal[_target][tokenId];
    }

    /// @notice Toggles the `cre8ingOpen` flag.
    function setCre8ingOpen(
        address _target,
        bool open
    ) external onlyAdmin(_target) {
        cre8ingOpen[_target] = open;
    }

    /// @notice Admin-only ability to expel a CRE8OR from the Warehouse.
    /// @dev As most sales listings use off-chain signatures it's impossible to
    ///     detect someone who has cre8ed and then deliberately undercuts the floor
    ///     price in the knowledge that the sale can't proceed. This function allows for
    ///     monitoring of such practices and expulsion if abuse is detected, allowing
    ///     the undercutting CRE8OR to be sold on the open market. Since OpenSea uses
    ///     isApprovedForAll() in its pre-listing checks, we can't block by that means
    ///     because cre8ing would then be all-or-nothing for all of a particular owner's
    ///     CRE8OR.
    function expelFromWarehouse(
        address _target,
        uint256 tokenId
    ) external onlyAdmin(_target) {
        if (cre8ingStarted[_target][tokenId] == 0) {
            revert CRE8ING_NotCre8ing(_target, tokenId);
        }
        cre8ingTotal[_target][tokenId] +=
            block.timestamp -
            cre8ingStarted[_target][tokenId];
        cre8ingStarted[_target][tokenId] = 0;
        emit Uncre8ed(_target, tokenId);
        emit Expelled(_target, tokenId);
    }

    /// @notice put a CRE8OR in the warehouse
    /// @param tokenId token to put in the Warehouse
    function enterWarehouse(address _target, uint256 tokenId) internal {
        if (!cre8ingOpen[_target]) {
            revert Cre8ing_Cre8ingClosed();
        }
        cre8ingStarted[_target][tokenId] = block.timestamp;
        emit Cre8ed(_target, tokenId);
    }

    /// @notice exit a CRE8OR from the warehouse
    /// @param tokenId token to exit from the warehouse
    function leaveWarehouse(address _target, uint256 tokenId) internal {
        _requireUnlocked(_target, tokenId);
        uint256 start = cre8ingStarted[_target][tokenId];
        cre8ingTotal[_target][tokenId] += block.timestamp - start;
        cre8ingStarted[_target][tokenId] = 0;
        emit Uncre8ed(_target, tokenId);
    }

    /////////////////////////////////////////////////
    /// CRE8ING
    /////////////////////////////////////////////////

    /// @notice Changes the CRE8ORs' cre8ing statuss (what's the plural of status?
    ///     statii? statuses? status? The plural of sheep is sheep; maybe it's also the
    ///     plural of status).
    /// @dev Changes the CRE8ORs' cre8ing sheep (see @notice).
    function toggleCre8ingTokens(
        address _target,
        uint256[] calldata tokenIds
    ) external {
        uint256 n = tokenIds.length;
        for (uint256 i = 0; i < n; ++i) {
            _toggleCre8ingToken(_target, tokenIds[i]);
        }
    }

    /// @notice Changes the CRE8OR's cre8ing status.
    /// @param tokenId token to toggle cre8ing status
    function _toggleCre8ingToken(
        address _target,
        uint256 tokenId
    ) internal onlyApprovedOrOwner(_target, tokenId) {
        uint256 start = cre8ingStarted[_target][tokenId];
        if (start == 0) {
            enterWarehouse(_target, tokenId);
        } else {
            leaveWarehouse(_target, tokenId);
        }
    }

    /// @notice array of staked tokenIDs
    /// @dev used in cre8ors ui to quickly get list of staked NFTs.
    function cre8ingTokens(
        address _target
    ) external view returns (uint256[] memory stakedTokens) {
        uint256 size = ICre8ors(_target)._lastMintedTokenId();
        stakedTokens = new uint256[](size);
        for (uint256 i = 1; i < size + 1; ++i) {
            uint256 start = cre8ingStarted[_target][i];
            if (start != 0) {
                stakedTokens[i - 1] = i;
            }
        }
    }

    /////////////////////////////////////////////////
    /// LOCK UP
    /////////////////////////////////////////////////

    function setLockup(
        address _target,
        ILockup newLockup
    ) external onlyAdmin(_target) {
        lockup[_target] = newLockup;
    }

    function _requireUnlocked(address _target, uint256 tokenId) internal {
        if (
            address(lockup[_target]) != address(0) &&
            lockup[_target].isLocked(_target, tokenId)
        ) {
            revert ILockup.Lockup_Locked();
        }
    }

    function getCre8ingStarted(
        address _target,
        uint256 tokenId
    ) external view returns (uint256) {
        return cre8ingStarted[_target][tokenId];
    }

    function lockUp(address _address) external view returns (ILockup) {
        return lockup[_address];
    }

    /// @notice Requires that msg.sender owns or is approved for the token.
    modifier onlyApprovedOrOwner(address _target, uint256 tokenId) {
        if (
            ICre8ors(_target).ownerOf(tokenId) != msg.sender &&
            ICre8ors(_target).getApproved(tokenId) != msg.sender
        ) {
            revert IERC721Drop.Access_MissingOwnerOrApproved();
        }

        _;
    }

    /// @notice Only allow for users with admin access
    modifier onlyAdmin(address _target) {
        if (!isAdmin(_target, msg.sender)) {
            revert IERC721Drop.Access_OnlyAdmin();
        }

        _;
    }

    /// @notice Getter for admin role associated with the contract to handle minting
    /// @param user user address
    /// @return boolean if address is admin
    function isAdmin(address _target, address user) public view returns (bool) {
        return IERC721Drop(_target).isAdmin(user);
    }
}

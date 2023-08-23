// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import {ICre8ors} from "../interfaces/ICre8ors.sol";
import {IERC721Drop} from "../interfaces/IERC721Drop.sol";

/**
 ██████╗██████╗ ███████╗ █████╗  ██████╗ ██████╗ ███████╗
██╔════╝██╔══██╗██╔════╝██╔══██╗██╔═══██╗██╔══██╗██╔════╝
██║     ██████╔╝█████╗  ╚█████╔╝██║   ██║██████╔╝███████╗
██║     ██╔══██╗██╔══╝  ██╔══██╗██║   ██║██╔══██╗╚════██║
╚██████╗██║  ██║███████╗╚█████╔╝╚██████╔╝██║  ██║███████║
 ╚═════╝╚═╝  ╚═╝╚══════╝ ╚════╝  ╚═════╝ ╚═╝  ╚═╝╚══════╝                                                       
 */
contract Cre8orsAccessControl {
    /// @notice Access control roles
    bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
    bytes32 public immutable MINTER_ROLE = keccak256("MINTER");

    /// @notice Missing the minter role or admin access
    error AdminAccess_MissingMinterOrAdmin();

    /// @notice Modifier to require the sender to be an admin
    /// @param target address that the user wants to modify
    modifier onlyMinterOrAdmin(address target) {
        if (
            target != msg.sender &&
            !isAdmin(target, msg.sender) &&
            !ICre8ors(target).hasRole(MINTER_ROLE, msg.sender)
        ) {
            revert AdminAccess_MissingMinterOrAdmin();
        }

        _;
    }

    /// @notice Check if an address has admin access.
    /// @param _target The target address.
    /// @param user The user address to check.
    /// @return true if the address has admin access, false otherwise.
    function isAdmin(address _target, address user) public view returns (bool) {
        return IERC721Drop(_target).isAdmin(user);
    }

    /// @notice Modifier for admin access only.
    /// @param _target The target address.
    modifier onlyAdmin(address _target) {
        if (!isAdmin(_target, msg.sender)) {
            revert IERC721Drop.Access_OnlyAdmin();
        }

        _;
    }
}

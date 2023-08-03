// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import {IERC721Drop} from "../../interfaces/IERC721Drop.sol";
import {IAccessControl} from "@openzeppelin/contracts/access/IAccessControl.sol";
import {Base} from "./Base.sol";

/// @title Admin
/// @notice An abstract contract with access control functionality.
abstract contract Admin is Base {
    /// @notice Access control roles
    bytes32 public constant MINTER_ROLE = keccak256("MINTER");

    /// @notice Modifier to allow only users with admin access
    /// @param target The address of the contract implementing the access control
    modifier onlyAdmin(address target) {
        if (!isAdmin(target, msg.sender)) {
            revert IERC721Drop.Access_OnlyAdmin();
        }

        _;
    }

    /// @notice Modifier to allow only a given role or admin access
    /// @param target The address of the contract implementing the access control
    /// @param role The role to check for alongside the admin role
    modifier onlyRoleOrAdmin(address target, bytes32 role) {
        if (!isAdmin(target, msg.sender) && !IAccessControl(target).hasRole(role, msg.sender)) {
            revert IERC721Drop.Access_MissingRoleOrAdmin(role);
        }

        _;
    }

    /// @notice Getter for admin role associated with the contract to handle minting
    /// @param target The address of the contract implementing the access control
    /// @param user The address to check for admin access
    /// @return Whether the address has admin access or not
    function isAdmin(address target, address user) public view returns (bool) {
        return IERC721Drop(target).isAdmin(user);
    }
}

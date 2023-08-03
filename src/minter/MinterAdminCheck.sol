// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import {ICre8ors} from "../interfaces/ICre8ors.sol";

contract MinterAdminCheck {
    /// @notice Access control roles
    bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
    bytes32 public immutable MINTER_ROLE = keccak256("MINTER");

    /// @notice Missing the minter role or admin access
    error AdminAccess_MissingMinterOrAdmin();

    /// @notice Modifier to require the sender to be an admin
    /// @param target address that the user wants to modify
    modifier onlyMinterOrAdmin(address target) {
        if (
            target != msg.sender && !ICre8ors(target).hasRole(DEFAULT_ADMIN_ROLE, msg.sender)
                && !ICre8ors(target).hasRole(MINTER_ROLE, msg.sender)
        ) {
            revert AdminAccess_MissingMinterOrAdmin();
        }

        _;
    }
}

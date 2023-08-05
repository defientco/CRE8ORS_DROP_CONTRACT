// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import {ICre8ors} from "./interfaces/ICre8ors.sol";

// FOR INITIALIZER
import {IERC721ACH} from "ERC721H/interfaces/IERC721ACH.sol";
import {ICre8ing} from "../src/interfaces/ICre8ing.sol";
import {IERC721Drop} from "./interfaces/IERC721Drop.sol";
import {ILockup} from "./interfaces/ILockup.sol";

/**
 ██████╗██████╗ ███████╗ █████╗  ██████╗ ██████╗ ███████╗
██╔════╝██╔══██╗██╔════╝██╔══██╗██╔═══██╗██╔══██╗██╔════╝
██║     ██████╔╝█████╗  ╚█████╔╝██║   ██║██████╔╝███████╗
██║     ██╔══██╗██╔══╝  ██╔══██╗██║   ██║██╔══██╗╚════██║
╚██████╗██║  ██║███████╗╚█████╔╝╚██████╔╝██║  ██║███████║
 ╚═════╝╚═╝  ╚═╝╚══════╝ ╚════╝  ╚═════╝ ╚═╝  ╚═╝╚══════╝                                                       
 */
/// @dev inspiration: https://github.com/ourzora/zora-drops-contracts
contract Initializer {
    function setup(
        address _target,
        address _subscription,
        address _hookAddress,
        address _cre8ing,
        address _lockup
    ) external onlyAdmin(_target) {
        ICre8ors(_target).setSubscription(_subscription);
        IERC721ACH(_target).setHook(
            IERC721ACH.HookType.AfterTokenTransfers,
            _hookAddress
        );
        ICre8ors(_target).setCre8ing(ICre8ing(_cre8ing));
        ICre8ing(_cre8ing).setCre8ingOpen(_target, true);
        ICre8ing(_cre8ing).setLockup(_target, ILockup(_lockup));
    }

    /// @notice Modifier for admin access only.
    /// @param _target The target address.
    modifier onlyAdmin(address _target) {
        if (!isAdmin(_target, msg.sender)) {
            revert IERC721Drop.Access_OnlyAdmin();
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
}

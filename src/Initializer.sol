// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import {ICre8ors} from "./interfaces/ICre8ors.sol";
import {IERC721ACH} from "ERC721H/interfaces/IERC721ACH.sol";
import {ICre8ing} from "../src/interfaces/ICre8ing.sol";
import {IERC721Drop} from "./interfaces/IERC721Drop.sol";
import {ILockup} from "./interfaces/ILockup.sol";
import {IAccessControl} from "@openzeppelin/contracts/access/IAccessControl.sol";

/**
 ██████╗██████╗ ███████╗ █████╗  ██████╗ ██████╗ ███████╗
██╔════╝██╔══██╗██╔════╝██╔══██╗██╔═══██╗██╔══██╗██╔════╝
██║     ██████╔╝█████╗  ╚█████╔╝██║   ██║██████╔╝███████╗
██║     ██╔══██╗██╔══╝  ██╔══██╗██║   ██║██╔══██╗╚════██║
╚██████╗██║  ██║███████╗╚█████╔╝╚██████╔╝██║  ██║███████║
 ╚═════╝╚═╝  ╚═╝╚══════╝ ╚════╝  ╚═════╝ ╚═╝  ╚═╝╚══════╝                                                       
 */
contract Initializer {
    function setup(
        address _target,
        address _subscription,
        address _hookAddress,
        address _cre8ing,
        address _lockup,
        address _familyAndFriendsMinter,
        address _collectionHolderMinter,
        address _allowlistMinter,
        address _publicMinter
    ) external onlyAdmin(_target) {
        ICre8ors(_target).setSubscription(_subscription);
        IERC721ACH(_target).setHook(
            IERC721ACH.HookType.AfterTokenTransfers,
            _hookAddress
        );
        ITransfer(_hookAddress).setAfterTokenTransfersEnabled(_target, true);
        ICre8ors(_target).setCre8ing(ICre8ing(_cre8ing));
        ICre8ing(_cre8ing).setCre8ingOpen(_target, true);
        ICre8ing(_cre8ing).setLockup(_target, ILockup(_lockup));
        IAccessControl(_target).grantRole(
            ICre8ors(_target).MINTER_ROLE(),
            _familyAndFriendsMinter
        );
        IAccessControl(_target).grantRole(
            ICre8ors(_target).MINTER_ROLE(),
            _collectionHolderMinter
        );
        IAccessControl(_target).grantRole(
            ICre8ors(_target).MINTER_ROLE(),
            _allowlistMinter
        );
        IAccessControl(_target).grantRole(
            ICre8ors(_target).MINTER_ROLE(),
            _publicMinter
        );
        IAccessControl(_target).grantRole(
            ICre8ors(_target).MINTER_ROLE(),
            _cre8ing
        );
        IAccessControl(_target).grantRole(
            ICre8ors(_target).MINTER_ROLE(),
            _hookAddress
        );
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

interface ITransfer {
    function setAfterTokenTransfersEnabled(
        address _target,
        bool _enabled
    ) external;
}

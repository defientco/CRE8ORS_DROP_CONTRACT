// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import {IERC721ACH} from "ERC721H/interfaces/IERC721ACH.sol";
import {ICre8ors} from "./interfaces/ICre8ors.sol";
import {ICre8ing} from "../src/interfaces/ICre8ing.sol";
import {IERC721Drop} from "./interfaces/IERC721Drop.sol";
import {ILockup} from "./interfaces/ILockup.sol";
import {IHookBase} from "./interfaces/IHookBase.sol";
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
    bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;

    function setup(
        address _target,
        address _subscription,
        address _transfersHookAddress,
        address _ownerOfHookAddress,
        address _cre8ing,
        address _lockup,
        address _familyAndFriendsMinter,
        address _collectionHolderMinter,
        address _allowlistMinter,
        address _publicMinter,
        address _dna
    ) external onlyAdmin(_target) {
        IERC721ACH(_target).setHook(
            IERC721ACH.HookType.BeforeTokenTransfers,
            _transfersHookAddress
        );
        IERC721ACH(_target).setHook(
            IERC721ACH.HookType.AfterTokenTransfers,
            _transfersHookAddress
        );
        IERC721ACH(_target).setHook(
            IERC721ACH.HookType.OwnerOf,
            _ownerOfHookAddress
        );
        IHookBase(_transfersHookAddress).setSubscription(
            _target,
            _subscription
        );
        IHookBase(_ownerOfHookAddress).setSubscription(_target, _subscription);
        ICre8ing(_cre8ing).setCre8ingOpen(_target, true);
        ITransfer(_transfersHookAddress).setCre8ing(_cre8ing);
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
            _transfersHookAddress
        );
        ITransfer(_transfersHookAddress).setDnaNFT(_dna);
        IAccessControl(_dna).grantRole(
            DEFAULT_ADMIN_ROLE,
            _transfersHookAddress
        );
        // renounce DEFAULT_ADMIN_ROLE
        IAccessControl(_target).renounceRole(DEFAULT_ADMIN_ROLE, address(this));
        IAccessControl(_dna).renounceRole(DEFAULT_ADMIN_ROLE, address(this));
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
    function setCre8ing(address _cre8ing) external;

    function setDnaNFT(address _dnaNft) external;
}

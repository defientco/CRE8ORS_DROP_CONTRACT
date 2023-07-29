// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import {IBeforeLeaveWarehouseHook} from "../../../src/interfaces/IBeforeLeaveWarehouseHook.sol";
import {ILockup} from "../../../src/interfaces/ILockup.sol";

contract BeforeLeaveWarehouseHookMock is IBeforeLeaveWarehouseHook  {

    ILockup public lockup;
    bool public hookEnabled;

    

    function setHookEnabled(bool _enabled) public {
        hookEnabled = _enabled;
    }
    function useBeforeLeaveWarehouseHook(uint256 tokenId) external view returns (bool) {
        return hookEnabled;
    }

    function beforeLeaveWarehouseOverrideHook (uint256 tokenId) external {
        _requireUnlocked(tokenId);
    }

    function setLockup(ILockup newLockup) external  {
        lockup = newLockup;
    }

    function _requireUnlocked(uint256 tokenId) internal {
        if (
            address(lockup) != address(0) &&
            lockup.isLocked(address(this), tokenId)
        ) {
            revert ILockup.Lockup_Locked();
        }
    }


}
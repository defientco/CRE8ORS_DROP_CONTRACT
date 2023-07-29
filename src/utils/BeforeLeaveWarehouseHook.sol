// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import { IBeforeLeaveWarehouseHook } from "../interfaces/IBeforeLeaveWarehouseHook.sol";
import { ILockup } from "../interfaces/ILockup.sol";
import { OwnableSkeleton } from "./OwnableSkeleton.sol";

contract BeforeLeaveWarehouseHook is IBeforeLeaveWarehouseHook, OwnableSkeleton  {

    address public cre8ors;
    ILockup public lockup;
    bool public hookEnabled;

    constructor (address _initialOwner) {
        _setOwner(_initialOwner);
    }
    

    function setHookEnabled(bool _enabled) public {
        hookEnabled = _enabled;
    }
    function useBeforeLeaveWarehouseHook(uint256 tokenId) external view returns (bool) {
        return hookEnabled;
    }

    function beforeLeaveWarehouseOverrideHook (uint256 tokenId) external {
        _requireUnlocked(tokenId);
    }

    function setLockup(ILockup newLockup, address cre8ors) external onlyOwner {
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

    function setOwner(address newAddress) public onlyOwner {
        _setOwner(newAddress);
    }

    modifier onlyOwner() {
        require(owner() == msg.sender, "Requires owner role");
        _;
    }

}
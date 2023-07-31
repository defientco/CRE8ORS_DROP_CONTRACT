// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import {IBeforeTokenTransfersHook} from "ERC721H/interfaces/IBeforeTokenTransfersHook.sol";

contract BeforeTokenTransfersHookMock is IBeforeTokenTransfersHook {
    /// @notice hook was executed
    error BeforeTokenTransfersHook_Executed();

    bool public hooksEnabled;

    /// @notice toggle balanceOf hook.
    function setHooksEnabled(bool _enabled) public {
        hooksEnabled = _enabled;
    }
   
    /// @notice Check if the beforeTokenTransfers function should use hook.
    /// @dev Returns whether or not to use the hook for beforeTokenTransfers function
    function useBeforeTokenTransfersHook(
        address,
        address,
        uint256,
        uint256
    ) external view override returns (bool) {
        return hooksEnabled;
    }


    /// @notice custom implementation for beforeTokenTransfers Hook.
    function beforeTokenTransfersOverrideHook(
        address,
        address,
        uint256,
        uint256
    ) external pure override  {
        revert BeforeTokenTransfersHook_Executed();
    }
}

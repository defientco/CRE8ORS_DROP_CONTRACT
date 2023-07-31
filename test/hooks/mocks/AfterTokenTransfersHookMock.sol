// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import {IAfterTokenTransfersHook} from "ERC721H/interfaces/IAfterTokenTransfersHook.sol";

contract AfterTokenTransfersHookMock is IAfterTokenTransfersHook {
    /// @notice hook was executed
    error AfterTokenTransfersHook_Executed();

    bool public hooksEnabled;

    /// @notice toggle balanceOf hook.
    function setHooksEnabled(bool _enabled) public {
        hooksEnabled = _enabled;
    }
   
    /// @notice Check if the AfterTokenTransfers function should use hook.
    /// @dev Returns whether or not to use the hook for AfterTokenTransfers function
    function useAfterTokenTransfersHook(
        address,
        address,
        uint256,
        uint256
    ) external view override returns (bool) {
        return hooksEnabled;
    }


    /// @notice custom implementation for AfterTokenTransfers Hook.
    function afterTokenTransfersOverrideHook(
        address,
        address,
        uint256,
        uint256
    ) external pure override  {
        revert AfterTokenTransfersHook_Executed();
    }
}

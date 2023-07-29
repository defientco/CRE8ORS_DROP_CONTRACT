// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;


interface ICre8ingHooks {

    /**
        * @dev Enumerated list of all available hook types for the ERC721ACH contract.
    */
     enum HookType {
        
        /// @notice Hook for custom logic before a token leaves warehouse.
        BeforeLeaveWarehouse,
        /// @notice Hook for custom logic after token leaves warehouse.
        AfterLeaveWarehouse
       
    }


    /**
     * @notice Sets the contract address for a specified hook type.
     * @param hookType The type of hook to set, as defined in the HookType enum.
     * @param hookAddress The address of the contract implementing the hook interface.
     */
    function setHook(HookType hookType, address hookAddress) external;

    /**
     * @notice Returns the contract address for a specified hook type.
     * @param hookType The type of hook to set, as defined in the HookType enum.
     * @return The address of the contract implementing the hook interface.
     */
    function getHook(HookType hookType) external view returns (address);

}
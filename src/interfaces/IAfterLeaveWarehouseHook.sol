// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

/// @title IAfterLeaveWarehouseHook
/// @dev Interface that defines hook to be exexcuted after leaving warehouse
interface IAfterLeaveWarehouseHook {

/** 
@notice Emmitted when the after leave warehouse hook is used.
@param tokenId leaving the warehouse 
*/
event AfterLeaveWarehouseHookUsed(uint256 tokenId);

/**
@notice Checks if the token transfer function should use the custom hook
@param tokenId the token id after leaving the warehouse 
*/
function useAfterLeaveWarehouseHook(uint256 tokenId) external view returns (bool);

/** 
@notice Provides a custom implementation for after leaving the warehouse
@param tokenId leaving the warehouse 
*/
function afterLeaveWarehouseOverrideHook (uint256 tokenId) external;

}
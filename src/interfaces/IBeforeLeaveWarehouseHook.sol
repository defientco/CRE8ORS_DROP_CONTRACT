// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

/// @title IBeforeLeaveWarehouseHook
/// @dev Interface that defines hook to be exexcuted before leaving warehouse
interface IBeforeLeaveWarehouseHook {

/** 
@notice Emmitted when the before leave warehouse hook is used.
@param tokenId leaving the warehouse 
*/
event BeforeLeaveWarehouseHookUsed(uint256 tokenId);

/**
@notice Checks if the token transfer function should use the custom hook
@param tokenId the token id leaving the warehouse 
*/
function useBeforeLeaveWarehouseHook(uint256 tokenId) external view returns (bool);

/** 
@notice Provides a custom implementation for before leaving the warehouse
@param tokenId leaving the warehouse 
*/
function beforeLeaveWarehouseOverrideHook (uint256 tokenId) external;

}
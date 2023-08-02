// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import {Cre8orsERC6551} from "./utils/Cre8orsERC6551.sol";
import {Cre8iveAdmin} from "./Cre8iveAdmin.sol";
import "forge-std/console.sol";



contract TransferHook is  Cre8orsERC6551, Cre8iveAdmin  {

    
    /// @notice Only admin can access this function
    error Access_OnlyAdmin();
    
    bool public afterTokenTransfersHookEnabled;
    bool public beforeTokenTransfersHookEnabled;
    address public owner;

    address public baseContract;

    constructor( address _owner) Cre8iveAdmin(_owner) {}

    /// @notice Only allow for users with admin access
    modifier onlyAdmin() {
        if (!hasRole(DEFAULT_ADMIN_ROLE, msg.sender)) {
            revert Access_OnlyAdmin();
        }

        _;
    }


    /// @notice Set ERC6551 registry
    /// @param _registry ERC6551 registry
    function setErc6551Registry(address _registry) public onlyAdmin {
        erc6551Registry = _registry;
    }

    /// @notice Set ERC6551 account implementation
    /// @param _implementation ERC6551 account implementation
    function setErc6551Implementation(
        address _implementation
    ) public onlyAdmin {
        erc6551AccountImplementation = _implementation;
    }


    /// @notice Toggle afterTokenTransfers hook.
    /// add admin only 
    function setAfterTokenTransfersEnabled(bool _enabled) public onlyAdmin {
        afterTokenTransfersHookEnabled = _enabled;
    }

   
    /// @notice Check if the AfterTokenTransfers function should use the hook.
    function useAfterTokenTransfersHook(
        address,
        address,
        uint256,
        uint256
    ) external view returns (bool) {
        return afterTokenTransfersHookEnabled;
    }

    /// @notice Custom implementation for AfterTokenTransfers Hook.
    function afterTokenTransfersOverrideHook(
        address from,
        address to,
        uint256 startTokenId,
        uint256 quantity
    ) external {
        console.log( "from %s",from);
        console.log( "erc6551Registry %s",erc6551Registry);
        console.log( "to %s",to);
        console.log( "startTokenId %s",startTokenId);
        
        if (from == address(0) && erc6551Registry != address(0)) {
            createTokenBoundAccounts(startTokenId, quantity);
        }
    }



}

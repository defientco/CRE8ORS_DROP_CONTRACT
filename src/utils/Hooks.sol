// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;


import {Cre8ing} from "../Cre8ing.sol";
import {Cre8orsERC6551} from "../utils/Cre8orsERC6551.sol";
import {IBeforeTokenTransfersHook} from "ERC721H/interfaces/IBeforeTokenTransfersHook.sol";

import {IAfterTokenTransfersHook} from "ERC721H/interfaces/IAfterTokenTransfersHook.sol";

import "forge-std/console.sol";




contract Hooks is Cre8ing, Cre8orsERC6551{
    
    bool public afterTokenTransfersHookEnabled;
    bool public beforeTokenTransfersHookEnabled;
    address public owner;


    constructor(address _initialOwner) Cre8ing(_initialOwner) {} 

  

    /// @notice Toggle afterTokenTransfers hook.
    /// add admin only 
    function setAfterTokenTransfersEnabled(bool _enabled) public  {
        afterTokenTransfersHookEnabled = _enabled;
    }

    /// @notice Toggle beforeTokenTransfers hook.
    function setBeforeTokenTransfersEnabled(bool _enabled) public  {
        beforeTokenTransfersHookEnabled = _enabled;
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

    /// @notice Check if the BeforeTokenTransfers function should use the hook.
    function useBeforeTokenTransfersHook(
                address,
        address,
        uint256,
        uint256
    ) external view returns (bool) {
        return beforeTokenTransfersHookEnabled;
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

     /// @notice Custom implementation for BeforeTokenTransfers Hook.
    function beforeTokenTransfersOverrideHook(
        address from,
        address to,
        uint256 startTokenId,
        uint256 quantity
    ) external {
        uint256 tokenId = startTokenId;
        console.logUint( tokenId);
        console.logUint( cre8ingTransfer);
        console.log( "cre8ingStarted[tokenId] %s",cre8ingStarted[tokenId]); // the problem is here

        for (uint256 end = tokenId + quantity; tokenId < end; ++tokenId) {
            if (cre8ingStarted[tokenId] != 0 && cre8ingTransfer != 2) {
                revert Cre8ing_Cre8ing();
            }
        }
    }

}

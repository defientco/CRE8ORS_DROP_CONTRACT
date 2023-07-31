// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;


import {Cre8ing} from "../Cre8ing.sol";
import {Cre8orsERC6551} from "../utils/Cre8orsERC6551.sol";




contract Hooks is Cre8ing, Cre8orsERC6551 {
    
    bool public afterTokenTransfersHookEnabled;
    bool public beforeTokenTransfersHookEnabled;
    address public owner;


    constructor(address _initialOwner) Cre8ing(_initialOwner) {} 

  

    /// @notice Toggle afterTokenTransfers hook.
    function setAfterTokenTransfersEnabled(bool _enabled) public  {
        afterTokenTransfersHookEnabled = _enabled;
    }

    /// @notice Toggle beforeTokenTransfers hook.
    function setBeforeTokenTransfersEnabled(bool _enabled) public  {
        beforeTokenTransfersHookEnabled = _enabled;
    }
   
    /// @notice Check if the AfterTokenTransfers function should use the hook.
    function useAfterTokenTransfersHook() external view returns (bool) {
        return afterTokenTransfersHookEnabled;
    }

    /// @notice Check if the BeforeTokenTransfers function should use the hook.
    function useBeforeTokenTransfersHook() external view returns (bool) {
        return beforeTokenTransfersHookEnabled;
    }

    /// @notice Custom implementation for AfterTokenTransfers Hook.
    function afterTokenTransfersOverrideHook(
        address from,
        address to,
        uint256 startTokenId,
        uint256 quantity
    ) external {
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
        for (uint256 end = tokenId + quantity; tokenId < end; ++tokenId) {
            if (cre8ingStarted[tokenId] != 0 && cre8ingTransfer != 2) {
                revert Cre8ing_Cre8ing();
            }
        }
    }

}

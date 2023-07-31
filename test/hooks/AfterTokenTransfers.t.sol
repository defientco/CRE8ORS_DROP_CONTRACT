// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "forge-std/Test.sol";
import {Cre8orTestBase} from "../utils/Cre8orTestBase.sol";
import  {AfterTokenTransfersHookMock} from "../hooks/mocks/AfterTokenTransfersHookMock.sol";
import {DummyMetadataRenderer} from "../utils/DummyMetadataRenderer.sol";
import {IERC721Drop} from "../../src/interfaces/IERC721Drop.sol";
import {Strings} from "../../lib/openzeppelin-contracts/contracts/utils/Strings.sol";
import {IERC721ACH} from "ERC721H/interfaces/IERC721ACH.sol";


contract AfterTokenTransfersHookTest is Test, Cre8orTestBase {

    IERC721ACH.HookType constant AfterTokenTransfers = IERC721ACH.HookType.AfterTokenTransfers;
    AfterTokenTransfersHookMock  hookMock;

    
    function setUp() public {
        vm.startPrank(DEFAULT_OWNER_ADDRESS);
        Cre8orTestBase.cre8orSetup();
        hookMock = new AfterTokenTransfersHookMock();
        vm.stopPrank();
    }

    function test_setAfterTokenTransferHook() public {
        
        assertEq(address(0), address(cre8orsNFTBase.getHook(AfterTokenTransfers)));

        // should revert if not called by the cre8or contract
        vm.expectRevert();
        cre8orsNFTBase.setHook(AfterTokenTransfers, address(hookMock));

        vm.startPrank(DEFAULT_OWNER_ADDRESS);
        cre8orsNFTBase.setHook(AfterTokenTransfers, address(hookMock));

        assertEq(address(hookMock), address(cre8orsNFTBase.getHook(AfterTokenTransfers)));


        // performing a mint should triggger the _afterTokenTransfer hook
        hookMock.setHooksEnabled(true);

        vm.expectRevert(AfterTokenTransfersHookMock.AfterTokenTransfersHook_Executed.selector);

        cre8orsNFTBase.adminMint(DEFAULT_OWNER_ADDRESS, 1);

        vm.stopPrank();


    }


    

}
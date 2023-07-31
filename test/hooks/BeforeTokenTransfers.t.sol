// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "forge-std/Test.sol";
import {Cre8orTestBase} from "../utils/Cre8orTestBase.sol";
import  {BeforeTokenTransfersHookMock} from "../hooks/mocks/BeforeTokenTransfersHookMock.sol";
import {DummyMetadataRenderer} from "../utils/DummyMetadataRenderer.sol";
import {IERC721Drop} from "../../src/interfaces/IERC721Drop.sol";
import {Strings} from "../../lib/openzeppelin-contracts/contracts/utils/Strings.sol";
import {IERC721ACH} from "ERC721H/interfaces/IERC721ACH.sol";


contract BeforeTokenTransfersHookTest is Test, Cre8orTestBase {

    IERC721ACH.HookType constant BeforeTokenTransfers = IERC721ACH.HookType.BeforeTokenTransfers;
    BeforeTokenTransfersHookMock  hookMock;

    
    function setUp() public {
        vm.startPrank(DEFAULT_OWNER_ADDRESS);
        Cre8orTestBase.cre8orSetup();
        hookMock = new BeforeTokenTransfersHookMock();
        vm.stopPrank();
    }

    function test_setBeforeTokenTransferHook() public {
        
        assertEq(address(0), address(cre8orsNFTBase.getHook(BeforeTokenTransfers)));

        // should revert if not called by the cre8or contract
        vm.expectRevert();
        cre8orsNFTBase.setHook(BeforeTokenTransfers, address(hookMock));

        vm.startPrank(DEFAULT_OWNER_ADDRESS);
        cre8orsNFTBase.setHook(BeforeTokenTransfers, address(hookMock));

        assertEq(address(hookMock), address(cre8orsNFTBase.getHook(BeforeTokenTransfers)));


        // performing a mint should triggger the _beforeTokenTransfer hook
        hookMock.setHooksEnabled(true);

        vm.expectRevert(BeforeTokenTransfersHookMock.BeforeTokenTransfersHook_Executed.selector);

        cre8orsNFTBase.adminMint(DEFAULT_OWNER_ADDRESS, 1);

        vm.stopPrank();


    }


    

}
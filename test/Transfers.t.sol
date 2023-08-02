import {TransferHook} from "../src/Transfers.sol";

import {IERC721ACH} from "ERC721H/interfaces/IERC721ACH.sol";

import {Cre8orTestBase} from "./utils/Cre8orTestBase.sol";

import {Cre8ing} from "../src/Cre8ing.sol";

import {ICre8ing} from "../src/interfaces/ICre8ing.sol";

import {IERC721Drop} from "../src/interfaces/IERC721Drop.sol";

import "forge-std/Test.sol";

contract TransfersTest is Test, Cre8orTestBase {
    Cre8ing public cre8ingBase;
    TransferHook public transferHook;

    address public constant DEFAULT_CRE8OR_ADDRESS = address(456);
    address public constant DEFAULT_TRANSFER_ADDRESS = address(0x2);

    function setUp() public {
        Cre8orTestBase.cre8orSetup();
        cre8ingBase = new Cre8ing();
        transferHook = new TransferHook();
        vm.prank(DEFAULT_OWNER_ADDRESS);
        cre8orsNFTBase.setCre8ing(cre8ingBase);
    
    }

    function test_setBeforeTokenTransfersEnabled_revert_Access_OnlyAdmin() public {
        vm.expectRevert(IERC721Drop.Access_OnlyAdmin.selector);
        transferHook.setBeforeTokenTransfersEnabled(
            address(cre8orsNFTBase),
            true
        );
    }

    function test_setAfterTokenTransfersEnabled_revert_Access_OnlyAdmin() public {
        vm.expectRevert(IERC721Drop.Access_OnlyAdmin.selector);
        transferHook.setAfterTokenTransfersEnabled(
            address(cre8orsNFTBase),
            false
        );
    }

    function test_setCre8ing_revert_Access_OnlyAdmin() public {
        vm.expectRevert(IERC721Drop.Access_OnlyAdmin.selector);
        transferHook.setCre8ing(
            address(cre8orsNFTBase),
            ICre8ing(cre8ingBase)
        );
    }

    function test_settingBeforeTokenTransfersHook() public {
        vm.startPrank(DEFAULT_OWNER_ADDRESS);
        transferHook.setBeforeTokenTransfersEnabled(
            address(cre8orsNFTBase),
            true
        );
        assertTrue(transferHook.beforeTokenTransfersHookEnabled(address(cre8orsNFTBase)));

        cre8orsNFTBase.setHook(
            IERC721ACH.HookType.BeforeTokenTransfers,
            address(transferHook)
        );

        assertEq(
            address(transferHook),
            cre8orsNFTBase.getHook(IERC721ACH.HookType.BeforeTokenTransfers)
        );
        vm.stopPrank();
    }

    function test_settingAfterTokenTransfersHook() public {
        vm.startPrank(DEFAULT_OWNER_ADDRESS);
        transferHook.setAfterTokenTransfersEnabled(
            address(cre8orsNFTBase),
            true
        );
        assertTrue(transferHook.afterTokenTransfersHookEnabled(address(cre8orsNFTBase)));

        cre8orsNFTBase.setHook(
            IERC721ACH.HookType.AfterTokenTransfers,
            address(transferHook)
        );

        assertEq(
            address(transferHook),
            cre8orsNFTBase.getHook(IERC721ACH.HookType.AfterTokenTransfers)
        );
        vm.stopPrank();
    }


 

   

  

  
  

  



}
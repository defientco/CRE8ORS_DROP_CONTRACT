// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import {Vm} from "forge-std/Vm.sol";
import {DSTest} from "ds-test/test.sol";
import {Cre8ors} from "../src/Cre8ors.sol";
import {DummyMetadataRenderer} from "./utils/DummyMetadataRenderer.sol";
import {IERC721Drop} from "../src/interfaces/IERC721Drop.sol";
import {IERC721A} from "lib/ERC721A/contracts/IERC721A.sol";
import {IERC2981, IERC165} from "lib/openzeppelin-contracts/contracts/interfaces/IERC2981.sol";
import {IOwnable} from "../src/interfaces/IOwnable.sol";
import {ERC6551Registry} from "lib/ERC6551/src/ERC6551Registry.sol";
import {Account} from "lib/tokenbound/src/Account.sol";
import {AccountGuardian} from "lib/tokenbound/src/AccountGuardian.sol";
import {EntryPoint} from "lib/account-abstraction/contracts/core/EntryPoint.sol";
import {Cre8ing} from "../src/Cre8ing.sol";
import {TransferHook} from "../src/Transfers.sol";
import {ICre8ors} from "../src/interfaces/ICre8ors.sol";
import {Cre8orTestBase} from "./utils/Cre8orTestBase.sol";
import {IERC721ACH} from "ERC721H/interfaces/IERC721ACH.sol";
import {IAfterTokenTransfersHook} from "ERC721H/interfaces/IAfterTokenTransfersHook.sol";
import {IERC6551Registry} from "lib/ERC6551/src/interfaces/IERC6551Registry.sol";

import "forge-std/console.sol";

error NotAuthorized();

contract ERC6551Test is DSTest, Cre8orTestBase {
    Cre8ing public cre8ingBase;
    Vm public constant vm = Vm(HEVM_ADDRESS);
    ERC6551Registry erc6551Registry;
    AccountGuardian guardian;
    EntryPoint entryPoint;
    Account erc6551Implementation;
    TransferHook public transferHook;
    address constant DEAD_ADDRESS =
        address(0x000000000000000000000000000000000000dEaD);

    function setUp() public {
        Cre8orTestBase.cre8orSetup();
        erc6551Registry = new ERC6551Registry();
        guardian = new AccountGuardian();
        entryPoint = new EntryPoint();
        erc6551Implementation = new Account(
            address(guardian),
            address(entryPoint)
        );
        cre8ingBase = new Cre8ing();
        transferHook = new TransferHook(
            DEFAULT_OWNER_ADDRESS,
            address(cre8orsNFTBase)
        );
        vm.startPrank(DEFAULT_OWNER_ADDRESS);
        cre8orsNFTBase.setCre8ing(cre8ingBase);
        cre8orsNFTBase.setHook(
            IERC721ACH.HookType.AfterTokenTransfers,
            address(transferHook)
        );
        transferHook.setAfterTokenTransfersEnabled(true);
        vm.stopPrank();
    }

    function test_Erc6551Registry() public {
        address tokenBoundAccount = getTBA(1);
        assertTrue(!isContract(tokenBoundAccount));
    }

    function test_setErc6551Registry_revert_Access_OnlyAdmin() public {
        vm.expectRevert(IERC721Drop.Access_OnlyAdmin.selector);
        transferHook.setErc6551Registry(address(erc6551Registry));
    }

    function test_setErc6551Implementation_revert_Access_OnlyAdmin() public {
        vm.expectRevert(IERC721Drop.Access_OnlyAdmin.selector);
        transferHook.setErc6551Implementation(address(erc6551Implementation));
    }

    function test_createAccount() public setupErc6551 {
        address tokenBoundAccount = getTBA(1);

        // MINT REGISTERS WITH ERC6511
        assertTrue(!isContract(tokenBoundAccount));
        address afterHookAddress = cre8orsNFTBase.getHook(
            IERC721ACH.HookType.AfterTokenTransfers
        );
        assertEq(address(transferHook), afterHookAddress);
        IAfterTokenTransfersHook afterHook = IAfterTokenTransfersHook(
            afterHookAddress
        );
        assertTrue(
            afterHook.useAfterTokenTransfersHook(
                afterHookAddress,
                afterHookAddress,
                1,
                1
            )
        );
        cre8orsNFTBase.purchase(1);
        emit log_string("SWEETS TBA");
        emit log_address(tokenBoundAccount);
        tokenBoundAccount = getTBA(1);
        emit log_address(tokenBoundAccount);

        assertTrue(isContract(tokenBoundAccount));
    }

    // function test_createMultipleAccounts() public setupErc6551 {
    //     uint256 quantity = 8;

    //     // No ERC6551 before purchase
    //     for (uint256 i = 1; i <= quantity; i++) {
    //         address tokenBoundAccount = getTBA(i);
    //         assertTrue(!isContract(tokenBoundAccount));
    //     }

    //     // MINT REGISTERS WITH ERC6511
    //     cre8orsNFTBase.purchase(quantity);

    //     // All CRE8ORS have ERC6551 after purchase
    //     for (uint256 i = 1; i <= quantity; i++) {
    //         address tokenBoundAccount = getTBA(i);
    //         assertTrue(isContract(tokenBoundAccount));
    //     }
    // }

    // function test_sendWithTBA() public setupErc6551 {
    //     address payable tokenBoundAccount = payable(getTBA(1));

    //     // MINT REGISTERS WITH ERC6511
    //     assertTrue(!isContract(tokenBoundAccount));
    //     cre8orsNFTBase.purchase(3);
    //     assertTrue(isContract(tokenBoundAccount));

    //     // TBA used to mint another CRE8OR
    //     assertEq(cre8orsNFTBase.balanceOf(tokenBoundAccount), 0);
    //     uint256 value;
    //     bytes memory data = abi.encodeWithSignature("purchase(uint256)", 1);
    //     bytes memory response = Account(tokenBoundAccount).executeCall(
    //         address(cre8orsNFTBase),
    //         value,
    //         data
    //     );
    //     uint256 tokenId = abi.decode(response, (uint256));
    //     assertEq(cre8orsNFTBase.balanceOf(tokenBoundAccount), 1);

    //     // use TBA to burn CRE8OR
    //     data = abi.encodeWithSignature(
    //         "safeTransferFrom(address,address,uint256)",
    //         tokenBoundAccount,
    //         DEAD_ADDRESS,
    //         tokenId + 1
    //     );
    //     Account(tokenBoundAccount).executeCall(
    //         address(cre8orsNFTBase),
    //         value,
    //         data
    //     );
    //     assertEq(cre8orsNFTBase.balanceOf(tokenBoundAccount), 0);
    // }

    // function test_sendWithTBA_revert_NotAuthorized() public setupErc6551 {
    //     address payable tokenBoundAccount = payable(getTBA(1));

    //     // MINT REGISTERS WITH ERC6511
    //     assertTrue(!isContract(tokenBoundAccount));
    //     vm.prank(DEFAULT_OWNER_ADDRESS);
    //     cre8orsNFTBase.purchase(3);
    //     assertTrue(isContract(tokenBoundAccount));

    //     // TBA used to mint another CRE8OR
    //     assertEq(cre8orsNFTBase.balanceOf(tokenBoundAccount), 0);
    //     uint256 value;
    //     bytes memory data = abi.encodeWithSignature("purchase(uint256)", 1);
    //     vm.expectRevert(NotAuthorized.selector);
    //     Account(tokenBoundAccount).executeCall(
    //         address(cre8orsNFTBase),
    //         value,
    //         data
    //     );
    //     assertEq(cre8orsNFTBase.balanceOf(tokenBoundAccount), 0);
    // }

    // function test_transfer_only() public setupErc6551 {
    //     uint256 quantity = 888;
    //     address BUYER = address(0x123);
    //     vm.startPrank(BUYER);
    //     cre8orsNFTBase.purchase(quantity);
    //     for (uint256 i = 1; i <= quantity; i++) {
    //         cre8orsNFTBase.safeTransferFrom(BUYER, DEAD_ADDRESS, i);
    //     }
    // }

    modifier setupErc6551() {
        vm.startPrank(DEFAULT_OWNER_ADDRESS);
        transferHook.setErc6551Registry(address(erc6551Registry));
        transferHook.setErc6551Implementation(address(erc6551Implementation));
        vm.stopPrank();
        _;
    }

    function isContract(address _addr) private view returns (bool) {
        uint32 size;
        assembly {
            size := extcodesize(_addr)
        }
        return (size > 0);
    }

    function getTBA(uint256 tokenId) private view returns (address) {
        address payable tokenBoundAccount = payable(
            IERC6551Registry(transferHook.erc6551Registry()).account(
                address(erc6551Implementation),
                1,
                address(cre8orsNFTBase),
                tokenId,
                0
            )
        );
        return tokenBoundAccount;
    }
}

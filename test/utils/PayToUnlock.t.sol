// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import {Vm} from "forge-std/Vm.sol";
import {DSTest} from "ds-test/test.sol";
import {Lockup} from "../../src/utils/Lockup.sol";
import {PayToUnlock} from "../../src/utils/PayToUnlock.sol";
import {ILockup} from "../../src/interfaces/ILockup.sol";
import {Cre8orTestBase} from "./Cre8orTestBase.sol";
import {IERC721Drop} from "../../src/interfaces/IERC721Drop.sol";

contract PayToUnlockTest is DSTest, Cre8orTestBase {
    Vm public constant vm = Vm(HEVM_ADDRESS);
    PayToUnlock payToUnlock = new PayToUnlock();
    Lockup lockup = new Lockup();
    uint64 secondsPerMonth = 2_628_288;
    uint64 eightMonths = 8 * secondsPerMonth;

    function setUp() public {
        vm.startPrank(DEFAULT_OWNER_ADDRESS);
        Cre8orTestBase.cre8orSetup();
        vm.stopPrank();
        vm.prank(DEFAULT_BUYER_ADDRESS);
        cre8orsNFTBase.purchase(1);
    }

    function test_PayToUnlock() public {
        assertEq(address(cre8orsNFTBase.payToUnlock()), address(0));
    }

    function test_setPayToUnlock() public {
        assertEq(address(cre8orsNFTBase.payToUnlock()), address(0));
        _setupPayToUnlock();
        assertEq(address(cre8orsNFTBase.payToUnlock()), address(payToUnlock));
    }

    function test_setPayToUnlock_revert_Access_OnlyAdmin() public {
        assertEq(address(cre8orsNFTBase.payToUnlock()), address(0));
        vm.expectRevert(IERC721Drop.Access_OnlyAdmin.selector);
        cre8orsNFTBase.setPayToUnlock(payToUnlock);
        assertEq(address(cre8orsNFTBase.payToUnlock()), address(0));
    }

    function test_lockup() public {
        assertEq(
            address(payToUnlock.lockup(address(cre8orsNFTBase))),
            address(0)
        );
        _setupPayToUnlock();
        assertEq(
            address(payToUnlock.lockup(address(cre8orsNFTBase))),
            address(lockup)
        );
    }

    function test_amountToUnlock() public {
        assertEq(payToUnlock.amountToUnlock(address(cre8orsNFTBase), 1), 0);
        _setupPayToUnlock();
        assertEq(payToUnlock.amountToUnlock(address(cre8orsNFTBase), 1), 0);
    }

    function _setupPayToUnlock() internal {
        vm.startPrank(DEFAULT_OWNER_ADDRESS);
        cre8orsNFTBase.setLockup(lockup);
        cre8orsNFTBase.setPayToUnlock(payToUnlock);
        vm.stopPrank();
    }
}

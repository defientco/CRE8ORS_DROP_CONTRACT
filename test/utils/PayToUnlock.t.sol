// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import {Vm} from "forge-std/Vm.sol";
import {DSTest} from "ds-test/test.sol";
import {Lockup} from "../../src/utils/Lockup.sol";
import {ILockup} from "../../src/interfaces/ILockup.sol";
import {Cre8orTestBase} from "./Cre8orTestBase.sol";
import {IERC721Drop} from "../../src/interfaces/IERC721Drop.sol";

contract PayToUnlockTest is DSTest, Cre8orTestBase {
    Vm public constant vm = Vm(HEVM_ADDRESS);
    Lockup lockup = new Lockup();

    function setUp() public {
        vm.startPrank(DEFAULT_OWNER_ADDRESS);
        Cre8orTestBase.cre8orSetup();
        vm.stopPrank();
    }

    function test_PayToUnlock() public {
        assertEq(address(cre8orsNFTBase.payToUnlock()), address(0));
    }
}

// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import "forge-std/Test.sol";
import {Cre8ing} from "../src/Cre8ing.sol";

contract CounterTest is Test {
    Cre8ing public cre8ingBase;

    function setUp() public {
        cre8ingBase = new Cre8ing();
    }

    function test_cre8ingPeriod() public {
        (bool cre8ing, uint256 current, uint256 total) = cre8ingBase
            .cre8ingPeriod(1);
        assertEq(cre8ing, false);
        assertEq(current, 0);
        assertEq(total, 0);
    }

    function test_cre8ingOpen() public {
        assertEq(cre8ingBase.cre8ingOpen(), false);
    }
}

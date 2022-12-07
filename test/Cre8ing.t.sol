// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import "forge-std/Test.sol";
import {Cre8ing} from "../src/Cre8ing.sol";

contract CounterTest is Test {
    Cre8ing public cre8ingBase;

    modifier setupCre8ing() {
        cre8ingBase = new Cre8ing();

        _;
    }

    function test_cre8ingPeriod() public setupCre8ing {
        (bool cre8ing, uint256 current, uint256 total) = cre8ingBase
            .cre8ingPeriod(1);
        assertEq(cre8ing, false);
        assertEq(current, 0);
        assertEq(total, 0);
    }
}

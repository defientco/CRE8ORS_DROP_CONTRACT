// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Cre8ors.sol";

contract CounterTest is Test {
    Cre8ors public c;

    function setUp() public {
        c = new Cre8ors();
    }

    function testErc721() public {
        assertEq("CRE8ORS", c.name());
        assertEq("CRE8", c.symbol());
    }
}

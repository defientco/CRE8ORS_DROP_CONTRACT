// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import {Vm} from "forge-std/Vm.sol";
import {DSTest} from "ds-test/test.sol";
import {ERC721HACMock} from "./utils/ERC721HACMock.sol";

contract ERC721HACTest is DSTest {
    Vm public constant vm = Vm(HEVM_ADDRESS);
    address public constant DEFAULT_OWNER_ADDRESS = address(0x23499);
    ERC721HACMock erc721Hac;

    function setUp() public {
        vm.startPrank(DEFAULT_OWNER_ADDRESS);
        erc721Hac = new ERC721HACMock();
        vm.stopPrank();
    }

    function test_Erc721() public {
        assertEq("ERC-721HAC Mock", erc721Hac.name());
        assertEq("MOCK", erc721Hac.symbol());
    }
}

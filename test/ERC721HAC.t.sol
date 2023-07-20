// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import {Vm} from "forge-std/Vm.sol";
import {DSTest} from "ds-test/test.sol";
import {ERC721HACMock} from "./utils/ERC721HACMock.sol";
import {IERC721A} from "lib/ERC721A/contracts/IERC721A.sol";

contract ERC721ACHTest is DSTest {
    Vm public constant vm = Vm(HEVM_ADDRESS);
    address public constant DEFAULT_OWNER_ADDRESS = address(0x23499);
    address public constant DEFAULT_BUYER_ADDRESS = address(0x111);
    ERC721HACMock erc721Mock;

    function setUp() public {
        vm.startPrank(DEFAULT_OWNER_ADDRESS);
        erc721Mock = new ERC721HACMock();
        vm.stopPrank();
    }

    function test_Erc721() public {
        assertEq("ERC-721HAC Mock", erc721Mock.name());
        assertEq("MOCK", erc721Mock.symbol());
    }

    function test_balanceOf(uint256 _mintQuantity) public {
        vm.assume(_mintQuantity > 0);
        vm.assume(_mintQuantity < 10_000);

        // Verify normal functionality
        assertEq(0, erc721Mock.balanceOf(DEFAULT_BUYER_ADDRESS));
        erc721Mock.mint(DEFAULT_BUYER_ADDRESS, _mintQuantity);
        assertEq(_mintQuantity, erc721Mock.balanceOf(DEFAULT_BUYER_ADDRESS));

        // Verify hook override
        erc721Mock.setHooksEnabled(true);
        assertEq(0, erc721Mock.balanceOf(DEFAULT_BUYER_ADDRESS));
    }

    function test_ownerOf(uint256 _mintQuantity) public {
        vm.assume(_mintQuantity > 0);
        vm.assume(_mintQuantity < 10_000);

        // Verify normal functionality
        vm.expectRevert(IERC721A.OwnerQueryForNonexistentToken.selector);
        assertEq(erc721Mock.ownerOf(_mintQuantity), address(0));
        erc721Mock.mint(DEFAULT_BUYER_ADDRESS, _mintQuantity);
        assertEq(DEFAULT_BUYER_ADDRESS, erc721Mock.ownerOf(_mintQuantity));

        // Verify hook override
        erc721Mock.setHooksEnabled(true);
        assertEq(erc721Mock.ownerOf(_mintQuantity), address(0));
    }
}

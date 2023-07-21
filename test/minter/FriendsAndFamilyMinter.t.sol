// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;
import {Vm} from "forge-std/Vm.sol";
import {DSTest} from "ds-test/test.sol";
import {Lockup} from "../../src/utils/Lockup.sol";
import {ILockup} from "../../src/interfaces/ILockup.sol";
import {ICre8ors} from "../../src/interfaces/ICre8ors.sol";
import {Cre8orTestBase} from "../utils/Cre8orTestBase.sol";
import {IERC721Drop} from "../../src/interfaces/IERC721Drop.sol";
import {Cre8ors} from "../../src/Cre8ors.sol";
import {FriendsAndFamilyMinter} from "../../src/minter/FriendsAndFamilyMinter.sol";
import {Cre8orTestBase} from "../utils/Cre8orTestBase.sol";
import {DummyMetadataRenderer} from "../utils/DummyMetadataRenderer.sol";

contract FriendsAndFamilyMinterTest is DSTest, Cre8orTestBase {
    FriendsAndFamilyMinter public minter;
    Vm public constant vm = Vm(HEVM_ADDRESS);
    Lockup lockup = new Lockup();

    function setUp() public {
        Cre8orTestBase.cre8orSetup();
        minter = new FriendsAndFamilyMinter(address(cre8orsNFTBase));
    }

    function testLockup() public {
        assertEq(address(cre8orsNFTBase.lockup()), address(0));
    }

    function testSuccesfulMintWithoutLockup() public {
        vm.startPrank(DEFAULT_OWNER_ADDRESS);
        cre8orsNFTBase.grantRole(
            cre8orsNFTBase.DEFAULT_ADMIN_ROLE(),
            address(minter)
        );
        assertTrue(
            cre8orsNFTBase.hasRole(
                cre8orsNFTBase.DEFAULT_ADMIN_ROLE(),
                address(minter)
            )
        );
        vm.stopPrank();
        vm.startPrank(DEFAULT_OWNER_ADDRESS, DEFAULT_BUYER_ADDRESS);
        assertTrue(!minter.hasDiscount(DEFAULT_BUYER_ADDRESS));
        minter.addDiscount(DEFAULT_BUYER_ADDRESS);
        assertTrue(minter.hasDiscount(DEFAULT_BUYER_ADDRESS));
        uint256 tokenId = minter.mint(DEFAULT_BUYER_ADDRESS);
        assertTrue(!minter.hasDiscount(DEFAULT_BUYER_ADDRESS));
        vm.stopPrank();
        assertEq(tokenId, 1);
        assertEq(cre8orsNFTBase.ownerOf(tokenId), DEFAULT_BUYER_ADDRESS);
        assertEq(
            cre8orsNFTBase.mintedPerAddress(DEFAULT_BUYER_ADDRESS).totalMints,
            1
        );
    }

    function testSuccesfulMintWithLockup() public {
        vm.startPrank(DEFAULT_OWNER_ADDRESS);
        cre8orsNFTBase.grantRole(
            cre8orsNFTBase.DEFAULT_ADMIN_ROLE(),
            address(minter)
        );
        assertTrue(
            cre8orsNFTBase.hasRole(
                cre8orsNFTBase.DEFAULT_ADMIN_ROLE(),
                address(minter)
            )
        );
        cre8orsNFTBase.setLockup(lockup);
        vm.stopPrank();

        vm.startPrank(DEFAULT_OWNER_ADDRESS, DEFAULT_BUYER_ADDRESS);
        assertTrue(!minter.hasDiscount(DEFAULT_BUYER_ADDRESS));
        minter.addDiscount(DEFAULT_BUYER_ADDRESS);
        assertTrue(minter.hasDiscount(DEFAULT_BUYER_ADDRESS));

        uint256 tokenId = minter.mint(DEFAULT_BUYER_ADDRESS);
        assertTrue(!minter.hasDiscount(DEFAULT_BUYER_ADDRESS));
        vm.stopPrank();

        assertEq(tokenId, 1);
        assertEq(cre8orsNFTBase.ownerOf(tokenId), DEFAULT_BUYER_ADDRESS);
        assertEq(
            cre8orsNFTBase.mintedPerAddress(DEFAULT_BUYER_ADDRESS).totalMints,
            1
        );
    }

    function testRevertNoDiscount() public {
        vm.startPrank(DEFAULT_OWNER_ADDRESS);
        cre8orsNFTBase.grantRole(
            cre8orsNFTBase.DEFAULT_ADMIN_ROLE(),
            address(minter)
        );
        assertTrue(
            cre8orsNFTBase.hasRole(
                cre8orsNFTBase.DEFAULT_ADMIN_ROLE(),
                address(minter)
            )
        );
        vm.stopPrank();
        vm.startPrank(DEFAULT_BUYER_ADDRESS);
        assertTrue(!minter.hasDiscount(DEFAULT_BUYER_ADDRESS));
        vm.expectRevert(FriendsAndFamilyMinter.MissingDiscount.selector);
        minter.mint(DEFAULT_BUYER_ADDRESS);
        vm.stopPrank();
    }
}

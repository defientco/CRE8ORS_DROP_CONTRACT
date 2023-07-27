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
import {MinterUtilities} from "../../src/utils/MinterUtilities.sol";
import {IMinterUtilities} from "../../src/interfaces/IMinterUtilities.sol";

contract FriendsAndFamilyMinterTest is DSTest, Cre8orTestBase {
    FriendsAndFamilyMinter public minter;
    MinterUtilities public minterUtility;
    Vm public constant vm = Vm(HEVM_ADDRESS);
    Lockup lockup = new Lockup();

    function setUp() public {
        Cre8orTestBase.cre8orSetup();
        minterUtility = new MinterUtilities(address(cre8orsNFTBase));
        minter = new FriendsAndFamilyMinter(
            address(cre8orsNFTBase),
            address(minterUtility)
        );
    }

    function testLockup() public {
        assertEq(address(cre8orsNFTBase.lockup()), address(0));
    }

    function testSuccesfulMintWithoutLockup(address _friendOrFamily) public {
        vm.assume(_friendOrFamily != address(0));

        // Setup Minter
        _setupMinter();

        // Apply Discount
        _addDiscount(_friendOrFamily);

        // Mint
        uint256 tokenId = minter.mint(_friendOrFamily);

        // Asserts
        assertTrue(!minter.hasDiscount(_friendOrFamily));
        assertEq(tokenId, 1);
        assertEq(cre8orsNFTBase.ownerOf(tokenId), _friendOrFamily);
        assertEq(
            cre8orsNFTBase.mintedPerAddress(_friendOrFamily).totalMints,
            1
        );
    }

    function testSuccesfulMintWithLockup(address _friendOrFamily) public {
        // Setup Minter
        _setupMinter();

        // Setup Lockup
        vm.prank(DEFAULT_OWNER_ADDRESS);
        cre8orsNFTBase.setLockup(lockup);

        // Apply Discount
        _addDiscount(_friendOrFamily);

        // Mint
        uint256 tokenId = minter.mint(_friendOrFamily);

        // Asserts
        assertTrue(!minter.hasDiscount(_friendOrFamily));
        assertEq(tokenId, 1);
        assertEq(cre8orsNFTBase.ownerOf(tokenId), _friendOrFamily);
        assertEq(
            cre8orsNFTBase.mintedPerAddress(_friendOrFamily).totalMints,
            1
        );
    }

    function testRevertNoDiscount(address _buyer) public {
        // Setup Minter
        _setupMinter();

        assertTrue(!minter.hasDiscount(_buyer));
        vm.prank(_buyer);
        vm.expectRevert(FriendsAndFamilyMinter.MissingDiscount.selector);
        minter.mint(_buyer);
    }

    function _setupMinter() internal {
        bytes32 role = cre8orsNFTBase.DEFAULT_ADMIN_ROLE();
        vm.prank(DEFAULT_OWNER_ADDRESS);
        cre8orsNFTBase.grantRole(role, address(minter));
        assertTrue(
            cre8orsNFTBase.hasRole(
                cre8orsNFTBase.DEFAULT_ADMIN_ROLE(),
                address(minter)
            )
        );
    }

    function _addDiscount(address _buyer) internal {
        assertTrue(!minter.hasDiscount(_buyer));
        vm.prank(DEFAULT_OWNER_ADDRESS);
        minter.addDiscount(_buyer);
        assertTrue(minter.hasDiscount(_buyer));
    }
}

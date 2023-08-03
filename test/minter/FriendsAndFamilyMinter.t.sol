// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;
// Forge Imports
import {Test} from "forge-std/Test.sol";
// interface imports
import {ICre8ors} from "../../src/interfaces/ICre8ors.sol";
import {IERC721Drop} from "../../src/interfaces/IERC721Drop.sol";
import {IFriendsAndFamilyMinter} from "../../src/interfaces/IFriendsAndFamilyMinter.sol";
import {ILockup} from "../../src/interfaces/ILockup.sol";
import {IMinterUtilities} from "../../src/interfaces/IMinterUtilities.sol";
// contract imports
import {Cre8ors} from "../../src/Cre8ors.sol";
import {Cre8orTestBase} from "../utils/Cre8orTestBase.sol";
import {DummyMetadataRenderer} from "../utils/DummyMetadataRenderer.sol";
import {FriendsAndFamilyMinter} from "../../src/minter/FriendsAndFamilyMinter.sol";
import {Lockup} from "../../src/utils/Lockup.sol";
import {MinterUtilities} from "../../src/utils/MinterUtilities.sol";
import {Cre8ing} from "../../src/Cre8ing.sol";

contract FriendsAndFamilyMinterTest is Test, Cre8orTestBase {
    FriendsAndFamilyMinter public minter;
    MinterUtilities public minterUtility;
    Cre8ing public cre8ingBase;
    address public familyMinter = address(0x1234567);
    Lockup lockup = new Lockup();

    function setUp() public {
        Cre8orTestBase.cre8orSetup();
        minterUtility = new MinterUtilities(
            address(cre8orsNFTBase),
            50000000000000000,
            100000000000000000,
            150000000000000000
        );
        minter = new FriendsAndFamilyMinter(
            address(cre8orsNFTBase),
            address(minterUtility)
        );
        cre8ingBase = new Cre8ing();
        vm.prank(DEFAULT_OWNER_ADDRESS);
        cre8orsNFTBase.setCre8ing(cre8ingBase);
    }

    function testLockup() public {
        assertEq(
            address(cre8ingBase.lockup(address(cre8orsNFTBase))),
            address(0)
        );
    }

    function testSuccessfulMintWithoutLockup(address _friendOrFamily) public {
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

    function testSuccessfulMintWithLockup(address _friendOrFamily) public {
        vm.assume(_friendOrFamily != address(0));

        // Setup Minter
        _setupMinter();

        // Setup Lockup
        vm.prank(DEFAULT_OWNER_ADDRESS);
        cre8ingBase.setLockup(address(cre8orsNFTBase), lockup);

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

    function testSuccessfulMintWithLockupAndStaking(
        address _friendOrFamily
    ) public {
        testSuccessfulMintWithLockup(_friendOrFamily);
        verifyStaked(1, true);
    }

    function testRevertNoDiscount(address _buyer) public {
        // Setup Minter
        _setupMinter();

        assertTrue(!minter.hasDiscount(_buyer));
        vm.prank(_buyer);
        vm.expectRevert(IFriendsAndFamilyMinter.MissingDiscount.selector);
        minter.mint(_buyer);
    }

    function _setupMinter() internal {
        bytes32 role = cre8orsNFTBase.MINTER_ROLE();
        vm.prank(DEFAULT_OWNER_ADDRESS);
        cre8orsNFTBase.grantRole(role, address(minter));
        vm.prank(DEFAULT_OWNER_ADDRESS);
        cre8ingBase.setCre8ingOpen(address(cre8orsNFTBase), true);
        assertTrue(
            cre8orsNFTBase.hasRole(
                cre8orsNFTBase.MINTER_ROLE(),
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

    function verifyStaked(uint256 _quantity, bool _expectedStaked) internal {
        for (uint256 i = 0; i < _quantity; i++) {
            // Token is Staked
            (bool cre8ing, , ) = cre8ingBase.cre8ingPeriod(
                address(cre8orsNFTBase),
                i + 1
            );
            assertEq(cre8ing, _expectedStaked);
        }
    }
}

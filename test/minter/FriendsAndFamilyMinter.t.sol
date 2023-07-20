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
import {DummyMetadataRenderer} from "../utils/DummyMetadataRenderer.sol";

contract FriendsAndFamilyMinterTest is DSTest {
    DummyMetadataRenderer public dummyRenderer = new DummyMetadataRenderer();
    address public constant DEFAULT_OWNER_ADDRESS = address(0x23499);
    address public constant DEFAULT_BUYER_ADDRESS = address(0x111);
    address payable public constant DEFAULT_FUNDS_RECIPIENT_ADDRESS =
        payable(address(0x21303));
    uint64 DEFAULT_EDITION_SIZE = 10_000;
    uint16 DEFAULT_ROYALTY_BPS = 888;
    Cre8ors public cre8orsNFTBase;
    FriendsAndFamilyMinter public minter;
    Vm public constant vm = Vm(HEVM_ADDRESS);
    Lockup lockup = new Lockup();

    function setUp() public {
        cre8orsNFTBase = new Cre8ors({
            _contractName: "CRE8ORS",
            _contractSymbol: "CRE8",
            _initialOwner: DEFAULT_OWNER_ADDRESS,
            _fundsRecipient: payable(DEFAULT_FUNDS_RECIPIENT_ADDRESS),
            _editionSize: DEFAULT_EDITION_SIZE,
            _royaltyBPS: DEFAULT_ROYALTY_BPS,
            _metadataRenderer: dummyRenderer,
            _salesConfig: IERC721Drop.SalesConfiguration({
                publicSaleStart: 0,
                erc20PaymentToken: address(0),
                publicSaleEnd: type(uint64).max,
                presaleStart: 0,
                presaleEnd: 0,
                publicSalePrice: 0,
                maxSalePurchasePerAddress: 0,
                presaleMerkleRoot: bytes32(0)
            })
        });

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
        uint256 tokenId = minter.mintPfp(DEFAULT_BUYER_ADDRESS);
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

        uint256 tokenId = minter.mintPfp(DEFAULT_BUYER_ADDRESS);
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
        vm.expectRevert("You do not have a discount");
        minter.mintPfp(DEFAULT_BUYER_ADDRESS);
        vm.stopPrank();
    }
}

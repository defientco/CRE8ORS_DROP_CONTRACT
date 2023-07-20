// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;
import {Vm} from "forge-std/Vm.sol";
import {DSTest} from "ds-test/test.sol";
import {Lockup} from "../../src/utils/Lockup.sol";
import {ILockup} from "../../src/interfaces/ILockup.sol";
import {ICre8ors} from "../../src/interfaces/ICre8ors.sol";
import {Cre8orTestBase} from "../utils/Cre8orTestBase.sol";
import {IERC721Drop} from "../../src/interfaces/IERC721Drop.sol";
import {PassportHolderMinter} from "../../src/minter/PassportHolderMinter.sol";
import {Cre8ors} from "../../src/Cre8ors.sol";
import {DummyMetadataRenderer} from "../utils/DummyMetadataRenderer.sol";

contract PassportHolderMinterTest is DSTest {
    DummyMetadataRenderer public dummyRenderer = new DummyMetadataRenderer();
    address public constant DEFAULT_OWNER_ADDRESS = address(0x23499);
    address public constant DEFAULT_BUYER_ADDRESS = address(0x111);
    address payable public constant DEFAULT_FUNDS_RECIPIENT_ADDRESS =
        payable(address(0x21303));
    uint64 DEFAULT_EDITION_SIZE = 10_000;
    uint16 DEFAULT_ROYALTY_BPS = 888;
    Cre8ors public cre8orsNFTBase;
    Cre8ors public cre8orsPassport;
    PassportHolderMinter public minter;
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
        cre8orsPassport = new Cre8ors({
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
        minter = new PassportHolderMinter(address(cre8orsPassport));
    }

    function testLockup() public {
        assertEq(address(cre8orsNFTBase.lockup()), address(0));
    }

    function testSuccessfulMintWithLockUp() public {
        vm.startPrank(DEFAULT_OWNER_ADDRESS);
        cre8orsNFTBase.grantRole(
            cre8orsNFTBase.DEFAULT_ADMIN_ROLE(),
            address(minter)
        );
        cre8orsNFTBase.setLockup(lockup);
        vm.stopPrank();

        vm.startPrank(DEFAULT_BUYER_ADDRESS);
        cre8orsPassport.purchase(1);
        assertTrue(
            cre8orsNFTBase.hasRole(
                cre8orsNFTBase.DEFAULT_ADMIN_ROLE(),
                address(minter)
            )
        );
        uint256 pfpID = minter.mintPfp(
            1,
            address(cre8orsNFTBase),
            DEFAULT_BUYER_ADDRESS
        );
        assertEq(1, pfpID);
        assertEq(1, cre8orsNFTBase.balanceOf(DEFAULT_BUYER_ADDRESS));
        assertEq(
            0,
            cre8orsNFTBase.mintedPerAddress(address(minter)).totalMints
        );
        assertEq(
            1,
            cre8orsNFTBase.mintedPerAddress(DEFAULT_BUYER_ADDRESS).totalMints
        );
        vm.stopPrank();
    }

    function testSuccessfulMintWithOutLockUp() public {
        vm.startPrank(DEFAULT_OWNER_ADDRESS);
        cre8orsNFTBase.grantRole(
            cre8orsNFTBase.DEFAULT_ADMIN_ROLE(),
            address(minter)
        );
        vm.stopPrank();

        assertEq(address(cre8orsNFTBase.lockup()), address(0));

        vm.startPrank(DEFAULT_BUYER_ADDRESS);
        uint passportId = cre8orsPassport.purchase(1);
        assertTrue(
            cre8orsNFTBase.hasRole(
                cre8orsNFTBase.DEFAULT_ADMIN_ROLE(),
                address(minter)
            )
        );
        assertEq(1, passportId + 1);
        uint256 pfpID = minter.mintPfp(
            1,
            address(cre8orsNFTBase),
            DEFAULT_BUYER_ADDRESS
        );
        assertEq(1, pfpID);
        assertEq(1, cre8orsNFTBase.balanceOf(DEFAULT_BUYER_ADDRESS));
        vm.stopPrank();
    }

    function testTotalMintsWithTransfer() public {
        vm.startPrank(DEFAULT_BUYER_ADDRESS);
        cre8orsPassport.purchase(8);
        assertEq(
            8,
            cre8orsPassport.mintedPerAddress(DEFAULT_BUYER_ADDRESS).totalMints
        );
        vm.stopPrank();
        vm.startPrank(DEFAULT_BUYER_ADDRESS, address(0x9898));
        cre8orsPassport.safeTransferFrom(
            DEFAULT_BUYER_ADDRESS,
            address(0x9898),
            1
        );
        vm.stopPrank();
        assertEq(
            8,
            cre8orsPassport.mintedPerAddress(DEFAULT_BUYER_ADDRESS).totalMints
        );
    }

    function testRevertAlreadyClaimed() public {
        vm.startPrank(DEFAULT_OWNER_ADDRESS);
        cre8orsNFTBase.grantRole(
            cre8orsNFTBase.DEFAULT_ADMIN_ROLE(),
            address(minter)
        );
        cre8orsNFTBase.setLockup(lockup);
        vm.stopPrank();

        vm.startPrank(DEFAULT_BUYER_ADDRESS);
        cre8orsPassport.purchase(1);
        assertTrue(
            cre8orsNFTBase.hasRole(
                cre8orsNFTBase.DEFAULT_ADMIN_ROLE(),
                address(minter)
            )
        );
        minter.mintPfp(1, address(cre8orsNFTBase), DEFAULT_BUYER_ADDRESS);
        vm.expectRevert("This passport has already claimed a free mint");
        minter.mintPfp(1, address(cre8orsNFTBase), DEFAULT_BUYER_ADDRESS);
        vm.stopPrank();
    }

    function testRevertNotOwnerOfPassport() public {
        vm.startPrank(DEFAULT_OWNER_ADDRESS);
        cre8orsNFTBase.grantRole(
            cre8orsNFTBase.DEFAULT_ADMIN_ROLE(),
            address(minter)
        );
        cre8orsNFTBase.setLockup(lockup);
        vm.stopPrank();

        vm.startPrank(DEFAULT_BUYER_ADDRESS, address(0x9898));
        cre8orsPassport.purchase(1);
        vm.expectRevert("You do not own this passport");
        minter.mintPfp(1, address(cre8orsNFTBase), address(0x9898));
        vm.stopPrank();
    }
}

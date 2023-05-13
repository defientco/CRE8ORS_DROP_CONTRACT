// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import {Vm} from "forge-std/Vm.sol";
import {DSTest} from "ds-test/test.sol";
import {Cre8ors} from "../../src/Cre8ors.sol";
import {BurnCrosschainMinter} from "../../src/minter/BurnCrosschainMinter.sol";
import {DummyMetadataRenderer} from "../utils/DummyMetadataRenderer.sol";
import {IERC721Drop} from "../../src/interfaces/IERC721Drop.sol";
import {IERC721A} from "lib/ERC721A/contracts/IERC721A.sol";
import {IERC2981, IERC165} from "lib/openzeppelin-contracts/contracts/interfaces/IERC2981.sol";
import {IOwnable} from "../../src/interfaces/IOwnable.sol";

contract BurnCrosschainMinterTest is DSTest {
    Cre8ors public cre8orsNFTBase;
    BurnCrosschainMinter public minter;
    Vm public constant vm = Vm(HEVM_ADDRESS);
    DummyMetadataRenderer public dummyRenderer = new DummyMetadataRenderer();
    address public constant DEFAULT_OWNER_ADDRESS = address(0x23499);
    address payable public constant DEFAULT_FUNDS_RECIPIENT_ADDRESS =
        payable(address(0x21303));
    address public constant DEFAULT_BUYER = address(0x111);
    uint64 DEFAULT_EDITION_SIZE = type(uint64).max;

    function setUp() public {
        cre8orsNFTBase = new Cre8ors({
            _contractName: "CRE8ORS",
            _contractSymbol: "CRE8",
            _initialOwner: DEFAULT_OWNER_ADDRESS,
            _fundsRecipient: payable(DEFAULT_FUNDS_RECIPIENT_ADDRESS),
            _editionSize: 800,
            _royaltyBPS: 808,
            _metadataRenderer: dummyRenderer,
            _salesConfig: IERC721Drop.SalesConfiguration({
                publicSaleStart: 0,
                erc20PaymentToken: address(0),
                publicSaleEnd: type(uint64).max,
                presaleStart: 0,
                presaleEnd: 0,
                publicSalePrice: 0.8 ether,
                maxSalePurchasePerAddress: 0,
                presaleMerkleRoot: bytes32(0)
            })
        });

        minter = new BurnCrosschainMinter();
    }

    function test_isAdmin() public {
        assertTrue(
            minter.isAdmin(address(cre8orsNFTBase), DEFAULT_OWNER_ADDRESS)
        );
        assertTrue(
            !minter.isAdmin(
                address(cre8orsNFTBase),
                DEFAULT_FUNDS_RECIPIENT_ADDRESS
            )
        );
    }

    function test_initializeWithData_revertAccess_OnlyAdmin() public {
        bytes memory data = abi.encode(
            keccak256(abi.encodePacked(msg.sender)),
            5,
            "myPasscode"
        );
        vm.expectRevert(IERC721Drop.Access_OnlyAdmin.selector);
        minter.initializeWithData(address(cre8orsNFTBase), data);
    }

    function test_initializeWithData() public {
        vm.startPrank(DEFAULT_OWNER_ADDRESS);
        bytes memory data = abi.encode(
            keccak256(abi.encodePacked(msg.sender)),
            5,
            "myPasscode"
        );
        minter.initializeWithData(address(cre8orsNFTBase), data);
    }

    function test_purchase() public {
        vm.startPrank(DEFAULT_OWNER_ADDRESS);
        bytes memory data = abi.encode(
            keccak256(abi.encodePacked(msg.sender)),
            5,
            "myPasscode"
        );
        minter.initializeWithData(address(cre8orsNFTBase), data);
        cre8orsNFTBase.grantRole(cre8orsNFTBase.MINTER_ROLE(), address(minter));
        vm.stopPrank();
        vm.startPrank(DEFAULT_BUYER);
        minter.purchase(address(cre8orsNFTBase), 1, data);
        assertEq(cre8orsNFTBase.saleDetails().totalMinted, 1);
    }

    function test_purchase800Minter() public {
        // SETUP MINTER
        vm.startPrank(DEFAULT_OWNER_ADDRESS);
        bytes memory data = abi.encode(
            keccak256(abi.encodePacked(msg.sender)),
            5,
            "myPasscode"
        );
        minter.initializeWithData(address(cre8orsNFTBase), data);
        cre8orsNFTBase.grantRole(cre8orsNFTBase.MINTER_ROLE(), address(minter));
        vm.stopPrank();

        // PURCHASE 800
        vm.startPrank(DEFAULT_BUYER);
        assertEq(cre8orsNFTBase.saleDetails().totalMinted, 0);
        (, uint64 editionSize, , ) = cre8orsNFTBase.config();
        for (uint256 i = 0; i < editionSize; i++) {
            minter.purchase(address(cre8orsNFTBase), 1, data);
        }
        assertEq(cre8orsNFTBase.saleDetails().totalMinted, 800);

        // VERIFY SOLD OUT
        vm.expectRevert(IERC721Drop.Mint_SoldOut.selector);
        minter.purchase(address(cre8orsNFTBase), 1, data);
    }

    function test_purchase800() public {
        // SETUP MINTER
        vm.startPrank(DEFAULT_OWNER_ADDRESS);
        bytes memory data = abi.encode(
            keccak256(abi.encodePacked(msg.sender)),
            5,
            "myPasscode"
        );
        minter.initializeWithData(address(cre8orsNFTBase), data);
        cre8orsNFTBase.grantRole(cre8orsNFTBase.MINTER_ROLE(), address(minter));
        vm.stopPrank();

        // PURCHASE 800
        vm.startPrank(DEFAULT_BUYER);
        uint256 quantity = 800;
        uint256 priceToPay = cre8orsNFTBase.saleDetails().publicSalePrice *
            quantity;
        vm.deal(DEFAULT_BUYER, priceToPay);
        assertEq(cre8orsNFTBase.saleDetails().totalMinted, 0);
        (, uint64 editionSize, , ) = cre8orsNFTBase.config();
        cre8orsNFTBase.purchase{value: quantity * 0.8 ether}(quantity);
        assertEq(cre8orsNFTBase.saleDetails().totalMinted, 800);

        // VERIFY SOLD OUT
        vm.expectRevert(IERC721Drop.Mint_SoldOut.selector);
        cre8orsNFTBase.purchase(1);
    }

    // test admin mint non-admin permissions
    function test_AdminMintBatch() public {
        vm.startPrank(DEFAULT_OWNER_ADDRESS);
        cre8orsNFTBase.adminMint(DEFAULT_OWNER_ADDRESS, 100);
        assertEq(cre8orsNFTBase.saleDetails().totalMinted, 100);
        assertEq(cre8orsNFTBase.balanceOf(DEFAULT_OWNER_ADDRESS), 100);
    }

    function test_AdminMintBatchFails() public {
        vm.startPrank(address(0x10));
        bytes32 role = cre8orsNFTBase.MINTER_ROLE();
        vm.expectRevert(
            abi.encodeWithSignature(
                "AdminAccess_MissingRoleOrAdmin(bytes32)",
                role
            )
        );
        cre8orsNFTBase.adminMint(address(0x10), 100);
    }
}

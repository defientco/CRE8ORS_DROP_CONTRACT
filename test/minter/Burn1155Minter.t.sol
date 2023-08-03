// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import {Vm} from "forge-std/Vm.sol";
import {DSTest} from "ds-test/test.sol";
import {Cre8ors} from "../../src/Cre8ors.sol";
import {Cre8orRewards1155} from "../../src/Cre8orRewards1155.sol";
import {Burn1155Minter} from "../../src/minter/Burn1155Minter.sol";
import {DummyMetadataRenderer} from "../utils/DummyMetadataRenderer.sol";
import {IERC721Drop} from "../../src/interfaces/IERC721Drop.sol";
import {IERC721A} from "lib/ERC721A/contracts/IERC721A.sol";
import {IERC2981, IERC165} from "lib/openzeppelin-contracts/contracts/interfaces/IERC2981.sol";
import {IOwnable} from "../../src/interfaces/IOwnable.sol";
import {Cre8ing} from "../../src/Cre8ing.sol";
import {ICre8ors} from "../../src/interfaces/ICre8ors.sol";

contract Burn1155MinterTest is DSTest {
    Cre8ing public cre8ingBase;
    Cre8ors public cre8orsNFTBase;
    Cre8orRewards1155 public burn1155;
    Burn1155Minter public minter;
    Vm public constant vm = Vm(HEVM_ADDRESS);
    DummyMetadataRenderer public dummyRenderer = new DummyMetadataRenderer();
    address public constant DEFAULT_OWNER_ADDRESS = address(0x23499);
    address payable public constant DEFAULT_FUNDS_RECIPIENT_ADDRESS = payable(address(0x21303));
    address public constant DEFAULT_BUYER = address(0x111);
    uint64 DEFAULT_EDITION_SIZE = type(uint64).max;

    function setUp() public {
        cre8orsNFTBase = new Cre8ors({
            _contractName: "CRE8ORS",
            _contractSymbol: "CRE8",
            _initialOwner: DEFAULT_OWNER_ADDRESS,
            _fundsRecipient: payable(DEFAULT_FUNDS_RECIPIENT_ADDRESS),
            _editionSize: type(uint64).max,
            _royaltyBPS: 808,
            _metadataRenderer: dummyRenderer,
            _salesConfig: IERC721Drop.SalesConfiguration({
                publicSaleStart: 0,
                erc20PaymentToken: address(0),
                publicSaleEnd: 0,
                presaleStart: 0,
                presaleEnd: 0,
                publicSalePrice: 0,
                maxSalePurchasePerAddress: 0,
                presaleMerkleRoot: bytes32(0)
            })
        });
        vm.prank(DEFAULT_OWNER_ADDRESS);
        burn1155 = new Cre8orRewards1155("uri");
        minter = new Burn1155Minter();

        cre8ingBase = new Cre8ing();
        vm.startPrank(DEFAULT_OWNER_ADDRESS);
        cre8orsNFTBase.setCre8ing(cre8ingBase);
        vm.stopPrank();
    }

    function test_isAdmin() public {
        assertTrue(minter.isAdmin(address(cre8orsNFTBase), DEFAULT_OWNER_ADDRESS));
        assertTrue(!minter.isAdmin(address(cre8orsNFTBase), DEFAULT_FUNDS_RECIPIENT_ADDRESS));
    }

    function test_initializeWithData_revertAccess_OnlyAdmin() public {
        bytes memory data = abi.encode("Description for metadata", 5);
        vm.expectRevert(IERC721Drop.Access_OnlyAdmin.selector);
        minter.initializeWithData(address(cre8orsNFTBase), data);
        Burn1155Minter.ContractMintInfo memory info = minter.contractInfos(address(cre8orsNFTBase));
        assertEq(info.burnToken, address(0));
        assertEq(info.burnQuantity, 0);
    }

    function test_initializeWithData() public {
        vm.startPrank(DEFAULT_OWNER_ADDRESS);
        bytes memory data = abi.encode(address(0x123), 5);
        minter.initializeWithData(address(cre8orsNFTBase), data);
        Burn1155Minter.ContractMintInfo memory info = minter.contractInfos(address(cre8orsNFTBase));
        assertEq(info.burnToken, address(0x123));
        assertEq(info.burnQuantity, 5);
    }

    function test_purchase_revertAccess_MissingOwnerOrApproved() public {
        vm.startPrank(DEFAULT_OWNER_ADDRESS);
        bytes memory data = abi.encode(address(burn1155), 5);
        minter.initializeWithData(address(cre8orsNFTBase), data);
        cre8orsNFTBase.grantRole(cre8orsNFTBase.MINTER_ROLE(), address(minter));
        vm.stopPrank();
        vm.prank(DEFAULT_BUYER);
        vm.expectRevert(IERC721Drop.Access_MissingOwnerOrApproved.selector);
        minter.purchase(address(cre8orsNFTBase), 1);
        assertEq(burn1155.balanceOf(DEFAULT_BUYER, 1), 0);
        assertEq(cre8orsNFTBase.saleDetails().totalMinted, 0);
    }

    function test_purchase_revertOwnerQueryForNonexistentToken() public {
        vm.startPrank(DEFAULT_OWNER_ADDRESS);
        bytes memory data = abi.encode(address(burn1155), 5);
        minter.initializeWithData(address(cre8orsNFTBase), data);
        cre8orsNFTBase.grantRole(cre8orsNFTBase.MINTER_ROLE(), address(minter));
        vm.stopPrank();
        vm.startPrank(DEFAULT_BUYER);
        burn1155.setApprovalForAll(address(minter), true);
        vm.expectRevert();
        minter.purchase(address(cre8orsNFTBase), 1);
        assertEq(burn1155.balanceOf(DEFAULT_BUYER, 1), 0);
        assertEq(cre8orsNFTBase.saleDetails().totalMinted, 0);
    }

    function test_purchase() public {
        vm.startPrank(DEFAULT_OWNER_ADDRESS);
        bytes memory data = abi.encode(address(burn1155), 5);
        minter.initializeWithData(address(cre8orsNFTBase), data);
        cre8orsNFTBase.grantRole(cre8orsNFTBase.MINTER_ROLE(), address(minter));
        burn1155.mint(DEFAULT_BUYER, 1, 5, bytes(""));
        assertEq(burn1155.balanceOf(DEFAULT_BUYER, 1), 5);
        vm.stopPrank();
        vm.startPrank(DEFAULT_BUYER);
        burn1155.setApprovalForAll(address(minter), true);
        minter.purchase(address(cre8orsNFTBase), 1);
        assertEq(burn1155.balanceOf(DEFAULT_BUYER, 1), 0);
        assertEq(cre8orsNFTBase.saleDetails().totalMinted, 1);
    }

    function test_purchaseQuantity(uint8 quantity) public {
        if (quantity > 0 && quantity < 50) {
            vm.startPrank(DEFAULT_OWNER_ADDRESS);
            bytes memory data = abi.encode(address(burn1155), 5);
            minter.initializeWithData(address(cre8orsNFTBase), data);
            cre8orsNFTBase.grantRole(cre8orsNFTBase.MINTER_ROLE(), address(minter));
            burn1155.mint(DEFAULT_BUYER, 1, 5 * quantity, bytes(""));
            assertEq(burn1155.balanceOf(DEFAULT_BUYER, 1), 5 * quantity);
            vm.stopPrank();
            vm.startPrank(DEFAULT_BUYER);
            burn1155.setApprovalForAll(address(minter), true);
            minter.purchase(address(cre8orsNFTBase), quantity);
            assertEq(burn1155.balanceOf(DEFAULT_BUYER, 1), 0);
            assertEq(cre8orsNFTBase.saleDetails().totalMinted, quantity);
        }
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
        vm.expectRevert(abi.encodeWithSignature("AdminAccess_MissingRoleOrAdmin(bytes32)", role));
        cre8orsNFTBase.adminMint(address(0x10), 100);
    }
}

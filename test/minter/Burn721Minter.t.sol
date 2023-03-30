// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import {Vm} from "forge-std/Vm.sol";
import {DSTest} from "ds-test/test.sol";
import {Cre8ors} from "../../src/Cre8ors.sol";
import {Burn721Minter} from "../../src/minter/Burn721Minter.sol";
import {DummyMetadataRenderer} from "../utils/DummyMetadataRenderer.sol";
import {IERC721Drop} from "../../src/interfaces/IERC721Drop.sol";
import {IERC721A} from "lib/ERC721A/contracts/IERC721A.sol";
import {IERC2981, IERC165} from "lib/openzeppelin-contracts/contracts/interfaces/IERC2981.sol";
import {IOwnable} from "../../src/interfaces/IOwnable.sol";

contract Burn721MinterTest is DSTest {
    Cre8ors public cre8orsNFTBase;
    Cre8ors public burn721;
    Burn721Minter public minter;
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
        burn721 = new Cre8ors({
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
        minter = new Burn721Minter();
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
        bytes memory data = abi.encode("Description for metadata", 5);
        vm.expectRevert(IERC721Drop.Access_OnlyAdmin.selector);
        minter.initializeWithData(address(cre8orsNFTBase), data);
        Burn721Minter.ContractMintInfo memory info = minter.contractInfos(
            address(cre8orsNFTBase)
        );
        assertEq(info.burnToken, address(0));
        assertEq(info.burnQuantity, 0);
    }

    function test_initializeWithData() public {
        vm.startPrank(DEFAULT_OWNER_ADDRESS);
        bytes memory data = abi.encode(address(0x123), 5);
        minter.initializeWithData(address(cre8orsNFTBase), data);
        Burn721Minter.ContractMintInfo memory info = minter.contractInfos(
            address(cre8orsNFTBase)
        );
        assertEq(info.burnToken, address(0x123));
        assertEq(info.burnQuantity, 5);
    }

    function test_purchase_revertAccess_MissingOwnerOrApproved() public {
        vm.startPrank(DEFAULT_OWNER_ADDRESS);
        bytes memory data = abi.encode(address(burn721), 5);
        minter.initializeWithData(address(cre8orsNFTBase), data);
        cre8orsNFTBase.grantRole(cre8orsNFTBase.MINTER_ROLE(), address(minter));
        vm.stopPrank();
        vm.prank(DEFAULT_BUYER);
        uint256[] memory tokensToBurn = new uint256[](5);
        tokensToBurn[0] = 1;
        tokensToBurn[1] = 2;
        tokensToBurn[2] = 3;
        tokensToBurn[3] = 4;
        tokensToBurn[4] = 5;
        vm.expectRevert(IERC721Drop.Access_MissingOwnerOrApproved.selector);
        minter.purchase(address(cre8orsNFTBase), 1, tokensToBurn);
        assertEq(burn721.balanceOf(DEFAULT_BUYER), 0);
        assertEq(cre8orsNFTBase.saleDetails().totalMinted, 0);
    }

    function test_purchase_revertOwnerQueryForNonexistentToken() public {
        vm.startPrank(DEFAULT_OWNER_ADDRESS);
        bytes memory data = abi.encode(address(burn721), 5);
        minter.initializeWithData(address(cre8orsNFTBase), data);
        cre8orsNFTBase.grantRole(cre8orsNFTBase.MINTER_ROLE(), address(minter));
        vm.stopPrank();
        vm.startPrank(DEFAULT_BUYER);
        uint256[] memory tokensToBurn = new uint256[](5);
        tokensToBurn[0] = 1;
        tokensToBurn[1] = 2;
        tokensToBurn[2] = 3;
        tokensToBurn[3] = 4;
        tokensToBurn[4] = 5;
        burn721.setApprovalForAll(address(minter), true);
        vm.expectRevert(IERC721A.OwnerQueryForNonexistentToken.selector);
        minter.purchase(address(cre8orsNFTBase), 1, tokensToBurn);
        assertEq(burn721.balanceOf(DEFAULT_BUYER), 0);
        assertEq(cre8orsNFTBase.saleDetails().totalMinted, 0);
    }

    function test_purchase() public {
        vm.startPrank(DEFAULT_OWNER_ADDRESS);
        bytes memory data = abi.encode(address(burn721), 5);
        minter.initializeWithData(address(cre8orsNFTBase), data);
        cre8orsNFTBase.grantRole(cre8orsNFTBase.MINTER_ROLE(), address(minter));
        burn721.adminMint(DEFAULT_BUYER, 5);
        assertEq(burn721.balanceOf(DEFAULT_BUYER), 5);
        vm.stopPrank();
        vm.startPrank(DEFAULT_BUYER);
        uint256[] memory tokensToBurn = new uint256[](5);
        tokensToBurn[0] = 1;
        tokensToBurn[1] = 2;
        tokensToBurn[2] = 3;
        tokensToBurn[3] = 4;
        tokensToBurn[4] = 5;
        burn721.setApprovalForAll(address(minter), true);
        minter.purchase(address(cre8orsNFTBase), 1, tokensToBurn);
        assertEq(burn721.balanceOf(DEFAULT_BUYER), 0);
        assertEq(cre8orsNFTBase.saleDetails().totalMinted, 1);
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

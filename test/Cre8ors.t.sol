// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import {Vm} from "forge-std/Vm.sol";
import {DSTest} from "ds-test/test.sol";
import {Cre8ors} from "../src/Cre8ors.sol";
import {DummyMetadataRenderer} from "./utils/DummyMetadataRenderer.sol";
import {IERC721Drop} from "../src/interfaces/IERC721Drop.sol";
import {IERC721A} from "lib/ERC721A/contracts/IERC721A.sol";
import {IERC2981, IERC165} from "lib/openzeppelin-contracts/contracts/interfaces/IERC2981.sol";
import {IOwnable} from "../src/interfaces/IOwnable.sol";
import {Cre8ing} from "../src/Cre8ing.sol";

contract Cre8orTest is DSTest {
    Cre8ors public cre8orsNFTBase;
    Vm public constant vm = Vm(HEVM_ADDRESS);
    DummyMetadataRenderer public dummyRenderer = new DummyMetadataRenderer();
    address public constant DEFAULT_OWNER_ADDRESS = address(0x23499);
    address payable public constant DEFAULT_FUNDS_RECIPIENT_ADDRESS =
        payable(address(0x21303));
    uint64 DEFAULT_EDITION_SIZE = 10_000;



    modifier setupCre8orsNFTBase(uint64 editionSize) {
        cre8orsNFTBase = new Cre8ors({
            _contractName: "CRE8ORS",
            _contractSymbol: "CRE8",
            _initialOwner: DEFAULT_OWNER_ADDRESS,
            _fundsRecipient: payable(DEFAULT_FUNDS_RECIPIENT_ADDRESS),
            _editionSize: editionSize,
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

        _;
    }

    function test_Erc721() public setupCre8orsNFTBase(DEFAULT_EDITION_SIZE) {
        assertEq("CRE8ORS", cre8orsNFTBase.name());
        assertEq("CRE8", cre8orsNFTBase.symbol());
        assertEq(DEFAULT_EDITION_SIZE, cre8orsNFTBase.saleDetails().maxSupply);
    }

    function test_Purchase(
        uint64 amount
    ) public setupCre8orsNFTBase(DEFAULT_EDITION_SIZE) {
        vm.prank(DEFAULT_OWNER_ADDRESS);
        cre8orsNFTBase.setSaleConfiguration({
            erc20PaymentToken: address(0),
            publicSaleStart: 0,
            publicSaleEnd: type(uint64).max,
            presaleStart: 0,
            presaleEnd: 0,
            publicSalePrice: amount,
            maxSalePurchasePerAddress: 2,
            presaleMerkleRoot: bytes32(0)
        });

        vm.deal(address(456), uint256(amount) * 2);
        vm.prank(address(456));
        cre8orsNFTBase.purchase{value: amount}(1);

        assertEq(cre8orsNFTBase.saleDetails().maxSupply, DEFAULT_EDITION_SIZE);
        assertEq(cre8orsNFTBase.saleDetails().totalMinted, 1);
        require(
            cre8orsNFTBase.ownerOf(1) == address(456),
            "owner is wrong for new minted token"
        );
        assertEq(address(cre8orsNFTBase).balance, amount);
    }

    function test_PurchaseTime() public setupCre8orsNFTBase(10) {
        vm.prank(DEFAULT_OWNER_ADDRESS);
        cre8orsNFTBase.setSaleConfiguration({
            erc20PaymentToken: address(0),
            publicSaleStart: 0,
            publicSaleEnd: 0,
            presaleStart: 0,
            presaleEnd: 0,
            publicSalePrice: 0.1 ether,
            maxSalePurchasePerAddress: 2,
            presaleMerkleRoot: bytes32(0)
        });

        assertTrue(!cre8orsNFTBase.saleDetails().publicSaleActive);

        vm.deal(address(456), 1 ether);
        vm.prank(address(456));
        vm.expectRevert(IERC721Drop.Sale_Inactive.selector);
        cre8orsNFTBase.purchase{value: 0.1 ether}(1);

        assertEq(cre8orsNFTBase.saleDetails().maxSupply, 10);
        assertEq(cre8orsNFTBase.saleDetails().totalMinted, 0);

        vm.prank(DEFAULT_OWNER_ADDRESS);
        cre8orsNFTBase.setSaleConfiguration({
            erc20PaymentToken: address(0),
            publicSaleStart: 9 * 3600,
            publicSaleEnd: 11 * 3600,
            presaleStart: 0,
            presaleEnd: 0,
            maxSalePurchasePerAddress: 20,
            publicSalePrice: 0.1 ether,
            presaleMerkleRoot: bytes32(0)
        });

        assertTrue(!cre8orsNFTBase.saleDetails().publicSaleActive);
        // jan 1st 1980
        vm.warp(10 * 3600);
        assertTrue(cre8orsNFTBase.saleDetails().publicSaleActive);
        assertTrue(!cre8orsNFTBase.saleDetails().presaleActive);

        vm.prank(address(456));
        cre8orsNFTBase.purchase{value: 0.1 ether}(1);

        assertEq(cre8orsNFTBase.saleDetails().totalMinted, 1);
        assertEq(cre8orsNFTBase.ownerOf(1), address(456));
    }

    function test_Mint() public setupCre8orsNFTBase(10) {
        vm.prank(DEFAULT_OWNER_ADDRESS);
        cre8orsNFTBase.adminMint(DEFAULT_OWNER_ADDRESS, 1);
        assertEq(cre8orsNFTBase.saleDetails().maxSupply, 10);
        assertEq(cre8orsNFTBase.saleDetails().totalMinted, 1);
        require(
            cre8orsNFTBase.ownerOf(1) == DEFAULT_OWNER_ADDRESS,
            "Owner is wrong for new minted token"
        );
    }

    function test_MintWrongValue() public setupCre8orsNFTBase(10) {
        vm.deal(address(456), 1 ether);
        vm.prank(address(456));
        vm.expectRevert(IERC721Drop.Sale_Inactive.selector);
        cre8orsNFTBase.purchase{value: 0.12 ether}(1);
        vm.prank(DEFAULT_OWNER_ADDRESS);
        cre8orsNFTBase.setSaleConfiguration({
            erc20PaymentToken: address(0),
            publicSaleStart: 0,
            publicSaleEnd: type(uint64).max,
            presaleStart: 0,
            presaleEnd: 0,
            publicSalePrice: 0.15 ether,
            maxSalePurchasePerAddress: 2,
            presaleMerkleRoot: bytes32(0)
        });
        vm.prank(address(456));
        vm.expectRevert(
            abi.encodeWithSelector(
                IERC721Drop.Purchase_WrongPrice.selector,
                0.15 ether
            )
        );
        cre8orsNFTBase.purchase{value: 0.12 ether}(1);
    }

    function test_Withdraw(uint128 amount) public setupCre8orsNFTBase(10) {
        vm.assume(amount > 0.01 ether);
        vm.deal(address(cre8orsNFTBase), amount);
        vm.prank(DEFAULT_OWNER_ADDRESS);
        cre8orsNFTBase.withdraw();

        assertTrue(
            DEFAULT_FUNDS_RECIPIENT_ADDRESS.balance >
                ((uint256(amount) * 1_000 * 95) / 100000) - 2 ||
                DEFAULT_FUNDS_RECIPIENT_ADDRESS.balance <
                ((uint256(amount) * 1_000 * 95) / 100000) + 2
        );
    }

    function test_MintLimit(uint8 limit) public setupCre8orsNFTBase(5000) {
        // set limit to speed up tests
        vm.assume(limit > 0 && limit < 50);
        vm.prank(DEFAULT_OWNER_ADDRESS);
        cre8orsNFTBase.setSaleConfiguration({
            erc20PaymentToken: address(0),
            publicSaleStart: 0,
            publicSaleEnd: type(uint64).max,
            presaleStart: 0,
            presaleEnd: 0,
            publicSalePrice: 0.1 ether,
            maxSalePurchasePerAddress: limit,
            presaleMerkleRoot: bytes32(0)
        });
        vm.deal(address(456), 1_000_000 ether);
        vm.prank(address(456));
        cre8orsNFTBase.purchase{value: 0.1 ether * uint256(limit)}(limit);

        assertEq(cre8orsNFTBase.saleDetails().totalMinted, limit);

        vm.deal(address(444), 1_000_000 ether);
        vm.prank(address(444));
        vm.expectRevert(IERC721Drop.Purchase_TooManyForAddress.selector);
        cre8orsNFTBase.purchase{value: 0.1 ether * (uint256(limit) + 1)}(
            uint256(limit) + 1
        );

        assertEq(cre8orsNFTBase.saleDetails().totalMinted, limit);
    }

    function test_GlobalLimit(
        uint16 limit
    ) public setupCre8orsNFTBase(uint64(limit)) {
        vm.assume(limit > 0);
        vm.startPrank(DEFAULT_OWNER_ADDRESS);
        cre8orsNFTBase.adminMint(DEFAULT_OWNER_ADDRESS, limit);
        vm.expectRevert(IERC721Drop.Mint_SoldOut.selector);
        cre8orsNFTBase.adminMint(DEFAULT_OWNER_ADDRESS, 1);
    }

    function test_WithdrawNotAllowed() public setupCre8orsNFTBase(10) {
        vm.expectRevert(IERC721Drop.Access_WithdrawNotAllowed.selector);
        cre8orsNFTBase.withdraw();
    }

    function test_AdminMint() public setupCre8orsNFTBase(10) {
        address minter = address(0x32402);
        vm.startPrank(DEFAULT_OWNER_ADDRESS);
        cre8orsNFTBase.adminMint(DEFAULT_OWNER_ADDRESS, 1);
        require(
            cre8orsNFTBase.balanceOf(DEFAULT_OWNER_ADDRESS) == 1,
            "Wrong balance"
        );
        cre8orsNFTBase.grantRole(cre8orsNFTBase.MINTER_ROLE(), minter);
        vm.stopPrank();
        vm.prank(minter);
        cre8orsNFTBase.adminMint(minter, 1);
        require(cre8orsNFTBase.balanceOf(minter) == 1, "Wrong balance");
        assertEq(cre8orsNFTBase.saleDetails().totalMinted, 2);
    }

    function test_EditionSizeZero() public setupCre8orsNFTBase(0) {
        address minter = address(0x32402);
        vm.startPrank(DEFAULT_OWNER_ADDRESS);
        vm.expectRevert(IERC721Drop.Mint_SoldOut.selector);
        cre8orsNFTBase.adminMint(DEFAULT_OWNER_ADDRESS, 1);
        cre8orsNFTBase.grantRole(cre8orsNFTBase.MINTER_ROLE(), minter);
        vm.stopPrank();
        vm.prank(minter);
        vm.expectRevert(IERC721Drop.Mint_SoldOut.selector);
        cre8orsNFTBase.adminMint(minter, 1);

        vm.prank(DEFAULT_OWNER_ADDRESS);
        cre8orsNFTBase.setSaleConfiguration({
            erc20PaymentToken: address(0),
            publicSaleStart: 0,
            publicSaleEnd: type(uint64).max,
            presaleStart: 0,
            presaleEnd: 0,
            publicSalePrice: 1,
            maxSalePurchasePerAddress: 2,
            presaleMerkleRoot: bytes32(0)
        });

        vm.deal(address(456), uint256(1) * 2);
        vm.prank(address(456));
        vm.expectRevert(IERC721Drop.Mint_SoldOut.selector);
        cre8orsNFTBase.purchase{value: 1}(1);
    }

    // test Admin airdrop
    function test_AdminMintAirdrop() public setupCre8orsNFTBase(1000) {
        vm.startPrank(DEFAULT_OWNER_ADDRESS);
        address[] memory toMint = new address[](4);
        toMint[0] = address(0x10);
        toMint[1] = address(0x11);
        toMint[2] = address(0x12);
        toMint[3] = address(0x13);
        cre8orsNFTBase.adminMintAirdrop(toMint);
        assertEq(cre8orsNFTBase.saleDetails().totalMinted, 4);
        assertEq(cre8orsNFTBase.balanceOf(address(0x10)), 1);
        assertEq(cre8orsNFTBase.balanceOf(address(0x11)), 1);
        assertEq(cre8orsNFTBase.balanceOf(address(0x12)), 1);
        assertEq(cre8orsNFTBase.balanceOf(address(0x13)), 1);
    }

    function test_AdminMintAirdropFails() public setupCre8orsNFTBase(1000) {
        vm.startPrank(address(0x10));
        address[] memory toMint = new address[](4);
        toMint[0] = address(0x10);
        toMint[1] = address(0x11);
        toMint[2] = address(0x12);
        toMint[3] = address(0x13);
        bytes32 minterRole = cre8orsNFTBase.MINTER_ROLE();
        vm.expectRevert(
            abi.encodeWithSignature(
                "AdminAccess_MissingRoleOrAdmin(bytes32)",
                minterRole
            )
        );
        cre8orsNFTBase.adminMintAirdrop(toMint);
    }

    // test admin mint non-admin permissions
    function test_AdminMintBatch() public setupCre8orsNFTBase(1000) {
        vm.startPrank(DEFAULT_OWNER_ADDRESS);
        cre8orsNFTBase.adminMint(DEFAULT_OWNER_ADDRESS, 100);
        assertEq(cre8orsNFTBase.saleDetails().totalMinted, 100);
        assertEq(cre8orsNFTBase.balanceOf(DEFAULT_OWNER_ADDRESS), 100);
    }

    function test_AdminMintBatchFails() public setupCre8orsNFTBase(1000) {
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

    function test_Burn() public setupCre8orsNFTBase(10) {
        address minter = address(0x32402);
        vm.startPrank(DEFAULT_OWNER_ADDRESS);
        cre8orsNFTBase.grantRole(cre8orsNFTBase.MINTER_ROLE(), minter);
        vm.stopPrank();
        vm.startPrank(minter);
        address[] memory airdrop = new address[](1);
        airdrop[0] = minter;
        cre8orsNFTBase.adminMintAirdrop(airdrop);
        cre8orsNFTBase.burn(1);
        vm.stopPrank();
    }

    function test_BurnNonOwner() public setupCre8orsNFTBase(10) {
        address minter = address(0x32402);
        vm.startPrank(DEFAULT_OWNER_ADDRESS);
        cre8orsNFTBase.grantRole(cre8orsNFTBase.MINTER_ROLE(), minter);
        vm.stopPrank();
        vm.startPrank(minter);
        address[] memory airdrop = new address[](1);
        airdrop[0] = minter;
        cre8orsNFTBase.adminMintAirdrop(airdrop);
        vm.stopPrank();

        vm.prank(address(1));
        vm.expectRevert(IERC721A.TransferCallerNotOwnerNorApproved.selector);
        cre8orsNFTBase.burn(1);
    }

    function test_TokenURI() public setupCre8orsNFTBase(DEFAULT_EDITION_SIZE) {
        vm.prank(DEFAULT_OWNER_ADDRESS);
        cre8orsNFTBase.setSaleConfiguration({
            erc20PaymentToken: address(0),
            publicSaleStart: 0,
            publicSaleEnd: type(uint64).max,
            presaleStart: 0,
            presaleEnd: 0,
            publicSalePrice: 1,
            maxSalePurchasePerAddress: 2,
            presaleMerkleRoot: bytes32(0)
        });

        vm.deal(address(456), uint256(1) * 2);
        vm.prank(address(456));
        cre8orsNFTBase.purchase{value: 1}(1);

        assertEq(cre8orsNFTBase.tokenURI(1), "DUMMY");
    }

   
}

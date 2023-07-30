// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "forge-std/Test.sol";
import {Cre8ing} from "../src/Cre8ing.sol";
import {Cre8ors} from "../src/Cre8ors.sol";
import {DummyMetadataRenderer} from "./utils/DummyMetadataRenderer.sol";
import {IERC721Drop} from "../src/interfaces/IERC721Drop.sol";
import {Strings} from "../lib/openzeppelin-contracts/contracts/utils/Strings.sol";

contract Cre8ingTest is Test {
    Cre8ing public cre8ingBase;
    Cre8ors public cre8orsNFTBase;
    DummyMetadataRenderer public dummyRenderer = new DummyMetadataRenderer();

    address public constant DEFAULT_OWNER_ADDRESS = address(0x23499);
    address public constant DEFAULT_CRE8OR_ADDRESS = address(456);
    address public constant DEFAULT_TRANSFER_ADDRESS = address(0x2);
    uint64 DEFAULT_EDITION_SIZE = 10_000;


    function setUp() public {
        cre8ingBase = new Cre8ing(DEFAULT_OWNER_ADDRESS);
    }

    modifier setupCre8orsNFTBase() {
        cre8orsNFTBase = new Cre8ors({
            _contractName: "CRE8ORS",
            _contractSymbol: "CRE8",
            _initialOwner: DEFAULT_OWNER_ADDRESS,
            _fundsRecipient: payable(DEFAULT_OWNER_ADDRESS),
            _editionSize: 10_000,
            _royaltyBPS: 808,
            _metadataRenderer: dummyRenderer,
            _salesConfig: IERC721Drop.SalesConfiguration({
                erc20PaymentToken: address(0),
                publicSaleStart: 0,
                publicSaleEnd: uint64(block.timestamp + 1000),
                presaleStart: 0,
                presaleEnd: 0,
                publicSalePrice: 0,
                maxSalePurchasePerAddress: 0,
                presaleMerkleRoot: bytes32(0)
            })
        });

        vm.prank(DEFAULT_OWNER_ADDRESS);
        cre8ingBase.setCre8or(cre8orsNFTBase);

        _;
    }

    function test_cre8ingPeriod(uint256 _tokenId) public {
        (bool cre8ing, uint256 current, uint256 total) = cre8ingBase
            .cre8ingPeriod(_tokenId);
        assertEq(cre8ing, false);
        assertEq(current, 0);
        assertEq(total, 0);
    }

    function test_cre8ingOpen() public {
        assertEq(cre8ingBase.cre8ingOpen(), false);
    }

    function test_setCre8ingOpenReverts_AdminAccess_MissingRoleOrAdmin(
        bool _isOpen
    ) public {
        assertEq(cre8ingBase.cre8ingOpen(), false);
        bytes32 role = cre8ingBase.SALES_MANAGER_ROLE();
        vm.expectRevert(
            abi.encodeWithSignature(
                "AdminAccess_MissingRoleOrAdmin(bytes32)",
                role
            )
        );
        cre8ingBase.setCre8ingOpen(_isOpen);
        assertEq(cre8ingBase.cre8ingOpen(), false);
    }

    function test_setCre8ingOpen(bool _isOpen) public {
        assertEq(cre8ingBase.cre8ingOpen(), false);
        vm.prank(DEFAULT_OWNER_ADDRESS);
        cre8ingBase.setCre8ingOpen(_isOpen);
        assertEq(cre8ingBase.cre8ingOpen(), _isOpen);
    }

    function test_toggleCre8ingRevert_OwnerQueryForNonexistentToken(
        uint256 _tokenId
    ) public setupCre8orsNFTBase {
        (bool cre8ing, uint256 current, uint256 total) = cre8ingBase
            .cre8ingPeriod(_tokenId);
        assertEq(cre8ing, false);
        assertEq(current, 0);
        assertEq(total, 0);
        uint256[] memory tokenIds = new uint256[](1);
        tokenIds[0] = _tokenId;
        vm.expectRevert(
            abi.encodeWithSignature("OwnerQueryForNonexistentToken()")
        );
        cre8ingBase.toggleCre8ingTokens(tokenIds);
    }

    function test_toggleCre8ingRevert_Cre8ing_Cre8ingClosed()
        public
        setupCre8orsNFTBase
    {
        uint256 _tokenId = 1;
        (bool cre8ing, uint256 current, uint256 total) = cre8ingBase
            .cre8ingPeriod(_tokenId);
        assertEq(cre8ing, false);
        assertEq(current, 0);
        assertEq(total, 0);
        cre8orsNFTBase.purchase(1);
        uint256[] memory tokenIds = new uint256[](1);
        tokenIds[0] = _tokenId;
        vm.expectRevert(abi.encodeWithSignature("Cre8ing_Cre8ingClosed()"));
        cre8ingBase.toggleCre8ingTokens(tokenIds);
    }

    function test_toggleCre8ing() public setupCre8orsNFTBase {
        uint256 _tokenId = 1;
        (bool cre8ing, uint256 current, uint256 total) = cre8ingBase
            .cre8ingPeriod(_tokenId);
        assertEq(cre8ing, false);
        assertEq(current, 0);
        assertEq(total, 0);
        cre8orsNFTBase.purchase(1);

        vm.prank(DEFAULT_OWNER_ADDRESS);
        cre8ingBase.setCre8ingOpen(true);

        uint256[] memory tokenIds = new uint256[](1);
        tokenIds[0] = _tokenId;
        cre8ingBase.toggleCre8ingTokens(tokenIds);
        (cre8ing, current, total) = cre8ingBase.cre8ingPeriod(_tokenId);
        assertEq(cre8ing, true);
        assertEq(current, 0);
        assertEq(total, 0);
    }

    function test_blockCre8ingTransfer() public setupCre8orsNFTBase {
        uint256 _tokenId = 1;
        vm.prank(DEFAULT_CRE8OR_ADDRESS);
        cre8orsNFTBase.purchase(1);

        vm.prank(DEFAULT_OWNER_ADDRESS);
        cre8ingBase.setCre8ingOpen(true);

        uint256[] memory tokenIds = new uint256[](1);
        tokenIds[0] = _tokenId;
        vm.startPrank(DEFAULT_CRE8OR_ADDRESS);
        cre8ingBase.toggleCre8ingTokens(tokenIds);
        vm.expectRevert(abi.encodeWithSignature("Cre8ing_Cre8ing()"));
        cre8orsNFTBase.safeTransferFrom(
            DEFAULT_CRE8OR_ADDRESS,
            DEFAULT_OWNER_ADDRESS,
            _tokenId
        );
    }

    function test_safeTransferWhileCre8ing() public setupCre8orsNFTBase {
        uint256 _tokenId = 1;
        vm.prank(DEFAULT_CRE8OR_ADDRESS);
        cre8orsNFTBase.purchase(1);

        vm.prank(DEFAULT_OWNER_ADDRESS);
        cre8ingBase.setCre8ingOpen(true);

        uint256[] memory tokenIds = new uint256[](1);
        tokenIds[0] = _tokenId;
        vm.startPrank(DEFAULT_CRE8OR_ADDRESS);
        cre8ingBase.toggleCre8ingTokens(tokenIds);
        assertEq(cre8orsNFTBase.ownerOf(_tokenId), DEFAULT_CRE8OR_ADDRESS);
        cre8ingBase.safeTransferWhileCre8ing(
            DEFAULT_CRE8OR_ADDRESS,
            DEFAULT_TRANSFER_ADDRESS,
            _tokenId
        );
        assertEq(cre8orsNFTBase.ownerOf(_tokenId), DEFAULT_TRANSFER_ADDRESS);
        (bool cre8ing, , ) = cre8ingBase.cre8ingPeriod(_tokenId);
        assertEq(cre8ing, true);
    }

    function test_safeTransferWhileCre8ingRevert_Access_OnlyOwner()
        public
        setupCre8orsNFTBase
    {
        uint256 _tokenId = 1;
        vm.prank(DEFAULT_CRE8OR_ADDRESS);
        cre8orsNFTBase.purchase(1);

        vm.prank(DEFAULT_OWNER_ADDRESS);
        cre8ingBase.setCre8ingOpen(true);

        uint256[] memory tokenIds = new uint256[](1);
        tokenIds[0] = _tokenId;
        vm.prank(DEFAULT_CRE8OR_ADDRESS);
        cre8ingBase.toggleCre8ingTokens(tokenIds);
        assertEq(cre8orsNFTBase.ownerOf(_tokenId), DEFAULT_CRE8OR_ADDRESS);
        vm.startPrank(DEFAULT_TRANSFER_ADDRESS);
        vm.expectRevert(abi.encodeWithSignature("Access_OnlyOwner()"));
        cre8ingBase.safeTransferWhileCre8ing(
            DEFAULT_CRE8OR_ADDRESS,
            DEFAULT_TRANSFER_ADDRESS,
            _tokenId
        );
        assertEq(cre8orsNFTBase.ownerOf(_tokenId), DEFAULT_CRE8OR_ADDRESS);
    }

    function test_expelFromWarehouseRevert_uncre8ed()
        public
        setupCre8orsNFTBase
    {
        uint256 _tokenId = 1;
        vm.prank(DEFAULT_CRE8OR_ADDRESS);
        cre8orsNFTBase.purchase(1);

        vm.startPrank(DEFAULT_OWNER_ADDRESS);
        cre8ingBase.setCre8ingOpen(true);
        uint256[] memory tokenIds = new uint256[](1);
        tokenIds[0] = _tokenId;
        bytes32 role = cre8ingBase.EXPULSION_ROLE();
        cre8orsNFTBase.grantRole(role, DEFAULT_OWNER_ADDRESS);
        vm.expectRevert(
            abi.encodeWithSignature("CRE8ING_NotCre8ing(uint256)", _tokenId)
        );
        cre8ingBase.expelFromWarehouse(_tokenId);
    }

    function test_expelFromWarehouseRevert_AccessControl()
        public
        setupCre8orsNFTBase
    {
        uint256 _tokenId = 1;
        vm.prank(DEFAULT_CRE8OR_ADDRESS);
        cre8orsNFTBase.purchase(1);

        vm.prank(DEFAULT_OWNER_ADDRESS);
        cre8ingBase.setCre8ingOpen(true);

        uint256[] memory tokenIds = new uint256[](1);
        tokenIds[0] = _tokenId;
        vm.prank(DEFAULT_CRE8OR_ADDRESS);
        cre8ingBase.toggleCre8ingTokens(tokenIds);
        vm.prank(DEFAULT_OWNER_ADDRESS);
        (bool cre8ing, , ) = cre8ingBase.cre8ingPeriod(_tokenId);
        assertEq(cre8ing, true);
        bytes32 role = cre8ingBase.EXPULSION_ROLE();
        vm.startPrank(DEFAULT_CRE8OR_ADDRESS);
        vm.expectRevert(
            abi.encodePacked(
                "AccessControl: account ",
                Strings.toHexString(DEFAULT_CRE8OR_ADDRESS),
                " is missing role ",
                Strings.toHexString(uint256(role), 32)
            )
        );
        cre8ingBase.expelFromWarehouse(_tokenId);
        (cre8ing, , ) = cre8ingBase.cre8ingPeriod(_tokenId);
        assertEq(cre8ing, true);
    }

    function test_expelFromWarehouse() public setupCre8orsNFTBase {
        uint256 _tokenId = 1;
        vm.prank(DEFAULT_CRE8OR_ADDRESS);
        cre8orsNFTBase.purchase(1);

        vm.prank(DEFAULT_OWNER_ADDRESS);
        cre8ingBase.setCre8ingOpen(true);

        uint256[] memory tokenIds = new uint256[](1);
        tokenIds[0] = _tokenId;
        vm.prank(DEFAULT_CRE8OR_ADDRESS);
        cre8ingBase.toggleCre8ingTokens(tokenIds);
        vm.startPrank(DEFAULT_OWNER_ADDRESS);
        bytes32 role = cre8orsNFTBase.EXPULSION_ROLE();
        cre8orsNFTBase.grantRole(role, DEFAULT_OWNER_ADDRESS);
        (bool cre8ing, , ) = cre8ingBase.cre8ingPeriod(_tokenId);
        assertEq(cre8ing, true);
        cre8ingBase.expelFromWarehouse(_tokenId);
        (cre8ing, , ) = cre8ingBase.cre8ingPeriod(_tokenId);
        assertEq(cre8ing, false);
    }

    function test_cre8ingTokens()
        public
        setupCre8orsNFTBase()
    {
        vm.prank(DEFAULT_OWNER_ADDRESS);
        cre8orsNFTBase.setSaleConfiguration({
            erc20PaymentToken: address(0),
            publicSaleStart: 0,
            publicSaleEnd: type(uint64).max,
            presaleStart: 0,
            presaleEnd: 0,
            publicSalePrice: 0,
            maxSalePurchasePerAddress: 1000,
            presaleMerkleRoot: bytes32(0)
        });
        vm.deal(address(456), 10 ether);
        cre8orsNFTBase.purchase(100);
        uint256[] memory staked = cre8ingBase.cre8ingTokens();
        assertEq(staked.length, 100);
        for (uint256 i = 0; i < staked.length; i++) {
            assertEq(staked[i], 0);
        }
        uint256[] memory unstaked = new uint256[](100);
        for (uint256 i = 0; i < unstaked.length; i++) {
            unstaked[i] = i + 1;
        }
        vm.prank(DEFAULT_OWNER_ADDRESS);
        cre8ingBase.setCre8ingOpen(true);
        cre8ingBase.toggleCre8ingTokens(unstaked);
        staked = cre8ingBase.cre8ingTokens();
        for (uint256 i = 0; i < staked.length; i++) {
            assertEq(staked[i], i + 1);
        }
        assertEq(staked.length, 100);
    }   
    
}

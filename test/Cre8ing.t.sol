// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "forge-std/Test.sol";
import {Cre8ing} from "../src/Cre8ing.sol";
import {Cre8ors} from "../src/Cre8ors.sol";
import {DummyMetadataRenderer} from "./utils/DummyMetadataRenderer.sol";
import {IERC721Drop} from "../src/interfaces/IERC721Drop.sol";
import {Strings} from "../lib/openzeppelin-contracts/contracts/utils/Strings.sol";
import {ICre8ingHooks} from "../src/interfaces/ICre8ingHooks.sol";
import {BeforeLeaveWarehouseHook} from "../src/utils/BeforeLeaveWarehouseHook.sol";

contract Cre8ingTest is Test {
    Cre8ing public cre8ingBase;
    Cre8ors public cre8orsNFTBase;
    DummyMetadataRenderer public dummyRenderer = new DummyMetadataRenderer();

    address public constant DEFAULT_OWNER_ADDRESS = address(0x23499);
    address public constant DEFAULT_CRE8OR_ADDRESS = address(456);
    address public constant DEFAULT_TRANSFER_ADDRESS = address(0x2);

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
        (bool cre8ing, uint256 current, uint256 total) = cre8orsNFTBase
            .cre8ingPeriod(_tokenId);
        assertEq(cre8ing, false);
        assertEq(current, 0);
        assertEq(total, 0);
        uint256[] memory tokenIds = new uint256[](1);
        tokenIds[0] = _tokenId;
        vm.expectRevert(
            abi.encodeWithSignature("OwnerQueryForNonexistentToken()")
        );
        cre8orsNFTBase.toggleCre8ing(tokenIds);
    }

    function test_toggleCre8ingRevert_Cre8ing_Cre8ingClosed()
        public
        setupCre8orsNFTBase
    {
        uint256 _tokenId = 1;
        (bool cre8ing, uint256 current, uint256 total) = cre8orsNFTBase
            .cre8ingPeriod(_tokenId);
        assertEq(cre8ing, false);
        assertEq(current, 0);
        assertEq(total, 0);
        cre8orsNFTBase.purchase(1);
        uint256[] memory tokenIds = new uint256[](1);
        tokenIds[0] = _tokenId;
        vm.expectRevert(abi.encodeWithSignature("Cre8ing_Cre8ingClosed()"));
        cre8orsNFTBase.toggleCre8ing(tokenIds);
    }

    function test_toggleCre8ing() public setupCre8orsNFTBase {
        uint256 _tokenId = 1;
        (bool cre8ing, uint256 current, uint256 total) = cre8orsNFTBase
            .cre8ingPeriod(_tokenId);
        assertEq(cre8ing, false);
        assertEq(current, 0);
        assertEq(total, 0);
        cre8orsNFTBase.purchase(1);

        vm.prank(DEFAULT_OWNER_ADDRESS);
        cre8orsNFTBase.setCre8ingOpen(true);

        uint256[] memory tokenIds = new uint256[](1);
        tokenIds[0] = _tokenId;
        cre8orsNFTBase.toggleCre8ing(tokenIds);
        (cre8ing, current, total) = cre8orsNFTBase.cre8ingPeriod(_tokenId);
        assertEq(cre8ing, true);
        assertEq(current, 0);
        assertEq(total, 0);
    }

    function test_blockCre8ingTransfer() public setupCre8orsNFTBase {
        uint256 _tokenId = 1;
        vm.prank(DEFAULT_CRE8OR_ADDRESS);
        cre8orsNFTBase.purchase(1);

        vm.prank(DEFAULT_OWNER_ADDRESS);
        cre8orsNFTBase.setCre8ingOpen(true);

        uint256[] memory tokenIds = new uint256[](1);
        tokenIds[0] = _tokenId;
        vm.startPrank(DEFAULT_CRE8OR_ADDRESS);
        cre8orsNFTBase.toggleCre8ing(tokenIds);
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
        cre8orsNFTBase.setCre8ingOpen(true);

        uint256[] memory tokenIds = new uint256[](1);
        tokenIds[0] = _tokenId;
        vm.startPrank(DEFAULT_CRE8OR_ADDRESS);
        cre8orsNFTBase.toggleCre8ing(tokenIds);
        assertEq(cre8orsNFTBase.ownerOf(_tokenId), DEFAULT_CRE8OR_ADDRESS);
        cre8orsNFTBase.safeTransferWhileCre8ing(
            DEFAULT_CRE8OR_ADDRESS,
            DEFAULT_TRANSFER_ADDRESS,
            _tokenId
        );
        assertEq(cre8orsNFTBase.ownerOf(_tokenId), DEFAULT_TRANSFER_ADDRESS);
        (bool cre8ing, , ) = cre8orsNFTBase.cre8ingPeriod(_tokenId);
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
        cre8orsNFTBase.setCre8ingOpen(true);

        uint256[] memory tokenIds = new uint256[](1);
        tokenIds[0] = _tokenId;
        vm.prank(DEFAULT_CRE8OR_ADDRESS);
        cre8orsNFTBase.toggleCre8ing(tokenIds);
        assertEq(cre8orsNFTBase.ownerOf(_tokenId), DEFAULT_CRE8OR_ADDRESS);
        vm.startPrank(DEFAULT_TRANSFER_ADDRESS);
        vm.expectRevert(abi.encodeWithSignature("Access_OnlyOwner()"));
        cre8orsNFTBase.safeTransferWhileCre8ing(
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
        cre8orsNFTBase.setCre8ingOpen(true);
        uint256[] memory tokenIds = new uint256[](1);
        tokenIds[0] = _tokenId;
        bytes32 role = cre8ingBase.EXPULSION_ROLE();
        cre8orsNFTBase.grantRole(role, DEFAULT_OWNER_ADDRESS);
        vm.expectRevert(
            abi.encodeWithSignature("CRE8ING_NotCre8ing(uint256)", _tokenId)
        );
        cre8orsNFTBase.expelFromWarehouse(_tokenId);
    }

    function test_expelFromWarehouseRevert_AccessControl()
        public
        setupCre8orsNFTBase
    {
        uint256 _tokenId = 1;
        vm.prank(DEFAULT_CRE8OR_ADDRESS);
        cre8orsNFTBase.purchase(1);

        vm.prank(DEFAULT_OWNER_ADDRESS);
        cre8orsNFTBase.setCre8ingOpen(true);

        uint256[] memory tokenIds = new uint256[](1);
        tokenIds[0] = _tokenId;
        vm.prank(DEFAULT_CRE8OR_ADDRESS);
        cre8orsNFTBase.toggleCre8ing(tokenIds);
        vm.prank(DEFAULT_OWNER_ADDRESS);
        (bool cre8ing, , ) = cre8orsNFTBase.cre8ingPeriod(_tokenId);
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
        cre8orsNFTBase.expelFromWarehouse(_tokenId);
        (cre8ing, , ) = cre8orsNFTBase.cre8ingPeriod(_tokenId);
        assertEq(cre8ing, true);
    }

    function test_expelFromWarehouse() public setupCre8orsNFTBase {
        uint256 _tokenId = 1;
        vm.prank(DEFAULT_CRE8OR_ADDRESS);
        cre8orsNFTBase.purchase(1);

        vm.prank(DEFAULT_OWNER_ADDRESS);
        cre8orsNFTBase.setCre8ingOpen(true);

        uint256[] memory tokenIds = new uint256[](1);
        tokenIds[0] = _tokenId;
        vm.prank(DEFAULT_CRE8OR_ADDRESS);
        cre8orsNFTBase.toggleCre8ing(tokenIds);
        vm.startPrank(DEFAULT_OWNER_ADDRESS);
        bytes32 role = cre8orsNFTBase.EXPULSION_ROLE();
        cre8orsNFTBase.grantRole(role, DEFAULT_OWNER_ADDRESS);
        (bool cre8ing, , ) = cre8orsNFTBase.cre8ingPeriod(_tokenId);
        assertEq(cre8ing, true);
        cre8orsNFTBase.expelFromWarehouse(_tokenId);
        (cre8ing, , ) = cre8orsNFTBase.cre8ingPeriod(_tokenId);
        assertEq(cre8ing, false);
    }

    /// Before Leaving Warehouse test

    function test_BeforeLeavingWarehouseHookIsEmpty () public  {
        assertEq(cre8ingBase.getHook(ICre8ingHooks.HookType.BeforeLeaveWarehouse), address(0));
    }

    function testFail_setHookAsNonOwner () public {
        BeforeLeaveWarehouseHook beforeLeaveWarehouse = new BeforeLeaveWarehouseHook(DEFAULT_OWNER_ADDRESS);
        vm.expectRevert("AdminAccess_MissingRoleOrAdmin");
        cre8ingBase.setHook(ICre8ingHooks.HookType.BeforeLeaveWarehouse, address(beforeLeaveWarehouse));
    } 

    function test_assignBeforeLeavingWarehouseHook () public {
        BeforeLeaveWarehouseHook beforeLeaveWarehouse = new BeforeLeaveWarehouseHook(DEFAULT_OWNER_ADDRESS);
        vm.prank(DEFAULT_OWNER_ADDRESS);
        cre8ingBase.setHook(ICre8ingHooks.HookType.BeforeLeaveWarehouse, address(beforeLeaveWarehouse));
        assertEq(cre8ingBase.getHook(ICre8ingHooks.HookType.BeforeLeaveWarehouse), address(beforeLeaveWarehouse));
    }
    
}

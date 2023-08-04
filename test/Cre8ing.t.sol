// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "forge-std/Test.sol";
import {Cre8ing} from "../src/Cre8ing.sol";
import {ICre8ing} from "../src/interfaces/ICre8ing.sol";
import {DummyMetadataRenderer} from "./utils/DummyMetadataRenderer.sol";
import {IERC721Drop} from "../src/interfaces/IERC721Drop.sol";
import {Strings} from "../lib/openzeppelin-contracts/contracts/utils/Strings.sol";
import {Cre8orTestBase} from "./utils/Cre8orTestBase.sol";
import {TransferHook} from "../src/Transfers.sol";
import {IERC721ACH} from "ERC721H/interfaces/IERC721ACH.sol";
import {MinterAdminCheck} from "../src/minter/MinterAdminCheck.sol";



contract Cre8ingTest is Test, Cre8orTestBase {
    Cre8ing public cre8ingBase;
    TransferHook public transferHook;

    address public constant DEFAULT_CRE8OR_ADDRESS = address(456);
    address public constant DEFAULT_TRANSFER_ADDRESS = address(0x2);

    function setUp() public {
        Cre8orTestBase.cre8orSetup();
        cre8ingBase = new Cre8ing();
        transferHook = new TransferHook();
        vm.startPrank(DEFAULT_OWNER_ADDRESS);
        cre8orsNFTBase.setCre8ing(cre8ingBase);
        cre8orsNFTBase.setHook(
            IERC721ACH.HookType.BeforeTokenTransfers,
            address(transferHook)
        );
        transferHook.setBeforeTokenTransfersEnabled(
            address(cre8orsNFTBase),
            true
        );
        transferHook.setCre8ing(
            address(cre8orsNFTBase),
            ICre8ing(cre8ingBase)
        );
        vm.stopPrank();
        
    }

    function test_cre8ingPeriod(uint256 _tokenId) public {
        (bool cre8ing, uint256 current, uint256 total) = cre8ingBase
            .cre8ingPeriod(address(cre8orsNFTBase), _tokenId);
        assertEq(cre8ing, false);
        assertEq(current, 0);
        assertEq(total, 0);
    }

    function test_cre8ingOpen() public {
        assertEq(cre8ingBase.cre8ingOpen(address(cre8orsNFTBase)), false);
    }

    function test_setCre8ingOpenReverts_AdminAccess_MissingRoleOrAdmin(
        bool _isOpen
    ) public {
        assertEq(cre8ingBase.cre8ingOpen(address(cre8orsNFTBase)), false);
        vm.expectRevert(IERC721Drop.Access_OnlyAdmin.selector);
        cre8ingBase.setCre8ingOpen(address(cre8orsNFTBase), _isOpen);
        assertEq(cre8ingBase.cre8ingOpen(address(cre8orsNFTBase)), false);
    }

    function test_setCre8ingOpen(bool _isOpen) public {
        assertEq(cre8ingBase.cre8ingOpen(address(cre8orsNFTBase)), false);
        vm.prank(DEFAULT_OWNER_ADDRESS);
        cre8ingBase.setCre8ingOpen(address(cre8orsNFTBase), _isOpen);
        assertEq(cre8ingBase.cre8ingOpen(address(cre8orsNFTBase)), _isOpen);
    }

    function test_toggleCre8ingRevert_OwnerQueryForNonexistentToken(
        uint256 _tokenId
    ) public {
        (bool cre8ing, uint256 current, uint256 total) = cre8ingBase
            .cre8ingPeriod(address(cre8orsNFTBase), _tokenId);
        assertEq(cre8ing, false);
        assertEq(current, 0);
        assertEq(total, 0);
        uint256[] memory tokenIds = new uint256[](1);
        tokenIds[0] = _tokenId;
        vm.expectRevert(
            abi.encodeWithSignature("OwnerQueryForNonexistentToken()")
        );
        cre8ingBase.toggleCre8ingTokens(address(cre8orsNFTBase), tokenIds);
    }

    function test_toggleCre8ingRevert_Cre8ing_Cre8ingClosed() public {
        uint256 _tokenId = 1;
        (bool cre8ing, uint256 current, uint256 total) = cre8ingBase
            .cre8ingPeriod(address(cre8orsNFTBase), _tokenId);
        assertEq(cre8ing, false);
        assertEq(current, 0);
        assertEq(total, 0);
        cre8orsNFTBase.purchase(1);
        uint256[] memory tokenIds = new uint256[](1);
        tokenIds[0] = _tokenId;

        vm.expectRevert(ICre8ing.Cre8ing_Cre8ingClosed.selector);
        cre8ingBase.toggleCre8ingTokens(address(cre8orsNFTBase), tokenIds);
    }

    function test_toggleCre8ing() public {
        uint256 _tokenId = 1;
        (bool cre8ing, uint256 current, uint256 total) = cre8ingBase
            .cre8ingPeriod(address(cre8orsNFTBase), _tokenId);
        assertEq(cre8ing, false);
        assertEq(current, 0);
        assertEq(total, 0);
        cre8orsNFTBase.purchase(1);

        vm.prank(DEFAULT_OWNER_ADDRESS);
        cre8ingBase.setCre8ingOpen(address(cre8orsNFTBase), true);

        uint256[] memory tokenIds = new uint256[](1);
        tokenIds[0] = _tokenId;
        cre8ingBase.toggleCre8ingTokens(address(cre8orsNFTBase), tokenIds);
        (cre8ing, current, total) = cre8ingBase.cre8ingPeriod(
            address(cre8orsNFTBase),
            _tokenId
        );
        assertEq(cre8ing, true);
        assertEq(current, 0);
        assertEq(total, 0);
    }

    function test_blockCre8ingTransfer() public {
        uint256 _tokenId = 1;
        vm.prank(DEFAULT_CRE8OR_ADDRESS);
        cre8orsNFTBase.purchase(1);

        vm.prank(DEFAULT_OWNER_ADDRESS);
        cre8ingBase.setCre8ingOpen(address(cre8orsNFTBase), true);

        uint256[] memory tokenIds = new uint256[](1);
        tokenIds[0] = _tokenId;
        vm.startPrank(DEFAULT_CRE8OR_ADDRESS);
        cre8ingBase.toggleCre8ingTokens(address(cre8orsNFTBase), tokenIds);
        vm.expectRevert(abi.encodeWithSignature("Cre8ing_Cre8ing()"));
        cre8orsNFTBase.safeTransferFrom(
            DEFAULT_CRE8OR_ADDRESS,
            DEFAULT_OWNER_ADDRESS,
            _tokenId
        );
    }

    function test_safeTransferWhileCre8ing() public {
        uint256 _tokenId = 1;
        vm.prank(DEFAULT_CRE8OR_ADDRESS);
        cre8orsNFTBase.purchase(1);

        vm.prank(DEFAULT_OWNER_ADDRESS);
        cre8ingBase.setCre8ingOpen(address(cre8orsNFTBase), true);

        uint256[] memory tokenIds = new uint256[](1);
        tokenIds[0] = _tokenId;
        vm.startPrank(DEFAULT_CRE8OR_ADDRESS);
        cre8ingBase.toggleCre8ingTokens(address(cre8orsNFTBase), tokenIds);
        assertEq(cre8orsNFTBase.ownerOf(_tokenId), DEFAULT_CRE8OR_ADDRESS);
        cre8orsNFTBase.safeTransferWhileCre8ing(
            DEFAULT_CRE8OR_ADDRESS,
            DEFAULT_TRANSFER_ADDRESS,
            _tokenId
        );
        assertEq(cre8orsNFTBase.ownerOf(_tokenId), DEFAULT_TRANSFER_ADDRESS);
        (bool cre8ing, , ) = cre8ingBase.cre8ingPeriod(
            address(cre8orsNFTBase),
            _tokenId
        );
        assertEq(cre8ing, true);
    }

    function test_safeTransferWhileCre8ingRevert_Access_OnlyOwner() public {
        uint256 _tokenId = 1;
        vm.prank(DEFAULT_CRE8OR_ADDRESS);
        cre8orsNFTBase.purchase(1);

        vm.prank(DEFAULT_OWNER_ADDRESS);
        cre8ingBase.setCre8ingOpen(address(cre8orsNFTBase), true);

        uint256[] memory tokenIds = new uint256[](1);
        tokenIds[0] = _tokenId;
        vm.prank(DEFAULT_CRE8OR_ADDRESS);
        cre8ingBase.toggleCre8ingTokens(address(cre8orsNFTBase), tokenIds);
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

    function test_expelFromWarehouseRevert_uncre8ed() public {
        uint256 _tokenId = 1;
        vm.prank(DEFAULT_CRE8OR_ADDRESS);
        cre8orsNFTBase.purchase(1);
        vm.prank(DEFAULT_OWNER_ADDRESS);
        cre8ingBase.setCre8ingOpen(address(cre8orsNFTBase), true);
        uint256[] memory tokenIds = new uint256[](1);
        tokenIds[0] = _tokenId;
        vm.expectRevert(IERC721Drop.Access_OnlyAdmin.selector);
        cre8ingBase.expelFromWarehouse(address(cre8orsNFTBase), _tokenId);
    }

    function test_expelFromWarehouseRevert_AccessControl() public {
        uint256 _tokenId = 1;
        vm.prank(DEFAULT_CRE8OR_ADDRESS);
        cre8orsNFTBase.purchase(1);

        vm.prank(DEFAULT_OWNER_ADDRESS);
        cre8ingBase.setCre8ingOpen(address(cre8orsNFTBase), true);

        uint256[] memory tokenIds = new uint256[](1);
        tokenIds[0] = _tokenId;
        vm.prank(DEFAULT_CRE8OR_ADDRESS);
        cre8ingBase.toggleCre8ingTokens(address(cre8orsNFTBase), tokenIds);
        vm.prank(DEFAULT_OWNER_ADDRESS);
        (bool cre8ing, , ) = cre8ingBase.cre8ingPeriod(
            address(cre8orsNFTBase),
            _tokenId
        );
        assertEq(cre8ing, true);
        vm.startPrank(DEFAULT_CRE8OR_ADDRESS);
        vm.expectRevert(IERC721Drop.Access_OnlyAdmin.selector);
        cre8ingBase.expelFromWarehouse(address(cre8orsNFTBase), _tokenId);
        (cre8ing, , ) = cre8ingBase.cre8ingPeriod(
            address(cre8orsNFTBase),
            _tokenId
        );
        assertEq(cre8ing, true);
    }

    function test_expelFromWarehouse() public {
        uint256 _tokenId = 1;
        vm.prank(DEFAULT_CRE8OR_ADDRESS);
        cre8orsNFTBase.purchase(1);

        vm.prank(DEFAULT_OWNER_ADDRESS);
        cre8ingBase.setCre8ingOpen(address(cre8orsNFTBase), true);

        uint256[] memory tokenIds = new uint256[](1);
        tokenIds[0] = _tokenId;
        vm.prank(DEFAULT_CRE8OR_ADDRESS);
        cre8ingBase.toggleCre8ingTokens(address(cre8orsNFTBase), tokenIds);
        vm.startPrank(DEFAULT_OWNER_ADDRESS);
        (bool cre8ing, , ) = cre8ingBase.cre8ingPeriod(
            address(cre8orsNFTBase),
            _tokenId
        );
        assertEq(cre8ing, true);
        cre8ingBase.expelFromWarehouse(address(cre8orsNFTBase), _tokenId);
        (cre8ing, , ) = cre8ingBase.cre8ingPeriod(
            address(cre8orsNFTBase),
            _tokenId
        );
        assertEq(cre8ing, false);
    }

    function test_cre8ingTokens() public {
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
        uint256[] memory staked = cre8ingBase.cre8ingTokens(
            address(cre8orsNFTBase)
        );
        assertEq(staked.length, 100);
        for (uint256 i = 0; i < staked.length; i++) {
            assertEq(staked[i], 0);
        }
        uint256[] memory unstaked = new uint256[](100);
        for (uint256 i = 0; i < unstaked.length; i++) {
            unstaked[i] = i + 1;
        }
        vm.prank(DEFAULT_OWNER_ADDRESS);
        cre8ingBase.setCre8ingOpen(address(cre8orsNFTBase), true);
        cre8ingBase.toggleCre8ingTokens(address(cre8orsNFTBase), unstaked);
        staked = cre8ingBase.cre8ingTokens(address(cre8orsNFTBase));
        for (uint256 i = 0; i < staked.length; i++) {
            assertEq(staked[i], i + 1);
        }
        assertEq(staked.length, 100);
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "forge-std/Test.sol";
import {Cre8ingV2} from "../../src/utils/Cre8ingV2.sol";
import {ICre8ing} from "../../src/interfaces/ICre8ing.sol";
import {ILockup} from "../../src/interfaces/ILockup.sol";
import {Lockup} from "../../src/utils/Lockup.sol";
import {DummyMetadataRenderer} from "./DummyMetadataRenderer.sol";
import {IERC721Drop} from "../../src/interfaces/IERC721Drop.sol";
import {Strings} from "../../lib/openzeppelin-contracts/contracts/utils/Strings.sol";
import {Cre8orTestBase} from "./Cre8orTestBase.sol";
import {MinterAdminCheck} from "../../src/minter/MinterAdminCheck.sol";
import {TransferHook} from "../../src/hooks/Transfers.sol";
import {IERC721ACH} from "ERC721H/interfaces/IERC721ACH.sol";

contract Cre8ingV2Test is Test, Cre8orTestBase {
    Cre8ingV2 public cre8ingBase;
    address public constant DEFAULT_CRE8OR_ADDRESS = address(456);
    address public constant DEFAULT_TRANSFER_ADDRESS = address(0x2);
    Lockup lockup = new Lockup();

    function setUp() public {
        Cre8orTestBase.cre8orSetup();
        cre8ingBase = new Cre8ingV2();
        vm.startPrank(DEFAULT_OWNER_ADDRESS);
        transferHook = new TransferHook(
            address(cre8orsNFTBase),
            address(erc6551Registry),
            address(erc6551Implementation)
        );
        transferHook.setCre8ing(address(cre8ingBase));
        cre8orsNFTBase.setHook(
            IERC721ACH.HookType.BeforeTokenTransfers,
            address(transferHook)
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
        transferHook.safeTransferWhileCre8ing(
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
        transferHook.safeTransferWhileCre8ing(
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

    function test_inializeStakingAndLockup(
        uint256 _quantity,
        address _minter
    ) public {
        vm.assume(_quantity > 0);
        vm.assume(_quantity < 10);

        // init Lockup
        setup_lockup();
        open_staking();

        // buy tokens
        cre8orsNFTBase.purchase(_quantity);

        // generate list of tokens
        uint256[] memory tokenIds = generateUnstakedTokenIds(_quantity);

        // function under test - inializeStakingAndLockup
        grant_minter_role(_minter);
        vm.prank(_minter);
        cre8ingBase.inializeStaking(address(cre8orsNFTBase), tokenIds);

        // assertions
        verifyStaked(_quantity, true);
    }

    function test_inializeStakingAndLockup_revert_Cre8ing_Cre8ingClosed(
        uint256 _quantity,
        address _minter
    ) public {
        vm.assume(_quantity > 0);
        vm.assume(_quantity < 10);

        // init Lockup
        setup_lockup();

        // buy tokens
        cre8orsNFTBase.purchase(_quantity);

        // generate list of tokens
        uint256[] memory tokenIds = generateUnstakedTokenIds(_quantity);

        // function under test - inializeStakingAndLockup
        grant_minter_role(_minter);
        vm.prank(_minter);
        vm.expectRevert(ICre8ing.Cre8ing_Cre8ingClosed.selector);
        cre8ingBase.inializeStaking(address(cre8orsNFTBase), tokenIds);

        // assertions
        verifyStaked(_quantity, false);
    }

    function test_inializeStakingAndLockup_revert_MissingMinterRole(
        uint256 _quantity
    ) public {
        // buy tokens
        vm.assume(_quantity > 0);
        vm.assume(_quantity < 10);
        cre8orsNFTBase.purchase(_quantity);

        // init Lockup & Staking
        setup_lockup();
        open_staking();

        // generate list of tokens
        uint256[] memory tokenIds = generateUnstakedTokenIds(_quantity);

        // function under test - inializeStakingAndLockup
        vm.expectRevert(
            MinterAdminCheck.AdminAccess_MissingMinterOrAdmin.selector
        );
        cre8ingBase.inializeStaking(address(cre8orsNFTBase), tokenIds);

        // assertions
        verifyStaked(_quantity, false);
    }

    function test_inializeStaking_MULTIPLE_TIMES_ALL(uint256 _quantity) public {
        // buy tokens
        vm.assume(_quantity > 0);
        vm.assume(_quantity < 10);
        cre8orsNFTBase.purchase(_quantity);

        // init Lockup & Staking
        setup_lockup();
        open_staking();

        // generate list of tokens
        uint256[] memory tokenIds = generateUnstakedTokenIds(_quantity);

        // function under test - inializeStakingAndLockup multiple times
        _initializeStaking(tokenIds);
        _initializeStaking(tokenIds);
    }

    function test_inializeStakingAndLockup_revert_Cre8ing_Cre8ing_ONE(
        uint256 _quantity,
        address _minter
    ) public {
        // buy tokens
        vm.assume(_quantity > 0);
        vm.assume(_quantity < 10);
        vm.assume(_minter != address(0));
        vm.prank(_minter);
        cre8orsNFTBase.purchase(_quantity);

        // init Lockup & Staking
        setup_lockup();
        open_staking();

        // generate list of tokens
        uint256[] memory tokenIds = generateUnstakedTokenIds(1);

        // stake 1 token
        grant_minter_role(_minter);
        vm.prank(_minter);
        cre8ingBase.toggleCre8ingTokens(address(cre8orsNFTBase), tokenIds);

        // function under test - inializeStakingAndLockup
        _initializeStaking(tokenIds);
    }

    function _initializeStaking(uint256[] memory _tokenIds) internal {
        vm.prank(DEFAULT_OWNER_ADDRESS);
        cre8ingBase.inializeStaking(address(cre8orsNFTBase), _tokenIds);

        // assertions
        verifyStaked(_tokenIds.length, true);
    }

    function setup_lockup() internal {
        // give Staking contract Minter Role
        grant_minter_role(address(cre8ingBase));
        // Set Lockup on Staking Contract
        vm.prank(DEFAULT_OWNER_ADDRESS);
        cre8ingBase.setLockup(address(cre8orsNFTBase), lockup);
    }

    function grant_minter_role(address _minter) internal {
        bytes32 role = cre8orsNFTBase.MINTER_ROLE();
        vm.prank(DEFAULT_OWNER_ADDRESS);
        cre8orsNFTBase.grantRole(role, _minter);
    }

    function open_staking() internal {
        vm.prank(DEFAULT_OWNER_ADDRESS);
        cre8ingBase.setCre8ingOpen(address(cre8orsNFTBase), true);
    }

    function verifyStaked(uint256 _quantity, bool _lockedAndStaked) internal {
        for (uint256 i = 0; i < _quantity; i++) {
            // Token is Staked
            (bool cre8ing, , ) = cre8ingBase.cre8ingPeriod(
                address(cre8orsNFTBase),
                i + 1
            );
            assertEq(cre8ing, _lockedAndStaked);
        }
    }

    function generateUnstakedTokenIds(
        uint256 _quantity
    ) internal returns (uint256[] memory tokenIds) {
        tokenIds = new uint256[](_quantity);
        for (uint256 i = 0; i < _quantity; i++) {
            tokenIds[i] = i + 1;
            // Token is Staked
            (bool cre8ing, , ) = cre8ingBase.cre8ingPeriod(
                address(cre8orsNFTBase),
                i + 1
            );
            assertEq(cre8ing, false);
        }
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import {Vm} from "forge-std/Vm.sol";
import {DSTest} from "ds-test/test.sol";
import {Cre8orBuilderRewards} from "../src/Cre8orBuilderRewards.sol";
import {Cre8orRewards1155} from "../src/Cre8orRewards1155.sol";
import {DummyMetadataRenderer} from "./utils/DummyMetadataRenderer.sol";
import {IERC721Drop} from "../src/interfaces/IERC721Drop.sol";
import {IERC721A} from "lib/ERC721A/contracts/IERC721A.sol";

contract Cre8orBuilderRewardsTest is DSTest {
    Cre8orBuilderRewards public builderRewards;
    Cre8orRewards1155 public rewards;
    Vm public constant vm = Vm(HEVM_ADDRESS);
    DummyMetadataRenderer public dummyRenderer = new DummyMetadataRenderer();
    address public constant DEFAULT_OWNER_ADDRESS = address(0x23499);
    address payable public constant DEFAULT_FUNDS_RECIPIENT_ADDRESS =
        payable(address(0x21303));
    address payable public constant DEFAULT_PARTICIPANT = payable(address(456));
    uint64 DEFAULT_EDITION_SIZE = 10_000;
    uint256 BURN_QUANTITY = 5;

    function setUp() public {
        vm.startPrank(DEFAULT_OWNER_ADDRESS);
        rewards = new Cre8orRewards1155("uri/{id}");
        builderRewards = new Cre8orBuilderRewards({
            _contractName: "CRE8ORS",
            _contractSymbol: "CRE8",
            _initialOwner: DEFAULT_OWNER_ADDRESS,
            _fundsRecipient: payable(DEFAULT_FUNDS_RECIPIENT_ADDRESS),
            _burnToken: address(rewards),
            _burnQuantity: BURN_QUANTITY,
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
        builderRewards.setSaleConfiguration({
            erc20PaymentToken: address(0),
            publicSaleStart: 0,
            publicSaleEnd: type(uint64).max,
            presaleStart: 0,
            presaleEnd: 0,
            publicSalePrice: 0,
            maxSalePurchasePerAddress: 0,
            presaleMerkleRoot: bytes32(0)
        });
        vm.stopPrank();
    }

    function test_Erc721() public {
        assertEq("CRE8ORS", builderRewards.name());
        assertEq("CRE8", builderRewards.symbol());
        assertEq(type(uint64).max, builderRewards.saleDetails().maxSupply);
    }

    function test_BurnInit() public {
        (address burnToken, uint256 burnQuantity) = builderRewards.burnConfig();
        assertEq(address(rewards), burnToken);
        assertEq(BURN_QUANTITY, burnQuantity);
    }

    function test_Purchase_revertNotApprovedForAll() public {
        //  Airdrop Participation Rewards
        vm.prank(DEFAULT_OWNER_ADDRESS);
        rewards.mint(DEFAULT_PARTICIPANT, 1, BURN_QUANTITY, "0x0");
        assertEq(rewards.balanceOf(DEFAULT_PARTICIPANT, 1), BURN_QUANTITY);
        // Expect Purchase to Fail
        vm.expectRevert("CRE8ORS: not approved to transfer Burn Token");
        vm.prank(DEFAULT_PARTICIPANT);
        builderRewards.purchase(1);
        // Verify no tokens transferred
        assertEq(rewards.balanceOf(address(456), 1), BURN_QUANTITY);
    }

    function test_Purchase(uint8 amountToPurchase) public {
        //  Airdrop Participation Rewards
        if (amountToPurchase == 0) {
            return;
        }
        vm.prank(DEFAULT_OWNER_ADDRESS);
        rewards.mint(
            DEFAULT_PARTICIPANT,
            1,
            BURN_QUANTITY * amountToPurchase,
            "0x0"
        );
        assertEq(
            rewards.balanceOf(address(456), 1),
            BURN_QUANTITY * amountToPurchase
        );
        // Approve Builder Rewards Burning
        vm.startPrank(DEFAULT_PARTICIPANT);
        rewards.setApprovalForAll(address(builderRewards), true);
        builderRewards.purchase(amountToPurchase);
        // Expect Tokens Tranferred
        assertEq(rewards.balanceOf(DEFAULT_PARTICIPANT, 1), 0);
        assertEq(builderRewards.saleDetails().totalMinted, amountToPurchase);
        assertEq(builderRewards.ownerOf(1), DEFAULT_PARTICIPANT);
    }

    function test_Mint() public {
        vm.prank(DEFAULT_OWNER_ADDRESS);
        builderRewards.adminMint(DEFAULT_OWNER_ADDRESS, 1);
        assertEq(builderRewards.saleDetails().totalMinted, 1);
        require(
            builderRewards.ownerOf(1) == DEFAULT_OWNER_ADDRESS,
            "Owner is wrong for new minted token"
        );
    }

    function test_Withdraw(uint128 amount) public {
        vm.assume(amount > 0.01 ether);
        vm.deal(address(builderRewards), amount);
        vm.prank(DEFAULT_OWNER_ADDRESS);
        builderRewards.withdraw();

        assertTrue(
            DEFAULT_FUNDS_RECIPIENT_ADDRESS.balance >
                ((uint256(amount) * 1_000 * 95) / 100000) - 2 ||
                DEFAULT_FUNDS_RECIPIENT_ADDRESS.balance <
                ((uint256(amount) * 1_000 * 95) / 100000) + 2
        );
    }

    function test_WithdrawNotAllowed() public {
        vm.expectRevert(IERC721Drop.Access_WithdrawNotAllowed.selector);
        builderRewards.withdraw();
    }

    function test_AdminMint() public {
        address minter = address(0x32402);
        vm.startPrank(DEFAULT_OWNER_ADDRESS);
        builderRewards.adminMint(DEFAULT_OWNER_ADDRESS, 1);
        require(
            builderRewards.balanceOf(DEFAULT_OWNER_ADDRESS) == 1,
            "Wrong balance"
        );
        builderRewards.grantRole(builderRewards.MINTER_ROLE(), minter);
        vm.stopPrank();
        vm.prank(minter);
        builderRewards.adminMint(minter, 1);
        require(builderRewards.balanceOf(minter) == 1, "Wrong balance");
        assertEq(builderRewards.saleDetails().totalMinted, 2);
    }

    // test Admin airdrop
    function test_AdminMintAirdrop() public {
        vm.startPrank(DEFAULT_OWNER_ADDRESS);
        address[] memory toMint = new address[](4);
        toMint[0] = address(0x10);
        toMint[1] = address(0x11);
        toMint[2] = address(0x12);
        toMint[3] = address(0x13);
        builderRewards.adminMintAirdrop(toMint);
        assertEq(builderRewards.saleDetails().totalMinted, 4);
        assertEq(builderRewards.balanceOf(address(0x10)), 1);
        assertEq(builderRewards.balanceOf(address(0x11)), 1);
        assertEq(builderRewards.balanceOf(address(0x12)), 1);
        assertEq(builderRewards.balanceOf(address(0x13)), 1);
    }

    function test_AdminMintAirdropFails() public {
        vm.startPrank(address(0x10));
        address[] memory toMint = new address[](4);
        toMint[0] = address(0x10);
        toMint[1] = address(0x11);
        toMint[2] = address(0x12);
        toMint[3] = address(0x13);
        bytes32 minterRole = builderRewards.MINTER_ROLE();
        vm.expectRevert(
            abi.encodeWithSignature(
                "AdminAccess_MissingRoleOrAdmin(bytes32)",
                minterRole
            )
        );
        builderRewards.adminMintAirdrop(toMint);
    }

    // test admin mint non-admin permissions
    function test_AdminMintBatch() public {
        vm.startPrank(DEFAULT_OWNER_ADDRESS);
        builderRewards.adminMint(DEFAULT_OWNER_ADDRESS, 100);
        assertEq(builderRewards.saleDetails().totalMinted, 100);
        assertEq(builderRewards.balanceOf(DEFAULT_OWNER_ADDRESS), 100);
    }

    function test_AdminMintBatchFails() public {
        vm.startPrank(address(0x10));
        bytes32 role = builderRewards.MINTER_ROLE();
        vm.expectRevert(
            abi.encodeWithSignature(
                "AdminAccess_MissingRoleOrAdmin(bytes32)",
                role
            )
        );
        builderRewards.adminMint(address(0x10), 100);
    }

    function test_Burn() public {
        address minter = address(0x32402);
        vm.startPrank(DEFAULT_OWNER_ADDRESS);
        builderRewards.grantRole(builderRewards.MINTER_ROLE(), minter);
        vm.stopPrank();
        vm.startPrank(minter);
        address[] memory airdrop = new address[](1);
        airdrop[0] = minter;
        builderRewards.adminMintAirdrop(airdrop);
        builderRewards.burn(1);
        vm.stopPrank();
    }

    function test_BurnNonOwner() public {
        address minter = address(0x32402);
        vm.startPrank(DEFAULT_OWNER_ADDRESS);
        builderRewards.grantRole(builderRewards.MINTER_ROLE(), minter);
        vm.stopPrank();
        vm.startPrank(minter);
        address[] memory airdrop = new address[](1);
        airdrop[0] = minter;
        builderRewards.adminMintAirdrop(airdrop);
        vm.stopPrank();

        vm.prank(address(1));
        vm.expectRevert(IERC721A.TransferCallerNotOwnerNorApproved.selector);
        builderRewards.burn(1);
    }
}

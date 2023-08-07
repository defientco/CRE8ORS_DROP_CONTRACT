// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;
// Forge Imports
import {DSTest} from "ds-test/test.sol";
import {Vm} from "forge-std/Vm.sol";
// interface imports
import {ICre8ors} from "../../src/interfaces/ICre8ors.sol";
import {IERC721Drop} from "../../src/interfaces/IERC721Drop.sol";
import {IFriendsAndFamilyMinter} from "../../src/interfaces/IFriendsAndFamilyMinter.sol";
import {ILockup} from "../../src/interfaces/ILockup.sol";
import {IMinterUtilities} from "../../src/interfaces/IMinterUtilities.sol";
import {IERC721ACH} from "ERC721H/interfaces/IERC721ACH.sol";
import {ISubscription} from "../../src/subscription/interfaces/ISubscription.sol";
import {IERC5643} from "../../src/subscription/interfaces/IERC5643.sol";
// contract imports
import {Cre8ors} from "../../src/Cre8ors.sol";
import {Cre8orTestBase} from "../utils/Cre8orTestBase.sol";
import {DummyMetadataRenderer} from "../utils/DummyMetadataRenderer.sol";
import {FriendsAndFamilyMinter} from "../../src/minter/FriendsAndFamilyMinter.sol";
import {Lockup} from "../../src/utils/Lockup.sol";
import {MinterUtilities} from "../../src/utils/MinterUtilities.sol";
import {Cre8ing} from "../../src/Cre8ing.sol";
import {OwnerOfHook} from "../../src/hooks/OwnerOf.sol";
import {TransferHook} from "../../src/Transfers.sol";
import {Subscription} from "../../src/subscription/Subscription.sol";

contract SubscriptionTest is DSTest, Cre8orTestBase {
    FriendsAndFamilyMinter public minter;
    MinterUtilities public minterUtility;
    Cre8ing public cre8ingBase;
    address public familyMinter = address(0x1234567);

    Vm public constant vm = Vm(HEVM_ADDRESS);
    Lockup lockup = new Lockup();

    OwnerOfHook public ownerOfHook;
    TransferHook public transferHook;
    Subscription public subscription;

    uint64 public constant ONE_YEAR_DURATION = 365 days;

    event SubscriptionUpdate(uint256 indexed tokenId, uint64 expiration);

    function setUp() public {
        Cre8orTestBase.cre8orSetup();
        minterUtility = new MinterUtilities(
            address(cre8orsNFTBase),
            50000000000000000,
            100000000000000000,
            150000000000000000
        );
        minter = new FriendsAndFamilyMinter(
            address(cre8orsNFTBase),
            address(minterUtility)
        );

        subscription = _setupSubscription();

        transferHook = _setupTransferHook();
        ownerOfHook = _setupOwnerOfHook();

        cre8ingBase = new Cre8ing();
        vm.prank(DEFAULT_OWNER_ADDRESS);
        cre8orsNFTBase.setCre8ing(cre8ingBase);
    }

    function testCheckSubscription() external {
        uint256 tokenId = 1;

        assertTrue(!subscription.isSubscriptionValid(tokenId));

        vm.expectRevert(ISubscription.InvalidSubscription.selector);
        subscription.checkSubscription(tokenId);
    }

    function testSubscriptionForFree(uint256 tokenId) internal {
        vm.assume(tokenId != 0);
        vm.warp(1000);

        vm.expectEmit(true, true, true, true);
        emit SubscriptionUpdate(tokenId, 20 days + 1000);

        vm.prank(DEFAULT_OWNER_ADDRESS);
        subscription.updateSubscriptionForFree({
            target: address(cre8orsNFTBase),
            duration: 20 days,
            tokenId: tokenId
        });

        assertTrue(subscription.isSubscriptionValid(tokenId));
    }

    function testSubscriptionPaid(uint256 tokenId) internal {
        vm.assume(tokenId != 0);
        vm.warp(1000);

        vm.expectEmit(true, true, true, true);
        emit SubscriptionUpdate(tokenId, 30 days + 1000);

        vm.prank(DEFAULT_OWNER_ADDRESS);
        subscription.updateSubscription{value: 0.1 ether}({
            target: address(cre8orsNFTBase),
            duration: 30 days,
            tokenId: tokenId
        });

        assertTrue(subscription.isSubscriptionValid(tokenId));
    }

    function testRenewalExistingSubscription(address user) external{
        vm.warp(1000);

        vm.assume(user != address(0));
        vm.deal(user, 10 ether);

        uint256 tokenId = 1;
        assertTrue(!subscription.isSubscriptionValid(tokenId));

        vm.prank(address(DEFAULT_OWNER_ADDRESS));
        cre8orsNFTBase.adminMint(user, 1); // subscribes for 1 year

        assertTrue(subscription.isSubscriptionValid(tokenId));
        assertEq(cre8orsNFTBase.ownerOf(tokenId), user);

        vm.expectEmit(true, true, true, true);
        emit SubscriptionUpdate(tokenId, ONE_YEAR_DURATION + 30 days + 1000);
        subscription.renewSubscription{value: 0.1 ether}(tokenId, 30 days);
        assertEq(address(cre8orsNFTBase).balance, 0.1 ether);
    }

    function testRenewalExpiredSubscription(address user) external{
        vm.assume(user != address(0));
        vm.deal(user, 10 ether);

        uint256 tokenId = 1;
        assertTrue(!subscription.isSubscriptionValid(tokenId));

        vm.prank(address(DEFAULT_OWNER_ADDRESS));
        cre8orsNFTBase.adminMint(user, 1); // subscribes for 1 year

        assertTrue(subscription.isSubscriptionValid(tokenId));
        assertEq(cre8orsNFTBase.ownerOf(tokenId), user);

        // 1 year passed
        vm.warp(block.timestamp + ONE_YEAR_DURATION);

        // ownerOf should return address(0)
        assertEq(cre8orsNFTBase.ownerOf(tokenId), address(0));
        assertTrue(!subscription.isSubscriptionValid(tokenId));

        vm.expectEmit(true, true, true, true);
        emit SubscriptionUpdate(tokenId, uint64(block.timestamp) + 30 days);
        vm.prank(user);
        subscription.renewSubscription{value: 0.1 ether}(tokenId, 30 days);
        assertEq(address(cre8orsNFTBase).balance, 0.1 ether);
    }

    function testCancelSubscription(address user) public {
        vm.assume(user != address(0));
        vm.deal(user, 10 ether);

        uint256 tokenId = 1;

        vm.prank(address(DEFAULT_OWNER_ADDRESS));
        cre8orsNFTBase.adminMint(user, 1); // subscribes for 1 year

        assertTrue(subscription.isSubscriptionValid(tokenId));
        assertEq(cre8orsNFTBase.ownerOf(tokenId), user);

        vm.expectEmit(true, true, false, true);
        emit SubscriptionUpdate(tokenId, 0);
        vm.prank(user);
        subscription.cancelSubscription(tokenId);

        assertTrue(!subscription.isSubscriptionValid(tokenId));
        assertEq(cre8orsNFTBase.ownerOf(tokenId), address(0));
    }

    function testSetRenewable() external{
        assertTrue(subscription.isRenewable(0));

        vm.prank(address(DEFAULT_OWNER_ADDRESS));
        subscription.setRenewable(address(cre8orsNFTBase), false);

        assertTrue(!subscription.isRenewable(0));
    }

    function testSetMinRenewalDuration() external{
        assertEq(subscription.minRenewalDuration(), 1 days);

        vm.prank(address(DEFAULT_OWNER_ADDRESS));
        subscription.setMinRenewalDuration(address(cre8orsNFTBase), 0);

        assertEq(subscription.minRenewalDuration(), 0);
    }

    function testSetMaxRenewalDuration() external{
        assertEq(subscription.maxRenewalDuration(), 0);

        vm.prank(address(DEFAULT_OWNER_ADDRESS));
        subscription.setMaxRenewalDuration(address(cre8orsNFTBase), 1000);

        assertEq(subscription.maxRenewalDuration(), 1000);
    }

    function testRevertSetRenewable(address user) external{
        vm.assume(user != address(0));

        // EVM Error
        vm.expectRevert();
        vm.prank(user);
        subscription.setRenewable(user, true);
    }

    function testRevertSetMaxRenewalDuration(address user, address target, uint64 duration) external{
        vm.assume(user != address(0));
        vm.assume(target != address(0));
        vm.assume(duration != 0);

        // EVM Error
        vm.expectRevert();
        vm.prank(user);
        subscription.setMaxRenewalDuration(user, 3600);
    }

    function testRevertSetMinRenewalDuration(address user, address target, uint64 duration) external{
        vm.assume(user != address(0));
        vm.assume(target != address(0));
        vm.assume(duration != 0);

        // EVM Error
        vm.expectRevert();
        vm.prank(user);
        subscription.setMinRenewalDuration(user, 3600);
    }

    /// HELPER FUNCTIONS ///

    function _addDiscount(address _buyer) internal {
        assertTrue(!minter.hasDiscount(_buyer));
        vm.prank(DEFAULT_OWNER_ADDRESS);
        minter.addDiscount(_buyer);
        assertTrue(minter.hasDiscount(_buyer));
    }

    function _setMinterRole(address _assignee) internal {
        vm.startPrank(DEFAULT_OWNER_ADDRESS);
        cre8orsNFTBase.grantRole(
            cre8orsNFTBase.MINTER_ROLE(),
            address(_assignee)
        );
        vm.stopPrank();
    }

    /// SETUP CONTRACT FUNCTIONS ///

    function _setupMinter() internal {
        bytes32 role = cre8orsNFTBase.MINTER_ROLE();
        vm.startPrank(DEFAULT_OWNER_ADDRESS);
        cre8orsNFTBase.grantRole(role, address(minter));
        cre8orsNFTBase.grantRole(
            cre8orsNFTBase.MINTER_ROLE(),
            address(cre8ingBase)
        );
        cre8ingBase.setCre8ingOpen(address(cre8orsNFTBase), true);

        cre8ingBase.setLockup(address(cre8orsNFTBase), lockup);
        assertTrue(
            cre8orsNFTBase.hasRole(
                cre8orsNFTBase.MINTER_ROLE(),
                address(minter)
            )
        );
        vm.stopPrank();
    }

    function _setupOwnerOfHook() internal returns (OwnerOfHook) {
        ownerOfHook = new OwnerOfHook();
        _setMinterRole(address(ownerOfHook));

        vm.startPrank(DEFAULT_OWNER_ADDRESS);
        // set hook
        cre8orsNFTBase.setHook(
            IERC721ACH.HookType.OwnerOf,
            address(ownerOfHook)
        );
        // set subscription
        ownerOfHook.setSubscription(address(cre8orsNFTBase), address(subscription));
        vm.stopPrank();

        return ownerOfHook;
    }

    function _setupTransferHook() internal returns (TransferHook) {
        transferHook = new TransferHook();
        _setMinterRole(address(transferHook));

        vm.startPrank(DEFAULT_OWNER_ADDRESS);
        // set hook
        cre8orsNFTBase.setHook(
            IERC721ACH.HookType.AfterTokenTransfers,
            address(transferHook)
        );
        // set subscription
        transferHook.setSubscription(address(cre8orsNFTBase), address(subscription));
        vm.stopPrank();

        return transferHook;
    }

    function _setupSubscription() internal returns (Subscription) {
        subscription = new Subscription({
            cre8orsNFT_: address(cre8orsNFTBase),
            minRenewalDuration_: 1 days,
            pricePerSecond_: 38580246913 // Roughly calculates to 0.1 ether per 30 days
        });

        return subscription;
    }
}

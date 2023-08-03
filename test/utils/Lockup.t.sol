// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import {Vm} from "forge-std/Vm.sol";
import {DSTest} from "ds-test/test.sol";
import {Lockup} from "../../src/utils/Lockup.sol";
import {ILockup} from "../../src/interfaces/ILockup.sol";
import {Cre8orTestBase} from "./Cre8orTestBase.sol";
import {IERC721Drop} from "../../src/interfaces/IERC721Drop.sol";
import {Cre8ing} from "../../src/Cre8ing.sol";
import {console2} from "forge-std/console2.sol";
import {ICre8ors} from "../../src/interfaces/ICre8ors.sol";
import {MinterAdminCheck} from "../../src/minter/MinterAdminCheck.sol";

contract LockupTest is DSTest, Cre8orTestBase {
    Vm public constant vm = Vm(HEVM_ADDRESS);
    Lockup lockup = new Lockup();
    Cre8ing public cre8ingBase;

    function setUp() public {
        Cre8orTestBase.cre8orSetup();
        cre8ingBase = new Cre8ing();
        vm.prank(DEFAULT_OWNER_ADDRESS);
        cre8orsNFTBase.setCre8ing(cre8ingBase);
    }

    function test_lockup() public {
        assertEq(
            address(cre8ingBase.lockup(address(cre8orsNFTBase))),
            address(0)
        );
    }

    function test_setLockup() public {
        assertEq(
            address(cre8ingBase.lockup(address(cre8orsNFTBase))),
            address(0)
        );
        vm.prank(DEFAULT_OWNER_ADDRESS);
        cre8ingBase.setLockup(address(cre8orsNFTBase), lockup);
        assertEq(
            address(cre8ingBase.lockup(address(cre8orsNFTBase))),
            address(lockup)
        );
    }

    function testFail_setLockup_revert_Access_OnlyOwner() public {
        assertEq(
            address(cre8ingBase.lockup(address(cre8orsNFTBase))),
            address(0)
        );
        cre8ingBase.setLockup(address(cre8orsNFTBase), lockup);
        vm.expectRevert("Requires owner role");
        assertEq(
            address(cre8ingBase.lockup(address(cre8orsNFTBase))),
            address(0)
        );
    }

    function test_setUnlockInfo(
        uint64 unlockDate,
        uint256 priceToUnlock
    ) public {
        _assertLockup(1, 0, 0);
        bytes memory data = abi.encode(unlockDate, priceToUnlock);
        vm.prank(DEFAULT_OWNER_ADDRESS);
        lockup.setUnlockInfo(address(cre8orsNFTBase), 1, data);
        _assertLockup(1, unlockDate, priceToUnlock);
    }

    function test_setUnlockInfo_revert_Access_OnlyAdmin(
        uint256 tokenId,
        uint64 unlockDate,
        uint256 priceToUnlock
    ) public {
        _assertLockup(tokenId, 0, 0);
        bytes memory data = abi.encode(unlockDate, priceToUnlock);
        vm.expectRevert(
            MinterAdminCheck.AdminAccess_MissingMinterOrAdmin.selector
        );
        lockup.setUnlockInfo(address(cre8orsNFTBase), tokenId, data);
        _assertLockup(tokenId, 0, 0);
    }

    function test_isLocked(
        uint256 tokenId,
        uint64 unlockDate,
        uint256 priceToUnlock
    ) public {
        _assertIsLocked(tokenId, false);
        bytes memory data = abi.encode(unlockDate, priceToUnlock);
        vm.prank(DEFAULT_OWNER_ADDRESS);
        lockup.setUnlockInfo(address(cre8orsNFTBase), tokenId, data);
        bool expectLocked = block.timestamp <
            lockup.unlockInfo(address(cre8orsNFTBase), tokenId).unlockDate;
        _assertIsLocked(tokenId, expectLocked);
    }

    function test_payToUnlock(
        uint256 tokenId,
        uint64 unlockDate,
        uint256 priceToUnlock
    ) public {
        uint64 start = uint64(block.timestamp);
        vm.assume(priceToUnlock > 0);
        vm.assume(unlockDate > start);

        _assertIsLocked(tokenId, false);
        bytes memory data = abi.encode(unlockDate, priceToUnlock);
        vm.prank(DEFAULT_OWNER_ADDRESS);
        lockup.setUnlockInfo(address(cre8orsNFTBase), tokenId, data);

        vm.startPrank(DEFAULT_BUYER_ADDRESS);
        vm.deal(DEFAULT_BUYER_ADDRESS, priceToUnlock);
        lockup.payToUnlock{value: priceToUnlock}(
            payable(address(cre8orsNFTBase)),
            tokenId
        );
        _assertIsLocked(tokenId, false);
        assertEq(address(cre8orsNFTBase).balance, priceToUnlock);
    }

    function test_payToUnlock_refundsExtra(
        uint256 tokenId,
        uint64 unlockDate,
        uint256 priceToUnlock,
        uint256 pricePaid
    ) public {
        uint64 start = uint64(block.timestamp);
        vm.assume(priceToUnlock > 0);
        vm.assume(unlockDate > start);
        vm.assume(pricePaid > priceToUnlock);

        // Lock token
        _assertIsLocked(tokenId, false);
        bytes memory data = abi.encode(unlockDate, priceToUnlock);
        vm.prank(DEFAULT_OWNER_ADDRESS);
        lockup.setUnlockInfo(address(cre8orsNFTBase), tokenId, data);

        // Pay to unlock
        vm.startPrank(DEFAULT_BUYER_ADDRESS);
        vm.deal(DEFAULT_BUYER_ADDRESS, pricePaid);
        lockup.payToUnlock{value: priceToUnlock}(
            payable(address(cre8orsNFTBase)),
            tokenId
        );
        _assertIsLocked(tokenId, false);

        // Verify payment sent to base CRE8ORS
        assertEq(address(cre8orsNFTBase).balance, priceToUnlock);

        // Verify extra is refunded back to caller
        uint256 refund = pricePaid - priceToUnlock;
        assertEq(address(DEFAULT_BUYER_ADDRESS).balance, refund);
    }

    function test_payToUnlock_revert_Unlock_WrongPrice(
        uint256 tokenId,
        uint64 unlockDate,
        uint256 priceToUnlock,
        uint256 pricePaid
    ) public {
        // set assumptions in fuzzing
        uint64 start = uint64(block.timestamp);
        vm.assume(priceToUnlock > 0);
        vm.assume(unlockDate > start);
        vm.assume(pricePaid < priceToUnlock);
        _assertIsLocked(tokenId, false);

        // setup lock
        bytes memory data = abi.encode(unlockDate, priceToUnlock);
        vm.prank(DEFAULT_OWNER_ADDRESS);
        lockup.setUnlockInfo(address(cre8orsNFTBase), tokenId, data);

        // try to unlock
        vm.deal(DEFAULT_BUYER_ADDRESS, pricePaid);
        vm.startPrank(DEFAULT_BUYER_ADDRESS);
        bytes memory expectedRevertReason = abi.encodePacked(
            ILockup.Unlock_WrongPrice.selector,
            abi.encode(priceToUnlock)
        );
        vm.expectRevert(expectedRevertReason);
        lockup.payToUnlock{value: pricePaid}(
            payable(address(cre8orsNFTBase)),
            tokenId
        );

        // assert still locked
        _assertIsLocked(tokenId, true);
    }

    function test_toggleCre8ing(
        uint64 unlockDate,
        uint256 priceToUnlock
    ) public {
        uint64 start = uint64(block.timestamp);
        vm.assume(unlockDate < type(uint64).max);
        vm.assume(unlockDate > start);
        // Start cre8ing
        _cre8ingSetup();

        // Lock Cre8ing Tokens
        bytes memory data = abi.encode(unlockDate, priceToUnlock);
        vm.startPrank(DEFAULT_OWNER_ADDRESS);
        lockup.setUnlockInfo(address(cre8orsNFTBase), 1, data);
        cre8ingBase.setLockup(address(cre8orsNFTBase), lockup);
        assertTrue(lockup.isLocked(address(cre8orsNFTBase), 1));
        vm.stopPrank();

        // fast-forward to unlock date
        vm.warp(unlockDate);
        uint256[] memory tokenIds = new uint256[](1);
        tokenIds[0] = 1;

        // allow exit from warehouse
        cre8ingBase.toggleCre8ingTokens(address(cre8orsNFTBase), tokenIds);
        (bool cre8ing, uint256 current, uint256 total) = cre8ingBase
            .cre8ingPeriod(address(cre8orsNFTBase), 1);

        assertTrue(!cre8ing);
        assertEq(current, 0);
        assertEq(total, unlockDate - start);
    }

    function test_toggleCre8ing_revert_Lockup_Locked(
        uint64 unlockDate,
        uint256 priceToUnlock
    ) public {
        vm.assume(unlockDate > block.timestamp);

        // Start cre8ing
        _cre8ingSetup();

        // Lock Cre8ing Tokens
        bytes memory data = abi.encode(unlockDate, priceToUnlock);
        vm.startPrank(DEFAULT_OWNER_ADDRESS);
        lockup.setUnlockInfo(address(cre8orsNFTBase), 1, data);
        cre8ingBase.setLockup(address(cre8orsNFTBase), lockup);
        assertTrue(lockup.isLocked(address(cre8orsNFTBase), 1));
        vm.stopPrank();

        // Revert uncre8
        uint256[] memory tokenIds = new uint256[](1);
        tokenIds[0] = 1;
        vm.expectRevert(ILockup.Lockup_Locked.selector);
        cre8ingBase.toggleCre8ingTokens(address(cre8orsNFTBase), tokenIds);
    }

    function _cre8ingSetup() internal {
        uint256 _tokenId = 1;
        (bool cre8ing, uint256 current, uint256 total) = cre8ingBase
            .cre8ingPeriod(address(cre8orsNFTBase), _tokenId);
        assertTrue(!cre8ing);
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
        assertTrue(cre8ing);
        assertEq(current, 0);
        assertEq(total, 0);
    }

    function _assertLockup(
        uint256 _tokenId,
        uint64 _date,
        uint256 _price
    ) internal {
        assertEq(
            lockup.unlockInfo(address(cre8orsNFTBase), _tokenId).unlockDate,
            _date
        );
        assertEq(
            lockup.unlockInfo(address(cre8orsNFTBase), _tokenId).priceToUnlock,
            _price
        );
    }

    function _assertIsLocked(uint256 _tokenId, bool _expected) internal {
        assertTrue(
            _expected
                ? lockup.isLocked(address(cre8orsNFTBase), _tokenId)
                : !lockup.isLocked(address(cre8orsNFTBase), _tokenId)
        );
    }
}

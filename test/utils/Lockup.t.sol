// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import {Vm} from "forge-std/Vm.sol";
import {DSTest} from "ds-test/test.sol";
import {Lockup} from "../../src/utils/Lockup.sol";
import {ILockup} from "../../src/interfaces/ILockup.sol";
import {Cre8orTestBase} from "./Cre8orTestBase.sol";
import {IERC721Drop} from "../../src/interfaces/IERC721Drop.sol";

contract LockupTest is DSTest, Cre8orTestBase {
    Vm public constant vm = Vm(HEVM_ADDRESS);
    Lockup lockup = new Lockup();

    function setUp() public {
        vm.startPrank(DEFAULT_OWNER_ADDRESS);
        Cre8orTestBase.cre8orSetup();
        vm.stopPrank();
    }

    function test_lockup() public {
        assertEq(address(cre8orsNFTBase.lockup()), address(0));
    }

    function test_setLockup() public {
        assertEq(address(cre8orsNFTBase.lockup()), address(0));
        vm.prank(DEFAULT_OWNER_ADDRESS);
        cre8orsNFTBase.setLockup(lockup);
        assertEq(address(cre8orsNFTBase.lockup()), address(lockup));
    }

    function test_setLockup_revert_Access_OnlyAdmin() public {
        assertEq(address(cre8orsNFTBase.lockup()), address(0));
        vm.expectRevert(IERC721Drop.Access_OnlyAdmin.selector);
        cre8orsNFTBase.setLockup(lockup);
        assertEq(address(cre8orsNFTBase.lockup()), address(0));
    }

    function test_setUnlockDate(uint64 unlockDate) public {
        assertEq(lockup.unlockDate(address(cre8orsNFTBase), 1), 0);
        vm.prank(DEFAULT_OWNER_ADDRESS);
        lockup.setUnlockDate(address(cre8orsNFTBase), 1, unlockDate);
        assertEq(lockup.unlockDate(address(cre8orsNFTBase), 1), unlockDate);
    }

    function test_setUnlockDate_revert_Access_OnlyAdmin() public {
        assertEq(lockup.unlockDate(address(cre8orsNFTBase), 1), 0);
        vm.expectRevert(IERC721Drop.Access_OnlyAdmin.selector);
        lockup.setUnlockDate(address(cre8orsNFTBase), 1, type(uint64).max);
        assertEq(lockup.unlockDate(address(cre8orsNFTBase), 1), 0);
    }

    function test_isLocked(uint256 tokenId, uint64 unlockDate) public {
        assertTrue(!lockup.isLocked(address(cre8orsNFTBase), tokenId));
        vm.prank(DEFAULT_OWNER_ADDRESS);
        lockup.setUnlockDate(address(cre8orsNFTBase), tokenId, unlockDate);
        bool expectLocked = block.timestamp <
            lockup.unlockDate(address(cre8orsNFTBase), tokenId);

        assertTrue(
            expectLocked
                ? lockup.isLocked(address(cre8orsNFTBase), tokenId)
                : !lockup.isLocked(address(cre8orsNFTBase), tokenId)
        );
    }

    function test_toggleCre8ing(uint64 unlockDate) public {
        uint64 start = uint64(block.timestamp);
        vm.assume(unlockDate < type(uint64).max);
        vm.assume(unlockDate > start);
        // Start cre8ing
        _cre8ingSetup();

        // Lock Cre8ing Tokens
        vm.startPrank(DEFAULT_OWNER_ADDRESS);
        lockup.setUnlockDate(address(cre8orsNFTBase), 1, unlockDate);
        cre8orsNFTBase.setLockup(lockup);
        assertTrue(lockup.isLocked(address(cre8orsNFTBase), 1));
        vm.stopPrank();

        // fast-forward to unlock date
        vm.warp(unlockDate);
        uint256[] memory tokenIds = new uint256[](1);
        tokenIds[0] = 1;

        // allow exit from warehouse
        cre8orsNFTBase.toggleCre8ing(tokenIds);
        (bool cre8ing, uint256 current, uint256 total) = cre8orsNFTBase
            .cre8ingPeriod(1);
        assertTrue(!cre8ing);
        assertEq(current, 0);
        assertEq(total, unlockDate - start);
    }

    function test_toggleCre8ing_revert_Lockup_Locked(uint64 unlockDate) public {
        vm.assume(unlockDate > block.timestamp);

        // Start cre8ing
        _cre8ingSetup();

        // Lock Cre8ing Tokens
        vm.startPrank(DEFAULT_OWNER_ADDRESS);
        lockup.setUnlockDate(address(cre8orsNFTBase), 1, unlockDate);
        cre8orsNFTBase.setLockup(lockup);
        assertTrue(lockup.isLocked(address(cre8orsNFTBase), 1));
        vm.stopPrank();

        // Revert uncre8
        uint256[] memory tokenIds = new uint256[](1);
        tokenIds[0] = 1;
        vm.expectRevert(ILockup.Lockup_Locked.selector);
        cre8orsNFTBase.toggleCre8ing(tokenIds);
    }

    function _cre8ingSetup() internal {
        uint256 _tokenId = 1;
        (bool cre8ing, uint256 current, uint256 total) = cre8orsNFTBase
            .cre8ingPeriod(_tokenId);
        assertTrue(!cre8ing);
        assertEq(current, 0);
        assertEq(total, 0);
        cre8orsNFTBase.purchase(1);

        vm.prank(DEFAULT_OWNER_ADDRESS);
        cre8orsNFTBase.setCre8ingOpen(true);

        uint256[] memory tokenIds = new uint256[](1);
        tokenIds[0] = _tokenId;
        cre8orsNFTBase.toggleCre8ing(tokenIds);
        (cre8ing, current, total) = cre8orsNFTBase.cre8ingPeriod(_tokenId);
        assertTrue(cre8ing);
        assertEq(current, 0);
        assertEq(total, 0);
    }
}

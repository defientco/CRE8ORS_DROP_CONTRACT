// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import {Vm} from "forge-std/Vm.sol";
import {DSTest} from "ds-test/test.sol";
import {Lockup} from "../../src/utils/Lockup.sol";
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
}

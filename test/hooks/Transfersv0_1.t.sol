// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

// Forge Imports
import {DSTest} from "ds-test/test.sol";
// interface imports
import {ICre8ors} from "../../src/interfaces/ICre8ors.sol";
import {IERC721Drop} from "../../src/interfaces/IERC721Drop.sol";
import {IMinterUtilities} from "../../src/interfaces/IMinterUtilities.sol";
import {IERC721ACH} from "ERC721H/interfaces/IERC721ACH.sol";
// contract imports
import {Cre8ors} from "../../src/Cre8ors.sol";
import {Cre8orTestBase} from "../utils/Cre8orTestBase.sol";
import {FriendsAndFamilyMinter} from "../../src/minter/FriendsAndFamilyMinter.sol";
import {MinterUtilities} from "../../src/utils/MinterUtilities.sol";
import {Cre8ing} from "../../src/Cre8ing.sol";
import {TransferHookv0_1} from "../../src/hooks/Transfersv0_1.sol";

contract TransferHookv0_1Test is DSTest, Cre8orTestBase {
    FriendsAndFamilyMinter public minter;
    MinterUtilities public minterUtility;
    Cre8ing public cre8ingBase;
    TransferHookv0_1 transferHookv0_1;
    address public familyMinter = address(0x1234567);

    event Locked(uint256 tokenId);
    event Unlocked(uint256 tokenId);

    uint64 public constant ONE_YEAR_DURATION = 365 days;

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

        transferHookv0_1 = _setupTransferHook();

        cre8ingBase = new Cre8ing();
        vm.startPrank(DEFAULT_OWNER_ADDRESS);
        transferHookv0_1.setCre8ing(address(cre8ingBase));
        cre8ingBase.setCre8ingOpen(address(cre8orsNFTBase), true);
        vm.stopPrank();

        _setupErc6551();
    }

    function test_transferToSelf(uint256 _tokenId) public {
        _assumeUint256(_tokenId);

        vm.prank(DEFAULT_BUYER_ADDRESS);
        cre8orsNFTBase.purchase(_tokenId);

        // test - transfer to self toggles (locks) token
        _transferToSelf(DEFAULT_BUYER_ADDRESS, _tokenId);
        // test - transfer to self toggles (unlocks) token
        _transferToSelf(DEFAULT_BUYER_ADDRESS, _tokenId);
    }

    function test_4444() public {
        vm.prank(DEFAULT_OWNER_ADDRESS);

        for (; cre8orsNFTBase.totalSupply() < 4444; ) {
            cre8orsNFTBase.purchase(4);
        }

        assertEq(cre8orsNFTBase.totalSupply(), 4444);

        vm.expectRevert(ICre8ors.Cre8ors_4444.selector);
        cre8orsNFTBase.purchase(1);
    }

    /// HELPER FUNCTIONS ///
    function _transferToSelf(address _self, uint256 _tokenId) internal {
        vm.prank(_self);
        cre8orsNFTBase.transferFrom(_self, _self, _tokenId);
    }

    function _setMinterRole(address _assignee) internal {
        vm.startPrank(DEFAULT_OWNER_ADDRESS);
        cre8orsNFTBase.grantRole(
            cre8orsNFTBase.MINTER_ROLE(),
            address(_assignee)
        );
        vm.stopPrank();
    }

    function _expectLockedEmit(uint256 _tokenId) internal {
        vm.expectEmit(true, true, true, true);
        emit Locked(_tokenId);
    }

    function _expectUnlockedEmit(uint256 _tokenId) internal {
        vm.expectEmit(true, true, true, true);
        emit Unlocked(_tokenId);
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

        assertTrue(
            cre8orsNFTBase.hasRole(
                cre8orsNFTBase.MINTER_ROLE(),
                address(minter)
            )
        );
        vm.stopPrank();
    }

    function _setupTransferHook() internal returns (TransferHookv0_1) {
        transferHookv0_1 = new TransferHookv0_1(address(cre8orsNFTBase));
        _setMinterRole(address(transferHookv0_1));

        vm.startPrank(DEFAULT_OWNER_ADDRESS);
        // set hook
        cre8orsNFTBase.setHook(
            IERC721ACH.HookType.BeforeTokenTransfers,
            address(transferHookv0_1)
        );
        cre8orsNFTBase.setHook(
            IERC721ACH.HookType.AfterTokenTransfers,
            address(transferHookv0_1)
        );
        vm.stopPrank();

        return transferHookv0_1;
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

// Forge Imports
import {DSTest} from "ds-test/test.sol";
// interface imports
import {ICre8ors} from "../../src/interfaces/ICre8ors.sol";
import {IERC721ACH} from "ERC721H/interfaces/IERC721ACH.sol";
// contract imports
import {Cre8orTestBase} from "../utils/Cre8orTestBase.sol";
import {TransferHookv0_2} from "../../src/hooks/Transfersv0_2.sol";

contract TransferHookv0_2Test is DSTest, Cre8orTestBase {
    TransferHookv0_2 hook;

    uint64 public constant ONE_YEAR_DURATION = 365 days;

    function setUp() public {
        // setup base cre8ors
        Cre8orTestBase.cre8orSetup();
        // setup hooks
        hook = _setupTransferHook();
        // setup ERC6551
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

    /// SETUP CONTRACT FUNCTIONS ///

    function _setupTransferHook() internal returns (TransferHookv0_2) {
        hook = new TransferHookv0_2();

        vm.startPrank(DEFAULT_OWNER_ADDRESS);
        // set hook
        cre8orsNFTBase.setHook(
            IERC721ACH.HookType.BeforeTokenTransfers,
            address(hook)
        );
        vm.stopPrank();

        return hook;
    }
}

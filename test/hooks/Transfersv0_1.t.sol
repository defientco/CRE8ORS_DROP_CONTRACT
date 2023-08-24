// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

// Forge Imports
import {DSTest} from "ds-test/test.sol";
// interface imports
import {ICre8ors} from "../../src/interfaces/ICre8ors.sol";
import {IERC721ACH} from "ERC721H/interfaces/IERC721ACH.sol";
// contract imports
import {Cre8orTestBase} from "../utils/Cre8orTestBase.sol";
import {Cre8ing} from "../../src/Cre8ing.sol";
import {TransferHookv0_1} from "../../src/hooks/Transfersv0_1.sol";
import {IERC721Drop} from "../../src/interfaces/IERC721Drop.sol";

contract TransferHookv0_1Test is DSTest, Cre8orTestBase {
    Cre8ing public cre8ingBase;
    TransferHookv0_1 transferHookv0_1;

    uint64 public constant ONE_YEAR_DURATION = 365 days;

    function setUp() public {
        // setup base cre8ors
        Cre8orTestBase.cre8orSetup();
        // setup staking
        cre8ingBase = new Cre8ing();
        // setup hooks
        transferHookv0_1 = _setupTransferHook();
        vm.startPrank(DEFAULT_OWNER_ADDRESS);
        cre8ingBase.setCre8ingOpen(address(cre8orsNFTBase), true);
        vm.stopPrank();
        // setup ERC6551
        _setupErc6551();
    }

    function test_cre8ing_revert_Access_OnlyAdmin(address _newCre8ing) public {
        _assertCre8ing(address(cre8ingBase));

        vm.expectRevert(IERC721Drop.Access_OnlyAdmin.selector);
        _setCre8ing(_newCre8ing);

        _assertCre8ing(address(cre8ingBase));
    }

    function test_cre8ing(address _newCre8ing) public {
        _assertCre8ing(address(cre8ingBase));

        vm.prank(DEFAULT_OWNER_ADDRESS);
        _setCre8ing(_newCre8ing);

        _assertCre8ing(_newCre8ing);
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

    /// SETUP CONTRACT FUNCTIONS ///

    function _setupTransferHook() internal returns (TransferHookv0_1) {
        transferHookv0_1 = new TransferHookv0_1(
            address(cre8orsNFTBase),
            address(cre8ingBase)
        );
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

    function _assertCre8ing(address _cre8ing) internal {
        assertEq(transferHookv0_1.cre8ing(), _cre8ing);
    }

    function _setCre8ing(address _newCre8ing) internal {
        transferHookv0_1.setCre8ing(_newCre8ing);
    }
}

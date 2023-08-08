// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import {DSTest} from "ds-test/test.sol";
import {Cre8ors} from "../../src/Cre8ors.sol";
import {IERC721Drop} from "../../src/interfaces/IERC721Drop.sol";
import {IERC721A} from "lib/ERC721A/contracts/IERC721A.sol";
import {ERC6551Registry} from "lib/ERC6551/src/ERC6551Registry.sol";
import {Account} from "lib/tokenbound/src/Account.sol";
import {Cre8ing} from "../../src/Cre8ing.sol";
import {TransferHook} from "../../src/hooks/Transfers.sol";
import {Cre8orTestBase} from "./Cre8orTestBase.sol";
import {IERC721ACH} from "ERC721H/interfaces/IERC721ACH.sol";
import {IERC6551Registry} from "lib/ERC6551/src/interfaces/IERC6551Registry.sol";
import {Subscription} from "../../src/subscription/Subscription.sol";
import {DNAMinter} from "../../src/minter/DNAMinter.sol";
import {IAccessControl} from "@openzeppelin/contracts/access/IAccessControl.sol";
import "forge-std/console.sol";

error NotAuthorized();

contract DNATest is DSTest, Cre8orTestBase {
    Cre8ing public cre8ingBase;
    address constant DEAD_ADDRESS =
        address(0x000000000000000000000000000000000000dEaD);
    Subscription public subscription;
    Cre8ors dna;
    DNAMinter dnaMinter;
    bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;

    function setUp() public {
        Cre8orTestBase.cre8orSetup();
        dna = _deployCre8or();
        _setupErc6551();
        dnaMinter = new DNAMinter(
            address(cre8orsNFTBase),
            address(dna),
            address(erc6551Registry),
            address(erc6551Implementation)
        );
    }

    function test_Erc6551Registry() public {
        address tokenBoundAccount = getTBA(1);
        assertTrue(!isContract(tokenBoundAccount));
    }

    function test_setErc6551Registry_revert_Access_OnlyAdmin() public {
        vm.expectRevert(IERC721Drop.Access_OnlyAdmin.selector);
        dnaMinter.setErc6551Registry(address(erc6551Registry));
    }

    function test_setErc6551Implementation_revert_Access_OnlyAdmin() public {
        vm.expectRevert(IERC721Drop.Access_OnlyAdmin.selector);
        dnaMinter.setErc6551Implementation(address(erc6551Implementation));
    }

    function test_createAccountAndMintDNA(uint256 _quantity) public {
        _assumeReasonableNumber(_quantity);

        // MINT NFTs on CRE8ORS
        _cre8orsPurchase(_quantity);

        // Registers with ERC6551 & mint DNA to TBA
        _createTbaAndMint(_quantity);
    }

    function _grantDnaMinterAdminRole() internal {
        vm.prank(DEFAULT_OWNER_ADDRESS);
        IAccessControl(address(dna)).grantRole(
            DEFAULT_ADMIN_ROLE,
            address(dnaMinter)
        );
    }

    function _createTbaAndMint(
        uint256 _tokenId
    ) internal returns (address tokenBoundAccount) {
        // Grant Role
        _grantDnaMinterAdminRole();

        // Setup TBA & mint DNA
        tokenBoundAccount = getTBA(_tokenId);
        assertTrue(!isContract(tokenBoundAccount));
        uint256 _dnaTokenId = dnaMinter.createTokenBoundAccountAndMintDNA(
            _tokenId
        );

        // Assertions
        assertTrue(isContract(tokenBoundAccount));
        assertEq(dna.ownerOf(_dnaTokenId), tokenBoundAccount);
    }

    function test_sendWithTBA(
        uint256 _initialQuantity,
        uint256 _smartWalletQuantity
    ) public {
        _assumeReasonableNumber(_initialQuantity);
        _assumeReasonableNumber(_smartWalletQuantity);

        // Mint Cre8or
        _cre8orsPurchase(_initialQuantity);

        // Create TBA and mint DNA card
        address payable tokenBoundAccount = payable(
            _createTbaAndMint(_initialQuantity)
        );

        // Transfer DNA card out of TBA
        _transferDnaCardFromTBA(tokenBoundAccount);
    }

    function _transferDnaCardFromTBA(
        address payable tokenBoundAccount
    ) internal {
        assertEq(dna.balanceOf(tokenBoundAccount), 1);
        uint256 value;
        bytes memory data = abi.encodeWithSignature(
            "safeTransferFrom(address,address,uint256)",
            tokenBoundAccount,
            msg.sender,
            1
        );
        Account(tokenBoundAccount).executeCall(address(dna), value, data);
        assertEq(dna.balanceOf(tokenBoundAccount), 0);
    }

    function _assumeReasonableNumber(uint256 _num) internal pure {
        vm.assume(_num > 0);
        vm.assume(_num < 18);
    }

    function _cre8orsPurchase(uint256 _quantity) internal {
        cre8orsNFTBase.purchase(_quantity);
    }

    function test_sendWithTBA_revert_NotAuthorized(
        uint256 _initialQuantity,
        uint256 _smartWalletQuantity
    ) public {
        _assumeReasonableNumber(_initialQuantity);
        _assumeReasonableNumber(_smartWalletQuantity);

        // Mint Cre8or
        _cre8orsPurchase(_initialQuantity);

        // Create TBA and mint DNA card
        address payable tokenBoundAccount = payable(
            _createTbaAndMint(_initialQuantity)
        );

        // TBA used to mint another CRE8OR
        _revertTbaTransferNotAuthorized(tokenBoundAccount);
    }

    function _revertTbaTransferNotAuthorized(
        address payable tokenBoundAccount
    ) internal {
        assertEq(dna.balanceOf(tokenBoundAccount), 1);
        uint256 value;
        bytes memory data = abi.encodeWithSignature(
            "safeTransferFrom(address,address,uint256)",
            tokenBoundAccount,
            msg.sender,
            1
        );
        vm.expectRevert(NotAuthorized.selector);
        vm.prank(DEFAULT_OWNER_ADDRESS);
        Account(tokenBoundAccount).executeCall(address(dna), value, data);
        assertEq(dna.balanceOf(tokenBoundAccount), 1);
    }

    // TODO - UNIT TEST TO VERIFY AIRDROP FAILURE IF TBA ALREADY HAS MINTED DNA CARD

    function _setMinterRole(address _assignee) internal {
        vm.startPrank(DEFAULT_OWNER_ADDRESS);
        cre8orsNFTBase.grantRole(
            cre8orsNFTBase.MINTER_ROLE(),
            address(_assignee)
        );
        vm.stopPrank();
    }

    function _setupSubscriptionContract(
        Cre8ors cre8orsNFT_
    ) internal returns (Subscription _subscription) {
        _subscription = new Subscription({
            cre8orsNFT_: address(cre8orsNFT_),
            minRenewalDuration_: 1 days,
            pricePerSecond_: 38580246913 // Roughly calculates to 0.1 ether per 30 days
        });
    }

    function _setupTransferHook() internal returns (TransferHook) {
        transferHook = new TransferHook(
            address(cre8orsNFTBase),
            address(erc6551Registry),
            address(erc6551Implementation)
        );
        _setMinterRole(address(transferHook));

        vm.startPrank(DEFAULT_OWNER_ADDRESS);
        // set hook
        cre8orsNFTBase.setHook(
            IERC721ACH.HookType.AfterTokenTransfers,
            address(transferHook)
        );
        // set subscription
        transferHook.setSubscription(
            address(cre8orsNFTBase),
            address(subscription)
        );
        vm.stopPrank();

        return transferHook;
    }
}

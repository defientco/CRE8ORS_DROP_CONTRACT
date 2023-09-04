// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import {DSTest} from "ds-test/test.sol";
import {Cre8ors} from "../../src/Cre8ors.sol";
import {IERC721Drop} from "../../src/interfaces/IERC721Drop.sol";
import {IERC721A} from "lib/ERC721A/contracts/IERC721A.sol";
import {ERC6551Registry} from "lib/ERC6551/src/ERC6551Registry.sol";
import {Account} from "lib/tokenbound/src/Account.sol";
import {IERC6551Registry} from "lib/ERC6551/src/interfaces/IERC6551Registry.sol";
import {Cre8orTestBase} from "../utils/Cre8orTestBase.sol";
import {AffiliateMinter} from "../../src/minter/AffiliateMinter.sol";
import "forge-std/console.sol";

contract AffiliateMinterTest is DSTest, Cre8orTestBase {
    AffiliateMinter affiliateMinter;

    function setUp() public {
        Cre8orTestBase.cre8orSetup();
        _setupErc6551();
        affiliateMinter = new AffiliateMinter(
            address(cre8orsNFTBase),
            address(erc6551Registry),
            address(erc6551Implementation),
            20
        );
    }

    function test_Erc6551Registry() public {
        address tokenBoundAccount = getTBA(1);
        assertTrue(!isContract(tokenBoundAccount));
    }

    function test_setErc6551Registry_revert_Access_OnlyAdmin() public {
        vm.expectRevert(IERC721Drop.Access_OnlyAdmin.selector);
        affiliateMinter.setRegistryAddress(address(erc6551Registry));
    }

    function test_setErc6551Implementation_revert_Access_OnlyAdmin() public {
        vm.expectRevert(IERC721Drop.Access_OnlyAdmin.selector);
        affiliateMinter.setAccountImplementationAddress(
            address(erc6551Implementation)
        );
    }

    function test_setReferralFee_revert_Access_OnlyAdmin() public {
        vm.expectRevert(IERC721Drop.Access_OnlyAdmin.selector);
        affiliateMinter.setReferralFee(20);
    }

    function test_setInvalidFee_revertInvalidFee(uint256 _fee) public {
        vm.assume(_fee > 100 || _fee < 0);
        vm.prank(DEFAULT_OWNER_ADDRESS);
        vm.expectRevert(AffiliateMinter.InvalidFee.selector);
        affiliateMinter.setReferralFee(_fee);
    }

    function test_Mint_revertMissingSmartWallet(
        uint256 _quantity,
        address recipient
    ) public {
        _assumeUint256(_quantity);
        _assumeReasonableBuyer(recipient);
        _grantAffiliateMinterMinterRole();

        cre8orsNFTBase.purchase(1);
        vm.expectRevert(AffiliateMinter.MissingSmartWallet.selector);
        affiliateMinter.mint(recipient, 1, _quantity);
    }

    function test_Mint_revertWrongPrice(
        uint256 _quantity,
        address recipient
    ) public {
        _assumeUint256(_quantity);
        _assumeReasonableBuyer(recipient);
        _grantAffiliateMinterMinterRole();
        _setUpSmartWallet();
        _setNewPrice(0.05 ether);
        uint256 correctPrice = (0.05 ether * _quantity);
        vm.expectRevert(
            abi.encodeWithSelector(
                IERC721Drop.Purchase_WrongPrice.selector,
                correctPrice
            )
        );
        affiliateMinter.mint(recipient, 1, _quantity);
    }

    function test_Mint_Success(uint256 _quantity, address recipient) public {
        _assumeUint256(_quantity);
        _assumeReasonableBuyer(recipient);
        _grantAffiliateMinterMinterRole();
        _setUpSmartWallet();
        _setNewPrice(0.05 ether);
        uint256 correctPrice = (0.05 ether * _quantity);
        vm.deal(msg.sender, correctPrice);
        affiliateMinter.mint{value: correctPrice}(recipient, 1, _quantity);
        assertEq(
            _quantity,
            cre8orsNFTBase.mintedPerAddress(recipient).totalMints
        );
    }

    function test_Mint_Success_CorrectReferralFeePaidOut(
        uint256 _quantity,
        address recipient
    ) public {
        _assumeUint256(_quantity);
        _assumeReasonableBuyer(recipient);
        _grantAffiliateMinterMinterRole();
        _setUpSmartWallet();
        _setNewPrice(0.05 ether);
        address referrer = getTBA(1);
        uint256 correctPrice = (0.05 ether * _quantity);
        uint256 referralFeePaidOut = (correctPrice *
            affiliateMinter.referralFee()) / 100;

        // verify no balance before referral payout
        assertEq(referrer.balance, 0);

        // mint with referral
        vm.deal(msg.sender, correctPrice);
        affiliateMinter.mint{value: correctPrice}(recipient, 1, _quantity);

        assertEq(
            _quantity,
            cre8orsNFTBase.mintedPerAddress(recipient).totalMints
        );
        // verify referral fee paid
        assertEq(referrer.balance, referralFeePaidOut);
        assertEq(
            correctPrice - referralFeePaidOut,
            address(cre8orsNFTBase).balance
        );
    }

    function _assumeReasonableBuyer(address _buyer) internal pure {
        vm.assume(_buyer != address(0));
    }

    function _grantAffiliateMinterMinterRole() internal {
        vm.startPrank(DEFAULT_OWNER_ADDRESS);
        cre8orsNFTBase.grantRole(
            cre8orsNFTBase.MINTER_ROLE(),
            address(affiliateMinter)
        );
        vm.stopPrank();
    }

    function _setNewPrice(uint256 _publicPrice) internal {
        vm.startPrank(DEFAULT_OWNER_ADDRESS);
        (
            ,
            address _erc20PaymentToken,
            uint32 _maxSalePurchasePerAddress,
            uint64 _publicSaleStart,
            uint64 _publicSaleEnd,
            uint64 _presaleStart,
            uint64 _presaleEnd,
            bytes32 _merkleRoot
        ) = cre8orsNFTBase.salesConfig();

        cre8orsNFTBase.setSaleConfiguration(
            _erc20PaymentToken,
            uint104(_publicPrice),
            _maxSalePurchasePerAddress,
            _publicSaleStart,
            _publicSaleEnd,
            _presaleStart,
            _presaleEnd,
            _merkleRoot
        );
        vm.stopPrank();
    }

    function _setUpSmartWallet() internal {
        vm.prank(DEFAULT_OWNER_ADDRESS);
        cre8orsNFTBase.purchase(1);
        IERC6551Registry(address(erc6551Registry)).createAccount(
            address(erc6551Implementation),
            block.chainid,
            address(cre8orsNFTBase),
            1,
            0,
            "0x8129fc1c"
        );
    }
}

//SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;
// Forge Imports
import {DSTest} from "ds-test/test.sol";

import {StdUtils} from "forge-std/StdUtils.sol";
import {Vm} from "forge-std/Vm.sol";
// interface imports
import {ICre8ors} from "../../src/interfaces/ICre8ors.sol";
import {IERC721A} from "../../lib/ERC721A/contracts/interfaces/IERC721A.sol";
import {IERC721Drop} from "../../src/interfaces/IERC721Drop.sol";
import {IMinterUtilities} from "../../src/interfaces/IMinterUtilities.sol";
import {ILockup} from "../../src/interfaces/ILockup.sol";
import {IPaidMinter} from "../../src/interfaces/IPaidMinter.sol";
import {IERC721ACH} from "ERC721H/interfaces/IERC721ACH.sol";
// contract imports
import {Cre8ors} from "../../src/Cre8ors.sol";
import {Cre8orTestBase} from "../utils/Cre8orTestBase.sol";
import {DummyMetadataRenderer} from "../utils/DummyMetadataRenderer.sol";
import {FreeMinter} from "../../src/minter/FreeMinter.sol";
import {Lockup} from "../../src/utils/Lockup.sol";
import {MinterUtilities} from "../../src/utils/MinterUtilities.sol";
import {PaidMinter} from "../../src/minter/PaidMinter.sol";
import {MerkleData} from "../merkle/MerkleData.sol";
import {Cre8ing} from "../../src/Cre8ing.sol";
import {OwnerOfHook} from "../../src/hooks/OwnerOf.sol";
import {TransferHook} from "../../src/hooks/Transfers.sol";
import {Subscription} from "../../src/subscription/Subscription.sol";
import {IERC721ACH} from "ERC721H/interfaces/IERC721ACH.sol";
import {Cre8orTestBase} from "../utils/Cre8orTestBase.sol";

contract PaidMinterTest is DSTest, Cre8orTestBase {
    Cre8ing public cre8ingBase;
    Cre8ors public cre8orsPassport;
    MinterUtilities public minterUtility;
    FreeMinter public freeMinter;
    PaidMinter public minter;
    MerkleData public merkleData;
    TransferHook public transferHookCre8orsPassport;
    Lockup lockup = new Lockup();

    OwnerOfHook public ownerOfHook;
    Subscription public subscription;

    uint64 public constant ONE_YEAR_DURATION = 365 days;

    function setUp() public {
        cre8orsNFTBase = _setUpContracts();
        cre8orsPassport = _setUpContracts();
        minterUtility = new MinterUtilities(
            address(cre8orsNFTBase),
            50000000000000000,
            100000000000000000,
            150000000000000000
        );
        freeMinter = new FreeMinter(
            address(cre8orsNFTBase),
            address(cre8orsPassport),
            new uint256[](0),
            new address[](0)
        );

        cre8ingBase = new Cre8ing();
        minter = new PaidMinter(
            address(cre8orsNFTBase),
            address(minterUtility),
            address(freeMinter)
        );

        subscription = _setupSubscription();

        transferHook = _setupTransferHook();
        ownerOfHook = _setupOwnerOfHook();

        vm.startPrank(DEFAULT_OWNER_ADDRESS);
        vm.stopPrank();

        merkleData = new MerkleData();

        _setupErc6551();
    }

    function testLockup() public {
        assertEq(
            address(cre8ingBase.lockup(address(cre8orsNFTBase))),
            address(0)
        );
    }

    function testSuccess() public {
        uint256[] memory _carts = new uint256[](3);
        _carts[0] = bound(_carts[0], 1, 8);
        _carts[1] = 0;
        _carts[2] = 0;
        _setUpMinter();
        _updateMerkleRoot();
        vm.assume(
            IMinterUtilities(address(minterUtility)).calculateTotalQuantity(
                _carts
            ) < 18
        );

        MerkleData.MerkleEntry memory item;
        item = merkleData.getTestSetByName("test-allowlist-minter").entries[0];
        uint256 totalQuantity = IMinterUtilities(address(minterUtility))
            .calculateTotalQuantity(_carts);
        uint256 totalPrice = IMinterUtilities(address(minterUtility))
            .calculateTotalCost(_carts);

        vm.deal(item.user, totalPrice);
        vm.startPrank(item.user);
        uint256 tokenId = minter.mint{value: totalPrice}(
            item.user,
            _carts,
            item.proof
        );
        vm.stopPrank();
        assertEq(totalQuantity, tokenId);
        assertEq(
            totalQuantity,
            cre8orsNFTBase.mintedPerAddress(DEFAULT_BUYER_ADDRESS).totalMints
        );

        // Subscription Asserts
        assertTrue(subscription.isSubscriptionValid(tokenId));

        // 1 year passed
        vm.warp(block.timestamp + ONE_YEAR_DURATION);

        // ownerOf should return address(0)
        assertEq(cre8orsNFTBase.ownerOf(tokenId), address(0));
        assertTrue(!subscription.isSubscriptionValid(tokenId));
    }

    function testRevertNotWhiteListApproved() public {
        uint256[] memory _carts = new uint256[](3);
        _carts[0] = bound(_carts[0], 1, 4);
        _carts[1] = bound(_carts[0], 1, 3);
        _carts[2] = bound(_carts[0], 1, 3);
        _setUpMinter();
        _updateMerkleRoot();

        MerkleData.MerkleEntry memory item;
        item = merkleData.getTestSetByName("test-allowlist-minter").entries[0];
        uint256 totalPrice = IMinterUtilities(address(minterUtility))
            .calculateTotalCost(_carts);

        vm.deal(address(0x25), totalPrice);
        vm.prank(address(0x25));
        vm.expectRevert(IERC721Drop.Presale_MerkleNotApproved.selector);
        minter.mint{value: totalPrice}(address(0x25), _carts, item.proof);

        // Subscription Asserts
        _revertCaseAssertionsForSubscriptions();
    }

    function testRevertTooMuchQuantity() public {
        _updateMerkleRoot();
        uint256[] memory _carts = new uint256[](3);
        _carts[0] = bound(_carts[0], 18, 28);
        _carts[1] = bound(_carts[0], 18, 28);
        _carts[2] = bound(_carts[0], 18, 28);
        _setUpMinter();

        MerkleData.MerkleEntry memory item;
        item = merkleData.getTestSetByName("test-allowlist-minter").entries[0];
        uint256 totalPrice = IMinterUtilities(address(minterUtility))
            .calculateTotalCost(_carts);

        vm.deal(item.user, totalPrice);
        vm.prank(item.user);
        vm.expectRevert(IERC721Drop.Purchase_TooManyForAddress.selector);
        minter.mint{value: totalPrice}(item.user, _carts, item.proof);

        // Subscription Asserts
        _revertCaseAssertionsForSubscriptions();
    }

    function testRevertEmptyCarts() public {
        _setUpMinter();
        _updateMerkleRoot();
        uint256[] memory _carts = new uint256[](3);

        MerkleData.MerkleEntry memory item;
        item = merkleData.getTestSetByName("test-allowlist-minter").entries[0];
        uint256 totalPrice = IMinterUtilities(address(minterUtility))
            .calculateTotalCost(_carts);

        vm.deal(item.user, totalPrice);
        vm.prank(item.user);
        vm.expectRevert(IERC721A.MintZeroQuantity.selector);
        minter.mint{value: totalPrice}(item.user, _carts, item.proof);
    }

    function testInvalidArrayLengthExist(uint256[] memory _carts) public {
        vm.assume(_carts.length != 3);
        _setUpMinter();
        _updateMerkleRoot();

        MerkleData.MerkleEntry memory item;
        item = merkleData.getTestSetByName("test-allowlist-minter").entries[0];
        vm.expectRevert(IPaidMinter.InvalidArrayLength.selector);
        vm.prank(item.user);
        minter.mint{value: 0 ether}(item.user, _carts, item.proof);

        // Subscription Asserts
        _revertCaseAssertionsForSubscriptions();
    }

    function testRevertPresaleInactiveNotOnCre8orsList(address _buyer) public {
        vm.assume(_buyer != address(0x0));
        uint256[] memory _carts = new uint256[](3);
        _carts[0] = bound(_carts[0], 1, 4);
        _carts[1] = bound(_carts[0], 1, 3);
        _carts[2] = bound(_carts[0], 1, 3);
        _setUpMinter();
        for (uint i = 0; i < _carts.length; i++) {
            _carts[i] = bound(_carts[i], 1, 8);
        }
        _updatePresaleStart(uint64(block.timestamp + 1000));

        bytes32[] memory proof = new bytes32[](0);
        uint256 totalPrice = IMinterUtilities(address(minterUtility))
            .calculateTotalCost(_carts);
        vm.deal(_buyer, totalPrice);
        vm.expectRevert(IERC721Drop.Presale_Inactive.selector);
        vm.prank(_buyer);
        minter.mint{value: totalPrice}(_buyer, _carts, proof);

        // Subscription Asserts
        _revertCaseAssertionsForSubscriptions();
    }

    function testRevertPresaleInactiveOnCre8orsList() public {
        uint256[] memory _carts = new uint256[](3);
        _carts[0] = bound(_carts[0], 1, 4);
        _carts[1] = bound(_carts[0], 1, 3);
        _carts[2] = bound(_carts[0], 1, 3);
        _setUpMinter();

        _updateMerkleRoot();
        _updatePresaleStart(uint64(block.timestamp + 1000));
        MerkleData.MerkleEntry memory item;
        item = merkleData.getTestSetByName("test-allowlist-minter").entries[0];
        uint256 totalPrice = IMinterUtilities(address(minterUtility))
            .calculateTotalCost(_carts);
        vm.deal(item.user, totalPrice);
        vm.expectRevert(IERC721Drop.Presale_Inactive.selector);
        vm.prank(item.user);
        minter.mint{value: totalPrice}(item.user, _carts, item.proof);

        // Subscription Asserts
        _revertCaseAssertionsForSubscriptions();
    }

    function testSuccessClaimDiscountPreSaleInactiveOnCre8orsList() public {
        _updateMerkleRoot();
        _updatePresaleStart(uint64(block.timestamp + 1000));
        _setUpMinter();
        uint256[] memory _carts = new uint256[](3);
        _carts[0] = bound(_carts[0], 1, 4);
        _carts[1] = bound(_carts[0], 1, 3);
        _carts[2] = bound(_carts[0], 1, 3);
        MerkleData.MerkleEntry memory item;
        item = merkleData.getTestSetByName("test-allowlist-minter").entries[0];
        vm.startPrank(item.user);
        cre8orsPassport.purchase(1);
        uint256[] memory _ids = new uint256[](1);
        _ids[0] = 1;
        freeMinter.mint(_ids, item.user);
        uint256 totalPrice = IMinterUtilities(address(minterUtility))
            .calculateTotalCost(_carts);

        assertTrue(
            !IERC721Drop(address(cre8orsNFTBase)).saleDetails().presaleActive
        );
        vm.deal(item.user, totalPrice);
        uint256 mintPFPId = minter.mint{value: totalPrice}(
            item.user,
            _carts,
            item.proof
        );
        vm.stopPrank();
        assertEq(mintPFPId, _carts[0] + _carts[1] + _carts[2] + 1);

        // Subscription Asserts
        assertTrue(subscription.isSubscriptionValid(mintPFPId));

        // 1 year passed
        vm.warp(block.timestamp + ONE_YEAR_DURATION);

        // ownerOf should return address(0)
        assertEq(cre8orsNFTBase.ownerOf(mintPFPId), address(0));
        assertTrue(!subscription.isSubscriptionValid(mintPFPId));
    }

    /// Public Minting Tests ///

    function testSuccessPublic(address _buyer) public {
        uint256[] memory _carts = new uint256[](3);
        _carts[0] = bound(_carts[0], 1, 8);
        _carts[1] = 0;
        _carts[2] = 0;
        vm.assume(_buyer != address(0));
        _setUpMinter();
        vm.assume(
            IMinterUtilities(address(minterUtility)).calculateTotalQuantity(
                _carts
            ) < 18
        );
        uint256 totalQuantity = IMinterUtilities(address(minterUtility))
            .calculateTotalQuantity(_carts);
        uint256 totalPrice = IMinterUtilities(address(minterUtility))
            .calculateTotalCost(_carts);

        vm.deal(_buyer, totalPrice);
        vm.startPrank(_buyer);
        uint256 tokenId = minter.mint{value: totalPrice}(_buyer, _carts);
        vm.stopPrank();
        assertEq(totalQuantity, tokenId);
        assertEq(
            totalQuantity,
            cre8orsNFTBase.mintedPerAddress(_buyer).totalMints
        );

        // Subscription Asserts
        assertTrue(subscription.isSubscriptionValid(tokenId));

        // 1 year passed
        vm.warp(block.timestamp + ONE_YEAR_DURATION);

        // ownerOf should return address(0)
        assertEq(cre8orsNFTBase.ownerOf(tokenId), address(0));
        assertTrue(!subscription.isSubscriptionValid(tokenId));
    }

    function testPublicSaleInactiveMintedDiscount(address _buyer) public {
        uint256[] memory _carts = new uint256[](3);
        _carts[0] = bound(_carts[0], 1, 8);
        _carts[1] = 0;
        _carts[2] = 0;
        vm.assume(_buyer != address(0));
        _setUpMinter();
        _updatePublicSaleStart(uint64(block.timestamp + 1000));
        vm.assume(
            IMinterUtilities(address(minterUtility)).calculateTotalQuantity(
                _carts
            ) < 8
        );
        vm.startPrank(DEFAULT_OWNER_ADDRESS);
        cre8orsNFTBase.grantRole(
            cre8orsNFTBase.DEFAULT_ADMIN_ROLE(),
            address(freeMinter)
        );
        address[] memory _buyers = new address[](1);
        _buyers[0] = _buyer;
        uint256[] memory _ids = new uint256[](0);
        freeMinter.addDiscount(_buyers);
        vm.stopPrank();
        vm.startPrank(_buyer);
        freeMinter.mint(_ids, _buyer);
        vm.stopPrank();
        uint256 totalQuantity = IMinterUtilities(address(minterUtility))
            .calculateTotalQuantity(_carts);
        uint256 totalPrice = IMinterUtilities(address(minterUtility))
            .calculateTotalCost(_carts);

        vm.deal(_buyer, totalPrice);
        vm.startPrank(_buyer);
        uint256 tokenId = minter.mint{value: totalPrice}(_buyer, _carts);
        vm.stopPrank();
        assertEq(totalQuantity + 1, tokenId);
        assertEq(
            totalQuantity + 1,
            cre8orsNFTBase.mintedPerAddress(_buyer).totalMints
        );

        // Subscription Asserts
        assertTrue(subscription.isSubscriptionValid(tokenId));

        // 1 year passed
        vm.warp(block.timestamp + ONE_YEAR_DURATION);

        // ownerOf should return address(0)
        assertEq(cre8orsNFTBase.ownerOf(tokenId), address(0));
        assertTrue(!subscription.isSubscriptionValid(tokenId));
    }

    function testRevertPublicSaleInactive(address _buyer) public {
        uint256[] memory _carts = new uint256[](3);
        _carts[0] = bound(_carts[0], 1, 8);
        _carts[1] = 0;
        _carts[2] = 0;
        vm.assume(_buyer != address(0));
        _setUpMinter();
        _updatePublicSaleStart(uint64(block.timestamp + 1000));

        vm.assume(
            IMinterUtilities(address(minterUtility)).calculateTotalQuantity(
                _carts
            ) < 8
        );

        uint256 totalPrice = IMinterUtilities(address(minterUtility))
            .calculateTotalCost(_carts);

        vm.deal(_buyer, totalPrice);
        vm.startPrank(_buyer);
        vm.expectRevert(IERC721Drop.Sale_Inactive.selector);
        uint256 tokenId = minter.mint{value: totalPrice}(_buyer, _carts);
        vm.stopPrank();

        assertTrue(!subscription.isSubscriptionValid(tokenId));
        assertEq(cre8orsNFTBase.ownerOf(tokenId), address(0));
    }

    /// HELPERS ///

    function _revertCaseAssertionsForSubscriptions() internal {
        // Due to Revert there will be no tokenId.
        // Using 1 as token, considering it is a FIRST MINT to VERIFY Subscription
        uint256 tokenId = 1;

        assertTrue(!subscription.isSubscriptionValid(tokenId));
        assertEq(cre8orsNFTBase.ownerOf(tokenId), address(0));
    }

    function _setUpContracts() internal returns (Cre8ors) {
        return
            new Cre8ors({
                _contractName: "CRE8ORS",
                _contractSymbol: "CRE8",
                _initialOwner: DEFAULT_OWNER_ADDRESS,
                _fundsRecipient: payable(DEFAULT_FUNDS_RECIPIENT_ADDRESS),
                _editionSize: DEFAULT_EDITION_SIZE,
                _royaltyBPS: DEFAULT_ROYALTY_BPS,
                _metadataRenderer: dummyRenderer,
                _salesConfig: IERC721Drop.SalesConfiguration({
                    publicSaleStart: 0,
                    erc20PaymentToken: address(0),
                    publicSaleEnd: type(uint64).max,
                    presaleStart: 0,
                    presaleEnd: 0,
                    publicSalePrice: 0,
                    maxSalePurchasePerAddress: 0,
                    presaleMerkleRoot: bytes32(0)
                })
            });
    }

    function _setUpMinter() internal {
        vm.startPrank(DEFAULT_OWNER_ADDRESS);
        cre8orsNFTBase.grantRole(cre8orsNFTBase.MINTER_ROLE(), address(minter));
        cre8orsNFTBase.grantRole(
            cre8orsNFTBase.MINTER_ROLE(),
            address(freeMinter)
        );
        cre8orsNFTBase.grantRole(
            cre8orsNFTBase.MINTER_ROLE(),
            address(cre8ingBase)
        );
        cre8ingBase.setCre8ingOpen(address(cre8orsNFTBase), true);
        cre8orsNFTBase.grantRole(
            cre8orsNFTBase.MINTER_ROLE(),
            address(cre8ingBase)
        );
        cre8ingBase.setCre8ingOpen(address(cre8orsNFTBase), true);

        cre8ingBase.setLockup(address(cre8orsNFTBase), lockup);
        assertTrue(minter.minterUtility() != address(0));

        assertTrue(
            cre8orsNFTBase.hasRole(
                cre8orsNFTBase.MINTER_ROLE(),
                address(minter)
            )
        );
        vm.stopPrank();
    }

    function _updatePresaleStart(uint64 _presaleStart) internal {
        vm.startPrank(DEFAULT_OWNER_ADDRESS);
        (
            uint104 _publicSalePrice,
            address _erc20PaymentToken,
            uint32 _maxSalePurchasePerAddress,
            uint64 _publicSaleStart,
            uint64 _publicSaleEnd,
            ,
            uint64 _presaleEnd,
            bytes32 _presaleMerkleRoot
        ) = cre8orsNFTBase.salesConfig();

        cre8orsNFTBase.setSaleConfiguration(
            _erc20PaymentToken,
            _publicSalePrice,
            _maxSalePurchasePerAddress,
            _publicSaleStart,
            _publicSaleEnd,
            _presaleStart,
            _presaleEnd,
            _presaleMerkleRoot
        );
        vm.stopPrank();
    }

    function _updatePublicSaleStart(uint64 _publicSaleStart) internal {
        vm.startPrank(DEFAULT_OWNER_ADDRESS);
        (
            uint104 _publicSalePrice,
            address _erc20PaymentToken,
            uint32 _maxSalePurchasePerAddress,
            ,
            uint64 _publicSaleEnd,
            uint64 _presaleStart,
            uint64 _presaleEnd,
            bytes32 _presaleMerkleRoot
        ) = cre8orsNFTBase.salesConfig();

        cre8orsNFTBase.setSaleConfiguration(
            _erc20PaymentToken,
            _publicSalePrice,
            _maxSalePurchasePerAddress,
            _publicSaleStart,
            _publicSaleEnd,
            _presaleStart,
            _presaleEnd,
            _presaleMerkleRoot
        );
        vm.stopPrank();
    }

    function _updateMerkleRoot() internal {
        vm.startPrank(DEFAULT_OWNER_ADDRESS);
        (
            uint104 _publicSalePrice,
            address _erc20PaymentToken,
            uint32 _maxSalePurchasePerAddress,
            uint64 _publicSaleStart,
            uint64 _publicSaleEnd,
            uint64 _presaleStart,
            uint64 _presaleEnd,

        ) = cre8orsNFTBase.salesConfig();

        cre8orsNFTBase.setSaleConfiguration(
            _erc20PaymentToken,
            _publicSalePrice,
            _maxSalePurchasePerAddress,
            _publicSaleStart,
            _publicSaleEnd,
            _presaleStart,
            _presaleEnd,
            merkleData.getTestSetByName("test-allowlist-minter").root
        );
        vm.stopPrank();
    }

    function _setMinterRole(address _assignee) internal {
        vm.startPrank(DEFAULT_OWNER_ADDRESS);
        cre8orsNFTBase.grantRole(
            cre8orsNFTBase.MINTER_ROLE(),
            address(_assignee)
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
        ownerOfHook.setSubscription(
            address(cre8orsNFTBase),
            address(subscription)
        );
        vm.stopPrank();

        return ownerOfHook;
    }

    function _setupTransferHook() internal returns (TransferHook) {
        _setupErc6551();
        _setMinterRole(address(transferHook));

        vm.startPrank(DEFAULT_OWNER_ADDRESS);
        // set hook
        cre8orsNFTBase.setHook(
            IERC721ACH.HookType.BeforeTokenTransfers,
            address(transferHook)
        );
        cre8orsNFTBase.setHook(
            IERC721ACH.HookType.AfterTokenTransfers,
            address(transferHook)
        );
        // set subscription
        transferHook.setSubscription(
            address(cre8orsNFTBase),
            address(subscription)
        );
        transferHook.setCre8ing(address(cre8ingBase));
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

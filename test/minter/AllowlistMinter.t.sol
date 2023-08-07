// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;
// Forge Imports
import {DSTest} from "ds-test/test.sol";

import {StdUtils} from "forge-std/StdUtils.sol";
import {Vm} from "forge-std/Vm.sol";
// interface imports
import {ICollectionHolderMint} from "../../src/interfaces/ICollectionHolderMint.sol";
import {ICre8ors} from "../../src/interfaces/ICre8ors.sol";
import {IERC721A} from "../../lib/ERC721A/contracts/interfaces/IERC721A.sol";
import {IERC721Drop} from "../../src/interfaces/IERC721Drop.sol";
import {IFriendsAndFamilyMinter} from "../../src/interfaces/IFriendsAndFamilyMinter.sol";
import {IMinterUtilities} from "../../src/interfaces/IMinterUtilities.sol";
import {ILockup} from "../../src/interfaces/ILockup.sol";
import {ISharedPaidMinterFunctions} from "../../src/interfaces/ISharedPaidMinterFunctions.sol";
import {IERC721ACH} from "ERC721H/interfaces/IERC721ACH.sol";
// contract imports
import {CollectionHolderMint} from "../../src/minter/CollectionHolderMint.sol";
import {Cre8ors} from "../../src/Cre8ors.sol";
import {Cre8orTestBase} from "../utils/Cre8orTestBase.sol";
import {DummyMetadataRenderer} from "../utils/DummyMetadataRenderer.sol";
import {FriendsAndFamilyMinter} from "../../src/minter/FriendsAndFamilyMinter.sol";
import {Lockup} from "../../src/utils/Lockup.sol";
import {MinterUtilities} from "../../src/utils/MinterUtilities.sol";
import {AllowlistMinter} from "../../src/minter/AllowlistMinter.sol";
import {MerkleData} from "../merkle/MerkleData.sol";
import {Cre8ing} from "../../src/Cre8ing.sol";
import {OwnerOfHook} from "../../src/hooks/OwnerOf.sol";
import {TransferHook} from "../../src/hooks/Transfers.sol";
import {Subscription} from "../../src/subscription/Subscription.sol";

contract AllowlistMinterTest is DSTest, StdUtils {
    DummyMetadataRenderer public dummyRenderer = new DummyMetadataRenderer();
    address public constant DEFAULT_OWNER_ADDRESS = address(0x23499);
    address public constant DEFAULT_BUYER_ADDRESS = address(0x111);
    address payable public constant DEFAULT_FUNDS_RECIPIENT_ADDRESS =
        payable(address(0x21303));
    uint64 DEFAULT_EDITION_SIZE = 10_000;
    uint16 DEFAULT_ROYALTY_BPS = 888;
    Cre8ors public cre8orsNFTBase;
    Cre8ing public cre8ingBase;
    Cre8ors public cre8orsPassport;
    MinterUtilities public minterUtility;
    CollectionHolderMint public collectionMinter;
    FriendsAndFamilyMinter public friendsAndFamilyMinter;
    AllowlistMinter public minter;
    MerkleData public merkleData;
    Vm public constant vm = Vm(HEVM_ADDRESS);
    Lockup lockup = new Lockup();

    OwnerOfHook public ownerOfHook;
    TransferHook public transferHook;
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
        friendsAndFamilyMinter = new FriendsAndFamilyMinter(
            address(cre8orsNFTBase),
            address(minterUtility)
        );

        collectionMinter = new CollectionHolderMint(
            address(cre8orsNFTBase),
            address(cre8orsPassport),
            address(minterUtility),
            address(friendsAndFamilyMinter)
        );

        cre8ingBase = new Cre8ing();
        minter = new AllowlistMinter(
            address(cre8orsNFTBase),
            address(minterUtility),
            address(collectionMinter),
            address(friendsAndFamilyMinter)
        );

        subscription = _setupSubscription();

        transferHook = _setupTransferHook();
        ownerOfHook = _setupOwnerOfHook();

        vm.startPrank(DEFAULT_OWNER_ADDRESS);
        cre8orsNFTBase.setCre8ing(cre8ingBase);
        cre8orsPassport.setCre8ing(cre8ingBase);
        vm.stopPrank();

        merkleData = new MerkleData();
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
        uint256 tokenId = minter.mintPfp{value: totalPrice}(
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
        minter.mintPfp{value: totalPrice}(address(0x25), _carts, item.proof);

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
        vm.expectRevert(IERC721Drop.Presale_TooManyForAddress.selector);
        minter.mintPfp{value: totalPrice}(item.user, _carts, item.proof);

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
        minter.mintPfp{value: totalPrice}(item.user, _carts, item.proof);
    }

    function testInvalidArrayLengthExist(uint256[] memory _carts) public {
        vm.assume(_carts.length != 3);
        _setUpMinter();
        _updateMerkleRoot();

        MerkleData.MerkleEntry memory item;
        item = merkleData.getTestSetByName("test-allowlist-minter").entries[0];
        vm.expectRevert(ISharedPaidMinterFunctions.InvalidArrayLength.selector);
        vm.prank(item.user);
        minter.mintPfp{value: 0 ether}(item.user, _carts, item.proof);

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
        minter.mintPfp{value: totalPrice}(_buyer, _carts, proof);

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
        minter.mintPfp{value: totalPrice}(item.user, _carts, item.proof);

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
        collectionMinter.mint(_ids, item.user);
        uint256 totalPrice = IMinterUtilities(address(minterUtility))
            .calculateTotalCost(_carts);

        assertTrue(
            !IERC721Drop(address(cre8orsNFTBase)).saleDetails().presaleActive
        );
        vm.deal(item.user, totalPrice);
        uint256 mintPFPId = minter.mintPfp{value: totalPrice}(
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
            address(collectionMinter)
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

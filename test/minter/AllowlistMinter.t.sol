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
            address(minterUtility),
            address(friendsAndFamilyMinter)
        );

        cre8ingBase = new Cre8ing();
        minter = new AllowlistMinter(
            address(cre8orsNFTBase),
            address(minterUtility)
        );

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

    function testSuccess(IMinterUtilities.Cart[] memory _carts) public {
        vm.assume(_carts.length > 0);
        vm.assume(_carts.length < 4);
        _setUpMinter(true);
        _updateMerkleRoot();

        for (uint i = 0; i < _carts.length; i++) {
            uint256 tier = bound(1, 1, 3);
            emit log_named_uint("tier", tier);
            _carts[i].tier = uint8(tier);
            _carts[i].quantity = bound(_carts[i].quantity, 1, 19);
        }
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
            address(collectionMinter),
            address(friendsAndFamilyMinter),
            item.proof
        );
        vm.stopPrank();
        assertEq(totalQuantity, tokenId);
        assertEq(
            totalQuantity,
            cre8orsNFTBase.mintedPerAddress(DEFAULT_BUYER_ADDRESS).totalMints
        );
    }

    function testSuccessWithStaking(
        IMinterUtilities.Cart[] memory _carts
    ) public {
        testSuccess(_carts);
    }

    function testRevertNotWhiteListApproved(bool _withLockUp) public {
        _setUpMinter(_withLockUp);
        _updateMerkleRoot();
        IMinterUtilities.Cart[] memory _carts = new IMinterUtilities.Cart[](1);
        _carts[0].tier = 1;
        _carts[0].quantity = 10;

        MerkleData.MerkleEntry memory item;
        item = merkleData.getTestSetByName("test-allowlist-minter").entries[0];
        uint256 totalPrice = IMinterUtilities(address(minterUtility))
            .calculateTotalCost(_carts);

        vm.deal(address(0x25), totalPrice);
        vm.prank(address(0x25));
        vm.expectRevert(IERC721Drop.Presale_MerkleNotApproved.selector);
        minter.mintPfp{value: totalPrice}(
            address(0x25),
            _carts,
            address(collectionMinter),
            address(friendsAndFamilyMinter),
            item.proof
        );
    }

    function testRevertTooMuchQuantity(bool _withLockUp) public {
        _setUpMinter(_withLockUp);
        _updateMerkleRoot();
        IMinterUtilities.Cart[] memory _carts = new IMinterUtilities.Cart[](1);
        _carts[0].tier = 1;
        _carts[0].quantity = 88;

        MerkleData.MerkleEntry memory item;
        item = merkleData.getTestSetByName("test-allowlist-minter").entries[0];
        uint256 totalPrice = IMinterUtilities(address(minterUtility))
            .calculateTotalCost(_carts);

        vm.deal(item.user, totalPrice);
        vm.prank(item.user);
        vm.expectRevert(IERC721Drop.Presale_TooManyForAddress.selector);
        minter.mintPfp{value: totalPrice}(
            item.user,
            _carts,
            address(collectionMinter),
            address(friendsAndFamilyMinter),
            item.proof
        );
    }

    function testRevertEmptyCarts(bool _withLockUp) public {
        _setUpMinter(_withLockUp);
        _updateMerkleRoot();
        IMinterUtilities.Cart[] memory _carts = new IMinterUtilities.Cart[](1);

        MerkleData.MerkleEntry memory item;
        item = merkleData.getTestSetByName("test-allowlist-minter").entries[0];
        uint256 totalPrice = IMinterUtilities(address(minterUtility))
            .calculateTotalCost(_carts);

        vm.deal(item.user, totalPrice);
        vm.prank(item.user);
        vm.expectRevert(IERC721A.MintZeroQuantity.selector);
        minter.mintPfp{value: totalPrice}(
            item.user,
            _carts,
            address(collectionMinter),
            address(friendsAndFamilyMinter),
            item.proof
        );
    }

    function testTierDoesntExist() public {
        _setUpMinter(true);
        _updateMerkleRoot();
        IMinterUtilities.Cart[] memory _carts = new IMinterUtilities.Cart[](1);
        _carts[0].tier = 4;
        _carts[0].quantity = 10;

        MerkleData.MerkleEntry memory item;
        item = merkleData.getTestSetByName("test-allowlist-minter").entries[0];
        uint256 totalPrice = IMinterUtilities(address(minterUtility))
            .calculateTotalCost(_carts);

        vm.deal(item.user, totalPrice);
        vm.expectRevert(ISharedPaidMinterFunctions.InvalidTier.selector);
        vm.prank(item.user);
        minter.mintPfp{value: totalPrice}(
            item.user,
            _carts,
            address(collectionMinter),
            address(friendsAndFamilyMinter),
            item.proof
        );
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

    function _setUpMinter(bool withLockup) internal {
        vm.startPrank(DEFAULT_OWNER_ADDRESS);
        cre8orsNFTBase.grantRole(cre8orsNFTBase.MINTER_ROLE(), address(minter));
        if (withLockup) {
            cre8ingBase.setLockup(address(cre8orsNFTBase), lockup);
            assertTrue(minter.minterUtility() != address(0));
        }

        assertTrue(
            cre8orsNFTBase.hasRole(
                cre8orsNFTBase.MINTER_ROLE(),
                address(minter)
            )
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
}

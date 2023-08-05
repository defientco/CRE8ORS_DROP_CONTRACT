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
// contract imports
import {CollectionHolderMint} from "../../src/minter/CollectionHolderMint.sol";
import {Cre8ors} from "../../src/Cre8ors.sol";
import {Cre8orTestBase} from "../utils/Cre8orTestBase.sol";
import {DummyMetadataRenderer} from "../utils/DummyMetadataRenderer.sol";
import {FriendsAndFamilyMinter} from "../../src/minter/FriendsAndFamilyMinter.sol";
import {Lockup} from "../../src/utils/Lockup.sol";
import {MinterUtilities} from "../../src/utils/MinterUtilities.sol";
import {PublicMinter} from "../../src/minter/PublicMinter.sol";
import {Cre8ing} from "../../src/Cre8ing.sol";

contract PublicMinterTest is DSTest, StdUtils {
    DummyMetadataRenderer public dummyRenderer = new DummyMetadataRenderer();
    address public constant DEFAULT_OWNER_ADDRESS = address(0x23499);
    address public constant DEFAULT_BUYER_ADDRESS = address(0x111);
    address payable public constant DEFAULT_FUNDS_RECIPIENT_ADDRESS =
        payable(address(0x21303));
    uint64 DEFAULT_EDITION_SIZE = 10_000;
    uint16 DEFAULT_ROYALTY_BPS = 888;
    Cre8ors public cre8orsNFTBase;
    Cre8ors public cre8orsPassport;
    Cre8ing public cre8ingBase;
    MinterUtilities public minterUtility;
    CollectionHolderMint public collectionMinter;
    FriendsAndFamilyMinter public friendsAndFamilyMinter;
    PublicMinter public minter;
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
            address(cre8orsPassport),
            address(minterUtility),
            address(friendsAndFamilyMinter)
        );

        minter = new PublicMinter(
            address(cre8orsNFTBase),
            address(minterUtility),
            address(collectionMinter),
            address(friendsAndFamilyMinter)
        );
        cre8ingBase = new Cre8ing();
        vm.startPrank(DEFAULT_OWNER_ADDRESS);
        cre8orsNFTBase.setCre8ing(cre8ingBase);
        cre8orsPassport.setCre8ing(cre8ingBase);
        vm.stopPrank();
    }

    function testLockup() public {
        assertEq(
            address(cre8ingBase.lockup(address(cre8orsNFTBase))),
            address(0)
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

    function testSuccess(bool _withLockUp, address _buyer) public {
        uint256[] memory _carts = new uint256[](3);
        _carts[0] = bound(_carts[0], 1, 8);
        _carts[1] = 0;
        _carts[2] = 0;
        vm.assume(_buyer != address(0));
        _setUpMinter(_withLockUp);
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
        uint256 tokenId = minter.mintPfp{value: totalPrice}(_buyer, _carts);
        vm.stopPrank();
        assertEq(totalQuantity, tokenId);
        assertEq(
            totalQuantity,
            cre8orsNFTBase.mintedPerAddress(_buyer).totalMints
        );
    }

    function testPublicSaleInactiveMintedDiscount(
        bool _withLockUp,
        address _buyer
    ) public {
        uint256[] memory _carts = new uint256[](3);
        _carts[0] = bound(_carts[0], 1, 8);
        _carts[1] = 0;
        _carts[2] = 0;
        vm.assume(_buyer != address(0));
        _setUpMinter(_withLockUp);
        _updatePublicSaleStart(uint64(block.timestamp + 1000));
        vm.assume(
            IMinterUtilities(address(minterUtility)).calculateTotalQuantity(
                _carts
            ) < 8
        );
        vm.startPrank(DEFAULT_OWNER_ADDRESS);
        cre8orsNFTBase.grantRole(
            cre8orsNFTBase.DEFAULT_ADMIN_ROLE(),
            address(friendsAndFamilyMinter)
        );
        friendsAndFamilyMinter.addDiscount(_buyer);
        vm.stopPrank();
        vm.startPrank(_buyer);
        friendsAndFamilyMinter.mint(_buyer);
        vm.stopPrank();
        uint256 totalQuantity = IMinterUtilities(address(minterUtility))
            .calculateTotalQuantity(_carts);
        uint256 totalPrice = IMinterUtilities(address(minterUtility))
            .calculateTotalCost(_carts);

        vm.deal(_buyer, totalPrice);
        vm.startPrank(_buyer);
        uint256 tokenId = minter.mintPfp{value: totalPrice}(_buyer, _carts);
        vm.stopPrank();
        assertEq(totalQuantity + 1, tokenId);
        assertEq(
            totalQuantity + 1,
            cre8orsNFTBase.mintedPerAddress(_buyer).totalMints
        );
    }

    function testRevertPublicSaleInactive(
        bool _withLockUp,
        address _buyer
    ) public {
        uint256[] memory _carts = new uint256[](3);
        _carts[0] = bound(_carts[0], 1, 8);
        _carts[1] = 0;
        _carts[2] = 0;
        vm.assume(_buyer != address(0));
        _setUpMinter(_withLockUp);
        _updatePublicSaleStart(uint64(block.timestamp + 1000));

        vm.assume(
            IMinterUtilities(address(minterUtility)).calculateTotalQuantity(
                _carts
            ) < 8
        );
        uint256 totalQuantity = IMinterUtilities(address(minterUtility))
            .calculateTotalQuantity(_carts);
        uint256 totalPrice = IMinterUtilities(address(minterUtility))
            .calculateTotalCost(_carts);

        vm.deal(_buyer, totalPrice);
        vm.startPrank(_buyer);
        vm.expectRevert(IERC721Drop.Sale_Inactive.selector);
        uint256 tokenId = minter.mintPfp{value: totalPrice}(_buyer, _carts);
        vm.stopPrank();
    }

    function testRevertPublicSaleInactiveOfWalletWithTransferedMintedDiscount(
        uint256[] memory _carts,
        bool _withLockUp,
        address _buyer
    ) public {
        address transferred = address(0x1988789);
        vm.assume(_buyer != transferred);
        uint256[] memory _carts = new uint256[](3);
        _carts[0] = bound(_carts[0], 1, 8);
        _carts[1] = 0;
        _carts[2] = 0;
        vm.assume(_buyer != address(0));
        _setUpMinter(_withLockUp);
        // set public sale start to sometime in future
        _updatePublicSaleStart(uint64(block.timestamp + 1000000));

        vm.assume(
            IMinterUtilities(address(minterUtility)).calculateTotalQuantity(
                _carts
            ) < 8
        );
        // grant family minter admin role
        vm.startPrank(DEFAULT_OWNER_ADDRESS);
        cre8orsNFTBase.grantRole(
            cre8orsNFTBase.DEFAULT_ADMIN_ROLE(),
            address(friendsAndFamilyMinter)
        );
        // add discount to buyer
        friendsAndFamilyMinter.addDiscount(_buyer);
        vm.stopPrank();
        // transfer minted pfp from buyer to transferred
        vm.startPrank(_buyer);
        friendsAndFamilyMinter.mint(_buyer);
        cre8orsNFTBase.transferFrom(_buyer, transferred, 1);
        assertEq(cre8orsNFTBase.mintedPerAddress(transferred).totalMints, 0);
        vm.stopPrank();
        uint256 totalQuantity = IMinterUtilities(address(minterUtility))
            .calculateTotalQuantity(_carts);
        uint256 totalPrice = IMinterUtilities(address(minterUtility))
            .calculateTotalCost(_carts);

        // transferred tries to mint with transferred pfp prior to sale.
        vm.deal(transferred, totalPrice);
        vm.expectRevert(IERC721Drop.Sale_Inactive.selector);
        vm.prank(transferred);
        uint256 tokenId = minter.mintPfp{value: totalPrice}(
            transferred,
            _carts
        );
    }

    function _setUpMinter(bool withLockup) internal {
        vm.startPrank(DEFAULT_OWNER_ADDRESS);
        cre8orsNFTBase.grantRole(cre8orsNFTBase.MINTER_ROLE(), address(minter));
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
}

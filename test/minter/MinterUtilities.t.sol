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

contract MinterUtilitiesTest is DSTest, StdUtils {
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

        vm.startPrank(DEFAULT_OWNER_ADDRESS);
        cre8orsNFTBase.setCre8ing(cre8ingBase);
        cre8orsPassport.setCre8ing(cre8ingBase);
        vm.stopPrank();
    }

    function testQuantityLeftBeforePublicSaleWithFreeMint(
        address _buyer
    ) public {
        vm.assume(_buyer != address(0));
        // setup
        _setUpMinter(false);
        _updatePublicSaleStart(uint64(block.timestamp + 10000));
        vm.startPrank(_buyer);
        uint256 tokenId = cre8orsPassport.purchase(1);
        emit log_named_uint("tokenId", tokenId);
        vm.stopPrank();
        assertTrue(
            cre8orsPassport.balanceOf(_buyer) == 1,
            "should have 1 passport"
        );
        vm.prank(_buyer);
        uint256[] memory tokenIds = new uint256[](1);
        tokenIds[0] = tokenId + 1;
        uint256 mintedTokenId = collectionMinter.mint(
            tokenIds,
            address(cre8orsPassport),
            _buyer
        );

        uint256 quantityLeft = minterUtility.quantityLeft(
            address(collectionMinter),
            address(friendsAndFamilyMinter),
            address(cre8orsNFTBase),
            _buyer
        );
        console.log(quantityLeft);
        emit log_named_uint("quantityLeft", quantityLeft);

        assertEq(quantityLeft, 8, "should have 8 quantity left");
    }

    function testQuantityLeftAfterPublicSaleWithFreeMint(
        address _buyer
    ) public {
        vm.assume(_buyer != address(0));
        // setup
        _setUpMinter(false);
        vm.startPrank(_buyer);
        uint256 tokenId = cre8orsPassport.purchase(1);
        emit log_named_uint("tokenId", tokenId);
        vm.stopPrank();
        assertTrue(
            cre8orsPassport.balanceOf(_buyer) == 1,
            "should have 1 passport"
        );
        vm.prank(_buyer);
        uint256[] memory tokenIds = new uint256[](1);
        tokenIds[0] = tokenId + 1;
        uint256 mintedTokenId = collectionMinter.mint(
            tokenIds,
            address(cre8orsPassport),
            _buyer
        );

        uint256 quantityLeft = minterUtility.quantityLeft(
            address(collectionMinter),
            address(friendsAndFamilyMinter),
            address(cre8orsNFTBase),
            _buyer
        );
        console.log(quantityLeft);
        emit log_named_uint("quantityLeft", quantityLeft);

        assertEq(quantityLeft, 26, "should have 26 quantity left");
    }

    function testQuantityLeftAfterPublicSaleWithoutFreeMint(
        address _buyer
    ) public {
        vm.assume(_buyer != address(0));
        // setup
        _setUpMinter(false);
        vm.startPrank(_buyer);
        uint256 tokenId = cre8orsPassport.purchase(1);
        emit log_named_uint("tokenId", tokenId);
        vm.stopPrank();
        assertTrue(
            cre8orsPassport.balanceOf(_buyer) == 1,
            "should have 1 passport"
        );

        uint256 quantityLeft = minterUtility.quantityLeft(
            address(collectionMinter),
            address(friendsAndFamilyMinter),
            address(cre8orsNFTBase),
            _buyer
        );

        assertEq(quantityLeft, 18, "should have 18 quantity left");
    }

    function testQuantityLeftBeforePublicSaleWithoutFreeMint(
        address _buyer
    ) public {
        vm.assume(_buyer != address(0));
        // setup
        _setUpMinter(false);
        _updatePublicSaleStart(uint64(block.timestamp + 10000));
        vm.startPrank(_buyer);
        uint256 tokenId = cre8orsPassport.purchase(1);
        emit log_named_uint("tokenId", tokenId);
        vm.stopPrank();
        assertTrue(
            cre8orsPassport.balanceOf(_buyer) == 1,
            "should have 1 passport"
        );

        uint256 quantityLeft = minterUtility.quantityLeft(
            address(collectionMinter),
            address(friendsAndFamilyMinter),
            address(cre8orsNFTBase),
            _buyer
        );
        console.log(quantityLeft);
        emit log_named_uint("quantityLeft", quantityLeft);

        assertEq(quantityLeft, 8, "should have 8 quantity left");
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
        cre8orsNFTBase.grantRole(
            cre8orsNFTBase.DEFAULT_ADMIN_ROLE(),
            address(collectionMinter)
        );
        if (withLockup) {
            cre8ingBase.setLockup(address(cre8orsNFTBase), lockup);
            assertTrue(
                collectionMinter.minterUtilityContractAddress() != address(0)
            );
        }

        assertTrue(
            cre8orsNFTBase.hasRole(
                cre8orsNFTBase.DEFAULT_ADMIN_ROLE(),
                address(collectionMinter)
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

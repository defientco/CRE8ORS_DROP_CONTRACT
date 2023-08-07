// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

// DSTest Imports
import {DSTest} from "ds-test/test.sol";
// Forge Imports
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
import {PublicMinter} from "../../src/minter/PublicMinter.sol";
import {Subscription} from "../../src/subscription/Subscription.sol";
import {TransferHook} from "../../src/Transfers.sol";

contract SubscriptionTest is DSTest, StdUtils {
    Vm public constant vm = Vm(HEVM_ADDRESS);

    DummyMetadataRenderer public dummyRenderer = new DummyMetadataRenderer();
    address public constant DEFAULT_OWNER_ADDRESS = address(0x23499);
    address public constant DEFAULT_BUYER_ADDRESS = address(0x111);
    address payable public constant DEFAULT_FUNDS_RECIPIENT_ADDRESS =
        payable(address(0x21303));
    uint64 DEFAULT_EDITION_SIZE = 10_000;
    uint16 DEFAULT_ROYALTY_BPS = 888;

    Cre8ors public cre8orsNFTBase;
    Cre8ors public cre8orsPassport;
    MinterUtilities public minterUtility;

    CollectionHolderMint public collectionMinter;
    FriendsAndFamilyMinter public friendsAndFamilyMinter;
    AllowlistMinter public allowlistMinter;
    PublicMinter public publicMinter;

    MerkleData public merkleData;
    Lockup lockup = new Lockup();

    Cre8ing public cre8ingForBase;
    Cre8ing public cre8ingForPassport;

    Subscription public subscriptionForBase;
    Subscription public subscriptionForPassport;

    TransferHook public transferHookForBase;
    TransferHook public transferHookForPassport;

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

        transferHookForBase = _setupTransferHookContract(cre8orsNFTBase);
        transferHookForPassport = _setupTransferHookContract(cre8orsPassport);

        cre8ingForBase = _setupCre8ing(cre8orsNFTBase);
        cre8ingForPassport = _setupCre8ing(cre8orsPassport);

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
        allowlistMinter = new AllowlistMinter(
            address(cre8orsNFTBase),
            address(minterUtility),
            address(collectionMinter),
            address(friendsAndFamilyMinter)
        );
        publicMinter = new PublicMinter(
            address(cre8orsNFTBase),
            address(minterUtility),
            address(collectionMinter),
            address(friendsAndFamilyMinter)
        );

        subscriptionForBase = _setupSubscriptionContract(cre8orsNFTBase);
        subscriptionForPassport = _setupSubscriptionContract(cre8orsPassport);

        merkleData = new MerkleData();
    }

    function testSuccessfulMintAndSubscriptionByFriendsAndFamilyMinter(
        address _friendOrFamily
    ) public {
        vm.assume(_friendOrFamily != address(0));

        // Setup FriendsAndFamilyMinter
        _setUpFriendsAndFamilyMinter();

        // Apply Discount
        _addFriendsAndFamilyMinterDiscount(_friendOrFamily);

        // Mint
        _setupLockup();
        uint256 tokenId = friendsAndFamilyMinter.mint(_friendOrFamily);

        // Asserts
        assertTrue(!friendsAndFamilyMinter.hasDiscount(_friendOrFamily));
        assertEq(tokenId, 1);
        assertEq(cre8orsNFTBase.ownerOf(tokenId), _friendOrFamily);
        assertEq(
            cre8orsNFTBase.mintedPerAddress(_friendOrFamily).totalMints,
            1
        );

        // 1 year passed
        vm.warp(block.timestamp + ONE_YEAR_DURATION);

        // ownerOf should return address(0)
        assertEq(cre8orsNFTBase.ownerOf(tokenId), address(0));
    }

    /*//////////////////////////////////////////////////////////////
                             SETUP FUNCTIONS
    //////////////////////////////////////////////////////////////*/

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

    function _setupCre8ing(
        Cre8ors cre8orsNFT_
    ) internal returns (Cre8ing _cre8ing) {
        _cre8ing = new Cre8ing();
        vm.prank(DEFAULT_OWNER_ADDRESS);
        cre8orsNFT_.setCre8ing(_cre8ing);
        vm.prank(DEFAULT_OWNER_ADDRESS);
        _cre8ing.setCre8ingOpen(address(cre8orsNFT_), true);
        _setupMinterRole(address(_cre8ing));
    }

    function _setupLockup() internal {
        vm.prank(DEFAULT_OWNER_ADDRESS);
        cre8ingForBase.setLockup(address(cre8orsNFTBase), lockup);
    }

    function _setupSubscriptionContract(
        Cre8ors cre8orsNFT_
    ) internal returns (Subscription _subscription) {
        _subscription = new Subscription({
            cre8orsNFT_: address(cre8orsNFT_),
            minRenewalDuration_: 1 days,
            pricePerSecond_: 38580246913 // Roughly calculates to 0.1 ether per 30 days
        });

        vm.startPrank(DEFAULT_OWNER_ADDRESS);
        cre8orsNFT_.setSubscription(address(_subscription));
        vm.stopPrank();
    }

    function _setupTransferHookContract(
        Cre8ors cre8orsNFT_
    ) internal returns (TransferHook _transferHook) {
        _transferHook = new TransferHook(address(cre8orsNFT_));
        _setupMinterRole(address(_transferHook));

        vm.startPrank(DEFAULT_OWNER_ADDRESS);
        cre8orsNFT_.setHook(
            IERC721ACH.HookType.AfterTokenTransfers,
            address(_transferHook)
        );
        vm.stopPrank();
    }

    function _setUpFriendsAndFamilyMinter() internal {
        bytes32 role = cre8orsNFTBase.DEFAULT_ADMIN_ROLE();
        vm.prank(DEFAULT_OWNER_ADDRESS);
        cre8orsNFTBase.grantRole(role, address(friendsAndFamilyMinter));
        assertTrue(
            cre8orsNFTBase.hasRole(
                cre8orsNFTBase.DEFAULT_ADMIN_ROLE(),
                address(friendsAndFamilyMinter)
            )
        );
    }

    function _addFriendsAndFamilyMinterDiscount(address _buyer) internal {
        assertTrue(!friendsAndFamilyMinter.hasDiscount(_buyer));
        vm.prank(DEFAULT_OWNER_ADDRESS);
        friendsAndFamilyMinter.addDiscount(_buyer);
        assertTrue(friendsAndFamilyMinter.hasDiscount(_buyer));
    }

    function _setUpCollectionMinter() internal {
        vm.startPrank(DEFAULT_OWNER_ADDRESS);
        cre8orsNFTBase.grantRole(
            cre8orsNFTBase.MINTER_ROLE(),
            address(collectionMinter)
        );

        assertTrue(
            collectionMinter.minterUtilityContractAddress() != address(0)
        );

        assertTrue(
            cre8orsNFTBase.hasRole(
                cre8orsNFTBase.MINTER_ROLE(),
                address(collectionMinter)
            )
        );
        vm.stopPrank();
    }

    function _setUpAllowlistMinter() internal {
        vm.startPrank(DEFAULT_OWNER_ADDRESS);
        cre8orsNFTBase.grantRole(
            cre8orsNFTBase.DEFAULT_ADMIN_ROLE(),
            address(allowlistMinter)
        );

        assertTrue(
            cre8orsNFTBase.hasRole(
                cre8orsNFTBase.DEFAULT_ADMIN_ROLE(),
                address(allowlistMinter)
            )
        );
        vm.stopPrank();
    }

    function _setUpPublicMinter() internal {
        vm.startPrank(DEFAULT_OWNER_ADDRESS);
        cre8orsNFTBase.grantRole(
            cre8orsNFTBase.DEFAULT_ADMIN_ROLE(),
            address(publicMinter)
        );

        assertTrue(
            cre8orsNFTBase.hasRole(
                cre8orsNFTBase.DEFAULT_ADMIN_ROLE(),
                address(publicMinter)
            )
        );
        vm.stopPrank();
    }

    function _setupMinterRole(address _assignee) internal {
        vm.startPrank(DEFAULT_OWNER_ADDRESS);
        cre8orsNFTBase.grantRole(
            cre8orsNFTBase.MINTER_ROLE(),
            address(_assignee)
        );
        vm.stopPrank();
    }
}

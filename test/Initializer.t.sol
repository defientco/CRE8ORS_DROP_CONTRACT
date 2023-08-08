// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "forge-std/Test.sol";
import {Cre8ors} from "../src/Cre8ors.sol";
import {DummyMetadataRenderer} from "./utils/DummyMetadataRenderer.sol";
import {IERC721Drop} from "../src/interfaces/IERC721Drop.sol";
import {IERC721A} from "lib/ERC721A/contracts/IERC721A.sol";
import {IERC2981, IERC165} from "lib/openzeppelin-contracts/contracts/interfaces/IERC2981.sol";
import {IOwnable} from "../src/interfaces/IOwnable.sol";
import {Cre8ing} from "../src/Cre8ing.sol";
import {Initializer} from "../src/Initializer.sol";
import {ICre8ors} from "../src/interfaces/ICre8ors.sol";
import {Cre8orTestBase} from "./utils/Cre8orTestBase.sol";
import {PublicMinter} from "../src/minter/PublicMinter.sol";
import {Subscription} from "../src/subscription/Subscription.sol";
import {TransferHook} from "../src/hooks/Transfers.sol";
import {OwnerOfHook} from "../src/hooks/OwnerOf.sol";
import {MinterUtilities} from "../src/utils/MinterUtilities.sol";
import {Lockup} from "../src/utils/Lockup.sol";
import {CollectionHolderMint} from "../src/minter/CollectionHolderMint.sol";
import {FriendsAndFamilyMinter} from "../src/minter/FriendsAndFamilyMinter.sol";
import {AllowlistMinter} from "../src/minter/AllowlistMinter.sol";
import {IERC721ACH} from "ERC721H/interfaces/IERC721ACH.sol";

contract InitializerTest is Test, Cre8orTestBase {
    Initializer public initializer;
    Subscription public subscription;
    OwnerOfHook public ownerOfHook;
    Cre8ing public cre8ingBase;
    Lockup public lockup;
    MinterUtilities public minterUtility;
    Cre8ors public cre8orsPassport;
    Cre8ors public dna;
    CollectionHolderMint public collectionMinter;
    FriendsAndFamilyMinter public friendsAndFamilyMinter;
    AllowlistMinter public allowlistMinter;
    PublicMinter public publicMinter;

    function setUp() public {
        Cre8orTestBase.cre8orSetup();
        dna = _deployCre8or();
        cre8orsPassport = _deployCre8or();
        cre8ingBase = new Cre8ing();
        initializer = new Initializer();
        subscription = new Subscription({
            cre8orsNFT_: address(cre8orsNFTBase),
            minRenewalDuration_: 1 days,
            pricePerSecond_: 38580246913 // Roughly calculates to 0.1 ether per 30 days
        });
        ownerOfHook = new OwnerOfHook();
        lockup = new Lockup();
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
        _setupErc6551();
    }

    function test_Initialize(address _caller) public {
        vm.assume(_caller != address(0));
        _grantAdminRole(address(initializer));
        _grantAdminRole(_caller);
        // GIVE INITIALIZER ADMIN ROLE ON DNA
        _grantInitializerAdminRoleOnDna();
        _initialize(_caller);
        _assertProperSetup();
    }

    function test_Initialize_revert_Access_OnlyAdmin(address _caller) public {
        _assumeAddress(_caller);
        _grantAdminRole(address(initializer));
        vm.expectRevert(IERC721Drop.Access_OnlyAdmin.selector);
        _initialize(_caller);
    }

    function test_mintDnaAirdrop(address _friend) public {
        _assumeAddress(_friend);
        test_Initialize(DEFAULT_OWNER_ADDRESS);
        _mintFriendsAndFamily(_friend);
        _assumeDnaAirdrop(1);
    }

    function _grantInitializerAdminRoleOnDna() internal {
        vm.startPrank(DEFAULT_OWNER_ADDRESS);
        dna.grantRole(dna.DEFAULT_ADMIN_ROLE(), address(initializer));
        vm.stopPrank();
    }

    function _assumeDnaAirdrop(uint256 _tokenId) internal {
        address smartWallet = _assumeTBASetup(_tokenId);
        // assert DNA airdropped
        assertEq(dna.ownerOf(_tokenId), smartWallet);
    }

    function _assumeTBASetup(
        uint256 _tokenId
    ) internal returns (address _smartWallet) {
        _smartWallet = getTBA(_tokenId);
        assertTrue(isContract(_smartWallet));
    }

    function _assumeAddress(address _normal) internal {
        vm.assume(_normal != address(0));
        vm.assume(_normal != DEFAULT_OWNER_ADDRESS);
        vm.assume(_normal != address(initializer));
    }

    function _mintFriendsAndFamily(address _friend) internal {
        _addFriendsAndFamilyDiscount(_friend);
        friendsAndFamilyMinter.mint(_friend);
        assertEq(cre8orsNFTBase.balanceOf(_friend), 1);
    }

    function _addFriendsAndFamilyDiscount(address _friend) internal {
        vm.prank(DEFAULT_OWNER_ADDRESS);
        friendsAndFamilyMinter.addDiscount(_friend);
    }

    function _assertProperSetup() internal {
        assertTrue(cre8ingBase.cre8ingOpen(address(cre8orsNFTBase)));
        assertEq(
            cre8orsNFTBase.getHook(IERC721ACH.HookType.BeforeTokenTransfers),
            address(transferHook)
        );
        _assertCorrectAccessManagerSetup();
    }

    function _assertCorrectAccessManagerSetup() internal {
        _assertHasMinterRole(address(cre8ingBase));
        _assertHasMinterRole(address(transferHook));
        _assertMintersHaveMinterRole();
        _assertAdmin(address(cre8orsNFTBase), address(initializer), false);
        _assertAdmin(address(dna), address(initializer), false);
    }

    function _assertMintersHaveMinterRole() internal {
        _assertHasMinterRole(address(friendsAndFamilyMinter));
        _assertHasMinterRole(address(collectionMinter));
        _assertHasMinterRole(address(allowlistMinter));
        _assertHasMinterRole(address(publicMinter));
    }

    function _assertHasMinterRole(address _minter) internal {
        assertTrue(
            cre8orsNFTBase.hasRole(cre8orsNFTBase.MINTER_ROLE(), _minter)
        );
    }

    function _grantAdminRole(address _admin) internal {
        vm.startPrank(DEFAULT_OWNER_ADDRESS);

        cre8orsNFTBase.grantRole(
            cre8orsNFTBase.DEFAULT_ADMIN_ROLE(),
            address(_admin)
        );

        _assertAdmin(address(cre8orsNFTBase), _admin, true);
        vm.stopPrank();
    }

    function _assertAdmin(
        address _target,
        address _admin,
        bool _isAdmin
    ) internal {
        assertEq(
            ICre8ors(_target).hasRole(
                cre8orsNFTBase.DEFAULT_ADMIN_ROLE(),
                address(_admin)
            ),
            _isAdmin
        );
    }

    function _initialize(address _caller) internal {
        vm.prank(_caller);
        initializer.setup(
            address(cre8orsNFTBase),
            address(subscription),
            address(transferHook),
            address(ownerOfHook),
            address(cre8ingBase),
            address(lockup),
            address(friendsAndFamilyMinter),
            address(collectionMinter),
            address(allowlistMinter),
            address(publicMinter),
            address(dna)
        );
    }
}

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
import {TransferHook} from "../src/Transfers.sol";
import {MinterUtilities} from "../src/utils/MinterUtilities.sol";
import {Lockup} from "../src/utils/Lockup.sol";
import {CollectionHolderMint} from "../src/minter/CollectionHolderMint.sol";
import {FriendsAndFamilyMinter} from "../src/minter/FriendsAndFamilyMinter.sol";
import {AllowlistMinter} from "../src/minter/AllowlistMinter.sol";

contract InitializerTest is Test, Cre8orTestBase {
    Initializer public initializer;
    Subscription public subscription;
    TransferHook public transferHook;
    Cre8ing public cre8ingBase;
    Lockup public lockup;
    MinterUtilities public minterUtility;
    Cre8ors public cre8orsPassport;
    CollectionHolderMint public collectionMinter;
    FriendsAndFamilyMinter public friendsAndFamilyMinter;
    AllowlistMinter public allowlistMinter;
    PublicMinter public publicMinter;

    function setUp() public {
        Cre8orTestBase.cre8orSetup();
        _deployCre8or(cre8orsPassport);
        cre8ingBase = new Cre8ing();
        initializer = new Initializer();
        subscription = new Subscription({
            cre8orsNFT_: address(cre8orsNFTBase),
            minRenewalDuration_: 1 days,
            pricePerSecond_: 38580246913 // Roughly calculates to 0.1 ether per 30 days
        });
        transferHook = new TransferHook(address(cre8orsNFTBase));
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
    }

    function test_Initialize(address _caller) public {
        vm.assume(_caller != address(0));
        _grantAdminRole(address(initializer));
        _grantAdminRole(_caller);
        _initialize(_caller);
    }

    function test_Initialize_revert_Access_OnlyAdmin(address _caller) public {
        vm.assume(_caller != address(0));
        vm.assume(_caller != DEFAULT_OWNER_ADDRESS);
        vm.assume(_caller != address(initializer));

        _grantAdminRole(address(initializer));
        vm.expectRevert(IERC721Drop.Access_OnlyAdmin.selector);
        _initialize(_caller);
    }

    function _grantAdminRole(address _admin) internal {
        vm.startPrank(DEFAULT_OWNER_ADDRESS);
        emit log_address(address(cre8orsNFTBase));

        cre8orsNFTBase.grantRole(
            cre8orsNFTBase.DEFAULT_ADMIN_ROLE(),
            address(_admin)
        );

        assertTrue(
            cre8orsNFTBase.hasRole(
                cre8orsNFTBase.DEFAULT_ADMIN_ROLE(),
                address(_admin)
            )
        );
        vm.stopPrank();
    }

    function _initialize(address _caller) internal {
        vm.prank(_caller);

        initializer.setup(
            address(cre8orsNFTBase),
            address(subscription),
            address(transferHook),
            address(cre8ingBase),
            address(lockup),
            address(friendsAndFamilyMinter),
            address(collectionMinter),
            address(allowlistMinter),
            address(publicMinter)
        );
    }
}

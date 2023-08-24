//SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

// Forge Imports
import {DSTest} from "ds-test/test.sol";
import {StdUtils} from "forge-std/StdUtils.sol";
import {Vm} from "forge-std/Vm.sol";
// Interface Imports
import {IERC721A} from "../../lib/ERC721A/contracts/interfaces/IERC721A.sol";
import {IERC721Drop} from "../../src/interfaces/IERC721Drop.sol";
import {ILockup} from "../../src/interfaces/ILockup.sol";
import {IMinterUtilities} from "../../src/interfaces/IMinterUtilities.sol";
import {IFreeMinter} from "../../src/interfaces/IFreeMinter.sol";
import {ICre8ors} from "../../src/interfaces/ICre8ors.sol";
import {IERC721ACH} from "ERC721H/interfaces/IERC721ACH.sol";

// Contract Imports
import {Cre8ors} from "../../src/Cre8ors.sol";
import {FreeMinter} from "../../src/minter/FreeMinter.sol";
import {DummyMetadataRenderer} from "../utils/DummyMetadataRenderer.sol";
import {Cre8ing} from "../../src/Cre8ing.sol";
import {Lockup} from "../../src/utils/Lockup.sol";
import {Cre8ing} from "../../src/Cre8ing.sol";
import {OwnerOfHook} from "../../src/hooks/OwnerOf.sol";
import {TransferHook} from "../../src/hooks/Transfers.sol";
import {Subscription} from "../../src/subscription/Subscription.sol";
import {Cre8orTestBase} from "../utils/Cre8orTestBase.sol";

contract FreeMinterTest is DSTest, StdUtils, Cre8orTestBase {
    Cre8ors public cre8orsPassport;
    FreeMinter public freeMinter;
    Cre8ing public cre8ingBase;
    TransferHook public transferHookCre8orsPassport;
    Lockup lockup = new Lockup();
    OwnerOfHook public ownerOfHook;
    Subscription public subscription;

    uint64 public constant ONE_YEAR_DURATION = 365 days;

    function setUp() public {
        cre8orsPassport = _setUpContracts();
        vm.prank(address(0x12345));
        cre8orsPassport.purchase(4);
        uint256[] memory tokenIds = new uint256[](4);
        for (uint256 i = 0; i < 4; i++) {
            tokenIds[i] = i + 1;
        }
        cre8orsNFTBase = _setUpContracts();
        cre8ingBase = new Cre8ing();
        freeMinter = new FreeMinter({
            _cre8orsNFT: address(cre8orsNFTBase),
            _passportContractAddress: address(cre8orsPassport),
            _usedPassportTokenIds: tokenIds
        });
        subscription = _setupSubscription();

        transferHook = _setupTransferHook();
        ownerOfHook = _setupOwnerOfHook();
    }

    function testSuccessPassportFreeMint(address _buyer) public {
        vm.assume(_buyer != address(0x0));
        vm.assume(_buyer != address(0x12345));
        _setMinterRole(address(freeMinter));

        vm.prank(_buyer);
        uint256 tokenId = cre8orsPassport.purchase(4);
        tokenId = tokenId + 1;
        uint256[] memory tokenIds = new uint256[](4);
        for (uint256 i = 0; i < 4; i++) {
            tokenIds[i] = tokenId + i;
        }
        vm.prank(_buyer);
        freeMinter.mint(tokenIds, _buyer);

        assertEq(
            cre8orsNFTBase.mintedPerAddress(_buyer).totalMints,
            4,
            "should have 4 tokens"
        );
    }

    function testSuccessHasDiscount(address _buyer) public {
        vm.assume(_buyer != address(0x0));
        vm.assume(_buyer != address(0x12345));
        _setMinterRole(address(freeMinter));
        address[] memory addresses = new address[](1);
        addresses[0] = _buyer;
        vm.prank(DEFAULT_OWNER_ADDRESS);
        freeMinter.addDiscount(addresses);

        freeMinter.mint(new uint256[](0), _buyer);
        assertEq(
            cre8orsNFTBase.mintedPerAddress(_buyer).totalMints,
            1,
            "should have 1 token"
        );
    }

    function testSuccessHasPassportAndDiscount(address _buyer) public {
        vm.assume(_buyer != address(0x0));
        vm.assume(_buyer != address(0x12345));
        _setMinterRole(address(freeMinter));

        //add discount
        address[] memory addresses = new address[](1);
        addresses[0] = _buyer;
        vm.prank(DEFAULT_OWNER_ADDRESS);
        freeMinter.addDiscount(addresses);

        //purchase passport
        vm.prank(_buyer);
        uint256 tokenId = cre8orsPassport.purchase(4);
        tokenId = tokenId + 1;
        uint256[] memory tokenIds = new uint256[](4);
        for (uint256 i = 0; i < 4; i++) {
            tokenIds[i] = tokenId + i;
        }

        // mint
        vm.prank(_buyer);
        freeMinter.mint(tokenIds, _buyer);
        assertEq(
            cre8orsNFTBase.mintedPerAddress(_buyer).totalMints,
            5,
            "total mints should be 5"
        );
    }

    function testRevertNoDuplicates(address _buyer) public {
        vm.assume(_buyer != address(0x0));
        vm.assume(_buyer != address(0x12345));
        _setMinterRole(address(freeMinter));

        vm.prank(_buyer);
        uint256 tokenId = cre8orsPassport.purchase(4);
        tokenId = tokenId + 1;
        uint256[] memory tokenIds = new uint256[](4);
        for (uint256 i = 0; i < 4; i++) {
            tokenIds[i] = tokenId;
        }
        vm.prank(_buyer);
        vm.expectRevert(IFreeMinter.DuplicatesFound.selector);
        freeMinter.mint(tokenIds, _buyer);
    }

    function testRevertOnlyTokenOwner(address _buyer) public {
        vm.assume(_buyer != address(0x0));
        vm.assume(_buyer != address(0x12345));
        vm.assume(_buyer != address(0x876));
        _setMinterRole(address(freeMinter));

        vm.prank(_buyer);
        uint256 tokenId = cre8orsPassport.purchase(4);
        tokenId = tokenId + 1;
        uint256[] memory tokenIds = new uint256[](4);
        for (uint256 i = 0; i < 4; i++) {
            tokenIds[i] = tokenId + i;
        }
        vm.prank(address(0x876));
        vm.expectRevert(IERC721A.ApprovalCallerNotOwnerNorApproved.selector);
        freeMinter.mint(tokenIds, address(0x876));
    }

    function testRevertHasFreeMint(address _buyer) public {
        vm.assume(_buyer != address(0x0));
        vm.assume(_buyer != address(0x12345));
        _setMinterRole(address(freeMinter));

        vm.prank(_buyer);
        vm.expectRevert(IFreeMinter.FreeMintAlreadyClaimed.selector);
        freeMinter.mint(new uint256[](0), _buyer);
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

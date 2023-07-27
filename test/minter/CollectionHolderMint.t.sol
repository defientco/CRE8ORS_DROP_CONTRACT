// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;
import {Vm} from "forge-std/Vm.sol";
import {DSTest} from "ds-test/test.sol";
import {console2} from "forge-std/console2.sol";
import {CollectionHolderMint} from "../../src/minter/CollectionHolderMint.sol";
import {Lockup} from "../../src/utils/Lockup.sol";
import {ILockup} from "../../src/interfaces/ILockup.sol";
import {ICre8ors} from "../../src/interfaces/ICre8ors.sol";
import {Cre8orTestBase} from "../utils/Cre8orTestBase.sol";
import {IERC721Drop} from "../../src/interfaces/IERC721Drop.sol";
import {IERC721A} from "../../lib/ERC721A/contracts/interfaces/IERC721A.sol";
import {Cre8ors} from "../../src/Cre8ors.sol";
import {MinterUtilities} from "../../src/utils/MinterUtilities.sol";
import {DummyMetadataRenderer} from "../utils/DummyMetadataRenderer.sol";
import {IMinterUtilities} from "../../src/interfaces/IMinterUtilities.sol";

contract CollectionHolderMintTest is DSTest {
    struct TierInfo {
        uint256 price;
        uint256 lockup;
    }
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
    CollectionHolderMint public minter;
    Vm public constant vm = Vm(HEVM_ADDRESS);
    Lockup lockup = new Lockup();
    bool _withoutLockup = false;

    function setUp() public {
        cre8orsNFTBase = _setUpContracts();
        cre8orsPassport = _setUpContracts();
        minterUtility = new MinterUtilities(address(cre8orsNFTBase));
        minter = new CollectionHolderMint(
            address(cre8orsNFTBase),
            address(minterUtility)
        );
    }

    function testLockup() public {
        assertEq(address(cre8orsNFTBase.lockup()), address(0));
    }

    function testMintingUtility() public {
        assertEq(
            address(minter.minterUtilityContractAddress()),
            address(minterUtility)
        );
    }

    function testMinterValues() public {
        assertEq(minterUtility.getTierInfo(3).price, 150000000000000000);
    }

    function testSetNewMinterContract(
        bool _withLockup,
        address _minter
    ) public {
        _setUpMinter(_withLockup);
        vm.prank(DEFAULT_OWNER_ADDRESS);
        minter.setNewMinterUtilityContractAddress(_minter);
        assertEq(address(minter.minterUtilityContractAddress()), _minter);
    }

    function testSuccessfulMint(
        bool _withLockup,
        address _buyer,
        uint256 _mintQuantity
    ) public {
        vm.assume(_mintQuantity > 0);
        vm.assume(_buyer != address(0));
        vm.assume(_mintQuantity < DEFAULT_EDITION_SIZE);
        _setUpMinter(_withLockup);

        vm.startPrank(_buyer);
        cre8orsPassport.purchase(_mintQuantity);
        assertTrue(
            cre8orsNFTBase.hasRole(
                cre8orsNFTBase.DEFAULT_ADMIN_ROLE(),
                address(minter)
            )
        );
        uint256 pfpID = minter.mint(1, address(cre8orsPassport), _buyer);
        assertEq(1, pfpID);
        assertEq(1, cre8orsNFTBase.balanceOf(_buyer));
        assertEq(
            0,
            cre8orsNFTBase.mintedPerAddress(address(minter)).totalMints
        );
        assertEq(1, cre8orsNFTBase.mintedPerAddress(_buyer).totalMints);
        vm.stopPrank();
    }

    function testTotalMintsWithTransfer(
        address _buyer,
        address _recipient,
        uint256 _mintQuantity
    ) public {
        vm.assume(_mintQuantity > 0);
        vm.assume(_buyer != address(0));
        vm.assume(_mintQuantity < DEFAULT_EDITION_SIZE);

        vm.startPrank(_buyer);
        cre8orsPassport.purchase(_mintQuantity);
        assertEq(
            _mintQuantity,
            cre8orsPassport.mintedPerAddress(_buyer).totalMints
        );

        cre8orsPassport.safeTransferFrom(_buyer, _recipient, 1);
        vm.stopPrank();
        assertEq(
            _mintQuantity,
            cre8orsPassport.mintedPerAddress(_buyer).totalMints
        );
    }

    function testRevertAlreadyClaimed(
        bool _withLockup,
        address _buyer,
        uint256 _passportQuantity
    ) public {
        vm.assume(_buyer != address(0));
        vm.assume(_passportQuantity > 0);
        vm.assume(_passportQuantity < DEFAULT_EDITION_SIZE);
        _setUpMinter(_withLockup);

        vm.startPrank(_buyer);
        cre8orsPassport.purchase(_passportQuantity);
        minter.mint(1, address(cre8orsPassport), _buyer);
        // vm.expectRevert(CollectionHolderMint.AlreadyClaimedFreeMint.selector);
        // minter.mint(1, address(cre8orsPassport), _buyer);
        vm.stopPrank();
    }

    function testRevertNotOwnerOfPassport(
        bool _withLockup,
        address _buyer,
        address _caller,
        uint256 _mintQuantity
    ) public {
        vm.assume(_buyer != address(0));
        vm.assume(_caller != address(0));
        vm.assume(_buyer != _caller);
        vm.assume(_mintQuantity > 0);
        vm.assume(_mintQuantity < DEFAULT_EDITION_SIZE);
        _setUpMinter(_withLockup);

        vm.startPrank(_buyer);
        cre8orsPassport.purchase(_mintQuantity);
        vm.expectRevert(IERC721A.ApprovalCallerNotOwnerNorApproved.selector);
        minter.mint(1, address(cre8orsPassport), _caller);
        vm.stopPrank();
    }

    function _setUpMinter(bool withLockup) internal {
        vm.startPrank(DEFAULT_OWNER_ADDRESS);
        cre8orsNFTBase.grantRole(
            cre8orsNFTBase.DEFAULT_ADMIN_ROLE(),
            address(minter)
        );
        if (withLockup) {
            cre8orsNFTBase.setLockup(lockup);
            console2.log("Lockup address: %s", address(lockup));
            console2.log(
                "minter utility address: %s",
                address((minter.minterUtilityContractAddress()))
            );
            console2.log("log info: %s", minterUtility.getTierInfo(3).price);

            assertTrue(minter.minterUtilityContractAddress() != address(0));
        }

        assertTrue(
            cre8orsNFTBase.hasRole(
                cre8orsNFTBase.DEFAULT_ADMIN_ROLE(),
                address(minter)
            )
        );
        vm.stopPrank();
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
}

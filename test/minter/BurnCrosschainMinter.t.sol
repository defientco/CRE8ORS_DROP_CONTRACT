// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import {Vm} from "forge-std/Vm.sol";
import {DSTest} from "ds-test/test.sol";
import {Cre8ors} from "../../src/Cre8ors.sol";
import {BurnCrosschainMinter} from "../../src/minter/BurnCrosschainMinter.sol";
import {DummyMetadataRenderer} from "../utils/DummyMetadataRenderer.sol";
import {IERC721Drop} from "../../src/interfaces/IERC721Drop.sol";
import {IERC721A} from "lib/ERC721A/contracts/IERC721A.sol";
import {IERC2981, IERC165} from "lib/openzeppelin-contracts/contracts/interfaces/IERC2981.sol";
import {IOwnable} from "../../src/interfaces/IOwnable.sol";
import {Cre8ing} from "../../src/Cre8ing.sol";
import {ICre8ors} from "../../src/interfaces/ICre8ors.sol";

contract BurnCrosschainMinterTest is DSTest {
    Cre8ing public cre8ingBase;
    Cre8ors public cre8orsNFTBase;
    BurnCrosschainMinter public minter;
    Vm public constant vm = Vm(HEVM_ADDRESS);
    DummyMetadataRenderer public dummyRenderer = new DummyMetadataRenderer();
    address public constant DEFAULT_OWNER_ADDRESS = address(0x23499);
    address payable public constant DEFAULT_FUNDS_RECIPIENT_ADDRESS =
        payable(address(0x21303));
    address public constant DEFAULT_BUYER = address(0x111);
    uint64 DEFAULT_EDITION_SIZE = type(uint64).max;
    string public DEFAULT_PASSCODE = "password";

    function setUp() public {
        cre8orsNFTBase = new Cre8ors({
            _contractName: "CRE8ORS",
            _contractSymbol: "CRE8",
            _initialOwner: DEFAULT_OWNER_ADDRESS,
            _fundsRecipient: payable(DEFAULT_FUNDS_RECIPIENT_ADDRESS),
            _editionSize: 800,
            _royaltyBPS: 808,
            _metadataRenderer: dummyRenderer,
            _salesConfig: IERC721Drop.SalesConfiguration({
                publicSaleStart: 0,
                erc20PaymentToken: address(0),
                publicSaleEnd: type(uint64).max,
                presaleStart: 0,
                presaleEnd: 0,
                publicSalePrice: 0.8 ether,
                maxSalePurchasePerAddress: 0,
                presaleMerkleRoot: bytes32(0)
            })
        });

        minter = new BurnCrosschainMinter();

        cre8ingBase = new Cre8ing();
      
    }

    function test_isAdmin() public {
        assertTrue(
            minter.isAdmin(address(cre8orsNFTBase), DEFAULT_OWNER_ADDRESS)
        );
        assertTrue(
            !minter.isAdmin(
                address(cre8orsNFTBase),
                DEFAULT_FUNDS_RECIPIENT_ADDRESS
            )
        );
    }

    function test_initializeWithData_revertAccess_OnlyAdmin() public {
        bytes memory data = abi.encode(
            keccak256(abi.encodePacked(msg.sender)),
            5,
            DEFAULT_PASSCODE
        );
        vm.expectRevert(IERC721Drop.Access_OnlyAdmin.selector);
        minter.initializeWithData(address(cre8orsNFTBase), data);
    }

    function test_initializeWithData() public {
        vm.startPrank(DEFAULT_OWNER_ADDRESS);
        bytes memory data = abi.encode(
            keccak256(abi.encodePacked(msg.sender)),
            5,
            DEFAULT_PASSCODE
        );
        minter.initializeWithData(address(cre8orsNFTBase), data);
    }

    function test_purchase(uint32 burnQuantity) public {
        if (burnQuantity > 88) return;
        vm.startPrank(DEFAULT_OWNER_ADDRESS);
        bytes memory data = abi.encode(
            keccak256(abi.encodePacked(msg.sender)),
            burnQuantity,
            DEFAULT_PASSCODE
        );
        minter.initializeWithData(address(cre8orsNFTBase), data);
        cre8orsNFTBase.grantRole(cre8orsNFTBase.MINTER_ROLE(), address(minter));
        vm.stopPrank();
        uint256 price = calculateDiscountedPrice(
            address(cre8orsNFTBase),
            burnQuantity
        );
        vm.deal(DEFAULT_BUYER, price);
        vm.startPrank(DEFAULT_BUYER);
        data = abi.encode(
            keccak256(abi.encodePacked(msg.sender)),
            burnQuantity,
            keccak256(
                abi.encodePacked(DEFAULT_BUYER, DEFAULT_PASSCODE, uint256(0))
            )
        );
        minter.purchase{value: price}(address(cre8orsNFTBase), data);
        assertEq(cre8orsNFTBase.saleDetails().totalMinted, 1);
    }

    function test_purchase800Minter(uint32 burnQuantity) public {
        // SETUP MINTER
        if (burnQuantity > 88) return;
        vm.startPrank(DEFAULT_OWNER_ADDRESS);
        bytes memory data = abi.encode(
            keccak256(abi.encodePacked(msg.sender)),
            burnQuantity,
            DEFAULT_PASSCODE
        );
        minter.initializeWithData(address(cre8orsNFTBase), data);
        cre8orsNFTBase.grantRole(cre8orsNFTBase.MINTER_ROLE(), address(minter));
        vm.stopPrank();

        // PURCHASE 800
        vm.startPrank(DEFAULT_BUYER);
        assertEq(cre8orsNFTBase.saleDetails().totalMinted, 0);
        (, uint64 editionSize, , ) = cre8orsNFTBase.config();
        uint256 price = calculateDiscountedPrice(
            address(cre8orsNFTBase),
            burnQuantity
        );
        for (uint256 i = 0; i < editionSize; i++) {
            vm.deal(DEFAULT_BUYER, price);
            data = abi.encode(
                keccak256(abi.encodePacked(DEFAULT_BUYER)),
                burnQuantity,
                keccak256(
                    abi.encodePacked(
                        DEFAULT_BUYER,
                        DEFAULT_PASSCODE,
                        cre8orsNFTBase
                            .mintedPerAddress(DEFAULT_BUYER)
                            .totalMints
                    )
                )
            );
            minter.purchase{value: price}(address(cre8orsNFTBase), data);
        }
        assertEq(cre8orsNFTBase.saleDetails().totalMinted, 800);

        // VERIFY SOLD OUT
        data = abi.encode(
            keccak256(abi.encodePacked(DEFAULT_BUYER)),
            burnQuantity,
            keccak256(
                abi.encodePacked(
                    DEFAULT_BUYER,
                    DEFAULT_PASSCODE,
                    cre8orsNFTBase.mintedPerAddress(DEFAULT_BUYER).totalMints
                )
            )
        );
        vm.deal(DEFAULT_BUYER, price);
        vm.expectRevert(IERC721Drop.Mint_SoldOut.selector);
        minter.purchase{value: price}(address(cre8orsNFTBase), data);
    }

    function test_purchase800() public {
        // SETUP MINTER
        vm.startPrank(DEFAULT_OWNER_ADDRESS);
        bytes memory data = abi.encode(
            keccak256(abi.encodePacked(msg.sender)),
            5,
            "myPasscode"
        );
        minter.initializeWithData(address(cre8orsNFTBase), data);
        cre8orsNFTBase.grantRole(cre8orsNFTBase.MINTER_ROLE(), address(minter));
        vm.stopPrank();

        // PURCHASE 800
        vm.startPrank(DEFAULT_BUYER);
        uint256 quantity = 800;
        uint256 priceToPay = cre8orsNFTBase.saleDetails().publicSalePrice *
            quantity;
        vm.deal(DEFAULT_BUYER, priceToPay);
        assertEq(cre8orsNFTBase.saleDetails().totalMinted, 0);
        cre8orsNFTBase.purchase{value: quantity * 0.8 ether}(quantity);
        assertEq(cre8orsNFTBase.saleDetails().totalMinted, 800);

        // VERIFY SOLD OUT
        vm.expectRevert(IERC721Drop.Mint_SoldOut.selector);
        cre8orsNFTBase.purchase(1);
    }

    function test_purchase400Minter400Payment(uint32 burnQuantity) public {
        if (burnQuantity > 88) return;

        // SETUP MINTER
        vm.startPrank(DEFAULT_OWNER_ADDRESS);
        bytes memory data = abi.encode(
            keccak256(abi.encodePacked(msg.sender)),
            burnQuantity,
            DEFAULT_PASSCODE
        );
        uint256 price = calculateDiscountedPrice(
            address(cre8orsNFTBase),
            burnQuantity
        );
        minter.initializeWithData(address(cre8orsNFTBase), data);
        cre8orsNFTBase.grantRole(cre8orsNFTBase.MINTER_ROLE(), address(minter));
        vm.stopPrank();

        // PURCHASE 800
        vm.startPrank(DEFAULT_BUYER);
        (, uint64 editionSize, , ) = cre8orsNFTBase.config();
        vm.deal(
            DEFAULT_BUYER,
            (cre8orsNFTBase.saleDetails().publicSalePrice + price) * editionSize
        );
        assertEq(cre8orsNFTBase.saleDetails().totalMinted, 0);

        for (uint256 i = 0; i < editionSize / 2; i++) {
            data = abi.encode(
                keccak256(abi.encodePacked(msg.sender)),
                burnQuantity,
                keccak256(
                    abi.encodePacked(
                        DEFAULT_BUYER,
                        DEFAULT_PASSCODE,
                        cre8orsNFTBase
                            .mintedPerAddress(DEFAULT_BUYER)
                            .totalMints
                    )
                )
            );
            minter.purchase{value: price}(address(cre8orsNFTBase), data);
            cre8orsNFTBase.purchase{value: 0.8 ether}(1);
        }
        assertEq(cre8orsNFTBase.saleDetails().totalMinted, 800);

        // VERIFY SOLD OUT
        data = abi.encode(
            keccak256(abi.encodePacked(msg.sender)),
            burnQuantity,
            keccak256(
                abi.encodePacked(
                    DEFAULT_BUYER,
                    DEFAULT_PASSCODE,
                    cre8orsNFTBase.mintedPerAddress(DEFAULT_BUYER).totalMints
                )
            )
        );
        vm.expectRevert(IERC721Drop.Mint_SoldOut.selector);
        minter.purchase{value: price}(address(cre8orsNFTBase), data);
        vm.expectRevert(IERC721Drop.Mint_SoldOut.selector);
        cre8orsNFTBase.purchase{value: 0.8 ether}(1);
    }

    // test admin mint non-admin permissions
    function test_AdminMintBatch() public {
        vm.startPrank(DEFAULT_OWNER_ADDRESS);
        cre8orsNFTBase.adminMint(DEFAULT_OWNER_ADDRESS, 100);
        assertEq(cre8orsNFTBase.saleDetails().totalMinted, 100);
        assertEq(cre8orsNFTBase.balanceOf(DEFAULT_OWNER_ADDRESS), 100);
    }

    function test_AdminMintBatchFails() public {
        vm.startPrank(address(0x10));
        bytes32 role = cre8orsNFTBase.MINTER_ROLE();
        vm.expectRevert(
            abi.encodeWithSignature(
                "AdminAccess_MissingRoleOrAdmin(bytes32)",
                role
            )
        );
        cre8orsNFTBase.adminMint(address(0x10), 100);
    }

    function test_withdraw(uint32 burnQuantity) public {
        if (burnQuantity > 88) return;
        vm.startPrank(DEFAULT_OWNER_ADDRESS);
        bytes memory data = abi.encode(
            keccak256(abi.encodePacked(msg.sender)),
            burnQuantity,
            DEFAULT_PASSCODE
        );
        minter.initializeWithData(address(cre8orsNFTBase), data);
        cre8orsNFTBase.grantRole(cre8orsNFTBase.MINTER_ROLE(), address(minter));
        vm.stopPrank();
        uint256 price = calculateDiscountedPrice(
            address(cre8orsNFTBase),
            burnQuantity
        );
        vm.deal(DEFAULT_BUYER, price);
        vm.startPrank(DEFAULT_BUYER);
        assertEq(cre8orsNFTBase.owner().balance, 0);
        data = abi.encode(
            keccak256(abi.encodePacked(DEFAULT_BUYER)),
            burnQuantity,
            keccak256(
                abi.encodePacked(
                    DEFAULT_BUYER,
                    DEFAULT_PASSCODE,
                    cre8orsNFTBase.mintedPerAddress(DEFAULT_BUYER).totalMints
                )
            )
        );
        minter.purchase{value: price}(address(cre8orsNFTBase), data);
        minter.withdraw(address(cre8orsNFTBase));
        assertEq(cre8orsNFTBase.owner().balance, price);
        assertEq(cre8orsNFTBase.saleDetails().totalMinted, 1);
    }

    function test_purchase_revert_WrongCode(uint32 burnQuantity) public {
        if (burnQuantity > 88) return;
        vm.startPrank(DEFAULT_OWNER_ADDRESS);
        bytes memory data = abi.encode(
            keccak256(abi.encodePacked(msg.sender)),
            burnQuantity,
            "myPasscode"
        );
        minter.initializeWithData(address(cre8orsNFTBase), data);
        cre8orsNFTBase.grantRole(cre8orsNFTBase.MINTER_ROLE(), address(minter));
        vm.stopPrank();
        uint256 price = calculateDiscountedPrice(
            address(cre8orsNFTBase),
            burnQuantity
        );
        vm.deal(DEFAULT_BUYER, price);
        vm.startPrank(DEFAULT_BUYER);

        // VERIFY REVERT
        vm.expectRevert(BurnCrosschainMinter.Code_Incorrect.selector);
        minter.purchase{value: price}(address(cre8orsNFTBase), data);
        assertEq(cre8orsNFTBase.saleDetails().totalMinted, 0);
    }

    function calculateDiscountedPrice(
        address target,
        uint256 burnQuantity
    ) internal view returns (uint256) {
        require(burnQuantity < 89, "CRE8ORS: max burn 88");
        uint256 price = IERC721Drop(target).saleDetails().publicSalePrice;
        uint256 discountPerRelic = (price / 88);
        return price - (discountPerRelic * burnQuantity);
    }
}

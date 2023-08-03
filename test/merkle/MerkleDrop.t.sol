// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import {Vm} from "forge-std/Vm.sol";
import {DSTest} from "ds-test/test.sol";
import {IERC721Drop} from "../../src/interfaces/IERC721Drop.sol";
import {Cre8orsCollective} from "../../src/Cre8orsCollective.sol";
import {DummyMetadataRenderer} from "../utils/DummyMetadataRenderer.sol";
import {MerkleData} from "./MerkleData.sol";

contract MerkleDropTest is DSTest {
    Cre8orsCollective zoraNFTBase;
    Vm public constant vm = Vm(HEVM_ADDRESS);
    DummyMetadataRenderer public dummyRenderer = new DummyMetadataRenderer();
    MerkleData public merkleData;
    address public constant DEFAULT_OWNER_ADDRESS = address(0x23499);
    address payable public constant DEFAULT_FUNDS_RECIPIENT_ADDRESS =
        payable(address(0x21303));
    address payable public constant DEFAULT_ZORA_DAO_ADDRESS =
        payable(address(0x999));
    address public constant mediaContract = address(0x123456);

    function setUp() public {
        vm.prank(DEFAULT_ZORA_DAO_ADDRESS);

        zoraNFTBase = new Cre8orsCollective({
            _contractName: "Test NFT",
            _contractSymbol: "TNFT",
            _initialOwner: DEFAULT_OWNER_ADDRESS,
            _fundsRecipient: payable(DEFAULT_FUNDS_RECIPIENT_ADDRESS),
            _editionSize: 888,
            _royaltyBPS: 800,
            _salesConfig: IERC721Drop.SalesConfiguration({
                publicSaleStart: 0,
                publicSaleEnd: 0,
                presaleStart: 0,
                presaleEnd: 0,
                publicSalePrice: 0,
                maxSalePurchasePerAddress: 0,
                erc20PaymentToken: address(0),
                presaleMerkleRoot: bytes32(0)
            }),
            _metadataRenderer: dummyRenderer
        });
        merkleData = new MerkleData();
    }

    function test_MerklePurchaseActiveSuccess() public {
        vm.startPrank(DEFAULT_OWNER_ADDRESS);
        zoraNFTBase.setSaleConfiguration({
            publicSaleStart: 0,
            publicSaleEnd: 0,
            presaleStart: 0,
            presaleEnd: type(uint64).max,
            publicSalePrice: 0 ether,
            maxSalePurchasePerAddress: 0,
            erc20PaymentToken: address(0),
            presaleMerkleRoot: merkleData
                .getTestSetByName("test-3-addresses")
                .root
        });
        vm.stopPrank();

        MerkleData.MerkleEntry memory item;

        item = merkleData.getTestSetByName("test-3-addresses").entries[0];
        vm.deal(address(item.user), 1 ether);
        vm.startPrank(address(item.user));

        zoraNFTBase.purchasePresale{value: item.mintPrice}(
            1,
            item.maxMint,
            item.mintPrice,
            item.proof
        );
        assertEq(zoraNFTBase.saleDetails().maxSupply, 888);
        assertEq(zoraNFTBase.saleDetails().totalMinted, 1);
        require(
            zoraNFTBase.ownerOf(1) == address(item.user),
            "owner is wrong for new minted token"
        );
        vm.stopPrank();

        item = merkleData.getTestSetByName("test-3-addresses").entries[1];
        vm.deal(address(item.user), 1 ether);
        vm.startPrank(address(item.user));
        zoraNFTBase.purchasePresale{value: item.mintPrice * 2}(
            2,
            item.maxMint,
            item.mintPrice,
            item.proof
        );
        assertEq(zoraNFTBase.saleDetails().maxSupply, 888);
        assertEq(zoraNFTBase.saleDetails().totalMinted, 3);
        require(
            zoraNFTBase.ownerOf(2) == address(item.user),
            "owner is wrong for new minted token"
        );
        vm.stopPrank();
    }

    function test_MerklePurchaseAndPublicSalePurchaseLimits() public {
        vm.startPrank(DEFAULT_OWNER_ADDRESS);
        zoraNFTBase.setSaleConfiguration({
            publicSaleStart: 0,
            publicSaleEnd: type(uint64).max,
            presaleStart: 0,
            presaleEnd: type(uint64).max,
            publicSalePrice: 0.1 ether,
            maxSalePurchasePerAddress: 1,
            erc20PaymentToken: address(0),
            presaleMerkleRoot: merkleData.getTestSetByName("test-2-prices").root
        });
        vm.stopPrank();

        MerkleData.MerkleEntry memory item;

        item = merkleData.getTestSetByName("test-2-prices").entries[0];
        vm.deal(address(item.user), 1 ether);
        vm.startPrank(address(item.user));

        vm.expectRevert(IERC721Drop.Presale_TooManyForAddress.selector);
        zoraNFTBase.purchasePresale{value: item.mintPrice * 3}(
            3,
            item.maxMint,
            item.mintPrice,
            item.proof
        );

        zoraNFTBase.purchasePresale{value: item.mintPrice * 1}(
            1,
            item.maxMint,
            item.mintPrice,
            item.proof
        );
        zoraNFTBase.purchasePresale{value: item.mintPrice * 1}(
            1,
            item.maxMint,
            item.mintPrice,
            item.proof
        );
        assertEq(zoraNFTBase.saleDetails().totalMinted, 2);
        require(
            zoraNFTBase.ownerOf(1) == address(item.user),
            "owner is wrong for new minted token"
        );

        vm.expectRevert(IERC721Drop.Presale_TooManyForAddress.selector);
        zoraNFTBase.purchasePresale{value: item.mintPrice * 1}(
            1,
            item.maxMint,
            item.mintPrice,
            item.proof
        );

        zoraNFTBase.purchase{value: 0.1 ether}(1);
        require(
            zoraNFTBase.ownerOf(3) == address(item.user),
            "owner is wrong for new minted token"
        );
        vm.expectRevert(IERC721Drop.Purchase_TooManyForAddress.selector);
        zoraNFTBase.purchase{value: 0.1 ether}(1);
        vm.stopPrank();
    }

    function test_MerklePurchaseAndPublicSaleEditionSizeZero() public {
        vm.prank(DEFAULT_ZORA_DAO_ADDRESS);
        Cre8orsCollective zeroEditions = new Cre8orsCollective({
            _contractName: "Test NFT",
            _contractSymbol: "TNFT",
            _initialOwner: DEFAULT_OWNER_ADDRESS,
            _fundsRecipient: payable(DEFAULT_FUNDS_RECIPIENT_ADDRESS),
            _editionSize: 0,
            _royaltyBPS: 800,
            _salesConfig: IERC721Drop.SalesConfiguration({
                publicSaleStart: 0,
                publicSaleEnd: 0,
                presaleStart: 0,
                presaleEnd: 0,
                publicSalePrice: 0,
                maxSalePurchasePerAddress: 0,
                erc20PaymentToken: address(0),
                presaleMerkleRoot: bytes32(0)
            }),
            _metadataRenderer: dummyRenderer
        });
        vm.startPrank(DEFAULT_OWNER_ADDRESS);
        zeroEditions.setSaleConfiguration({
            publicSaleStart: 0,
            publicSaleEnd: type(uint64).max,
            presaleStart: 0,
            presaleEnd: type(uint64).max,
            publicSalePrice: 0.1 ether,
            erc20PaymentToken: address(0),
            maxSalePurchasePerAddress: 1,
            presaleMerkleRoot: merkleData.getTestSetByName("test-2-prices").root
        });
        vm.stopPrank();

        MerkleData.MerkleEntry memory item;

        item = merkleData.getTestSetByName("test-2-prices").entries[0];
        vm.deal(address(item.user), 1 ether);
        vm.startPrank(address(item.user));

        vm.expectRevert(IERC721Drop.Mint_SoldOut.selector);
        zeroEditions.purchasePresale{value: item.mintPrice}(
            1,
            item.maxMint,
            item.mintPrice,
            item.proof
        );
        vm.stopPrank();
    }

    function test_MerklePurchaseInactiveFails() public {
        vm.startPrank(DEFAULT_OWNER_ADDRESS);
        // block.timestamp returning zero allows sales to go through.
        vm.warp(100);
        zoraNFTBase.setSaleConfiguration({
            publicSaleStart: 0,
            publicSaleEnd: 0,
            presaleStart: 0,
            presaleEnd: 0,
            erc20PaymentToken: address(0),
            publicSalePrice: 0 ether,
            maxSalePurchasePerAddress: 0,
            presaleMerkleRoot: merkleData
                .getTestSetByName("test-3-addresses")
                .root
        });
        vm.stopPrank();
        vm.deal(address(0x10), 1 ether);

        vm.startPrank(address(0x10));
        MerkleData.MerkleEntry memory item = merkleData
            .getTestSetByName("test-3-addresses")
            .entries[0];
        vm.expectRevert(IERC721Drop.Presale_Inactive.selector);
        zoraNFTBase.purchasePresale{value: item.mintPrice}(
            1,
            item.maxMint,
            item.mintPrice,
            item.proof
        );
    }

    function test_MerklePurchase88Tokens() public {
        vm.startPrank(DEFAULT_OWNER_ADDRESS);
        zoraNFTBase.setSaleConfiguration({
            publicSaleStart: 0,
            publicSaleEnd: 0,
            presaleStart: 0,
            presaleEnd: type(uint64).max,
            publicSalePrice: 0 ether,
            maxSalePurchasePerAddress: 0,
            erc20PaymentToken: address(0),
            presaleMerkleRoot: merkleData
                .getTestSetByName("test-88-founders")
                .root
        });
        vm.stopPrank();

        MerkleData.MerkleEntry memory item;

        uint256 numberOfFounders = merkleData
            .getTestSetByName("test-88-founders")
            .entries
            .length;
        for (uint256 i = 0; i < numberOfFounders; i++) {
            item = merkleData.getTestSetByName("test-88-founders").entries[i];
            vm.startPrank(address(item.user));

            zoraNFTBase.purchasePresale(
                1,
                item.maxMint,
                item.mintPrice,
                item.proof
            );
            assertEq(zoraNFTBase.saleDetails().maxSupply, 888);
            assertEq(zoraNFTBase.saleDetails().totalMinted, i + 1);
            require(
                zoraNFTBase.ownerOf(i + 1) == address(item.user),
                "owner is wrong for new minted token"
            );

            vm.expectRevert();
            zoraNFTBase.purchasePresale(
                1,
                item.maxMint,
                item.mintPrice,
                item.proof
            );
            vm.stopPrank();
        }
        assertEq(zoraNFTBase.saleDetails().maxSupply, 888);
        assertEq(zoraNFTBase.saleDetails().totalMinted, 88);
    }
}

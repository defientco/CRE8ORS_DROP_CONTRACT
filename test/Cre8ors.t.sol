// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import "forge-std/Test.sol";
import {Cre8ors} from "../src/Cre8ors.sol";
import {DummyMetadataRenderer} from "./utils/DummyMetadataRenderer.sol";
import {IERC721Drop} from "../src/interfaces/IERC721Drop.sol";

contract CounterTest is Test {
    Cre8ors public cre8orsNFTBase;

    DummyMetadataRenderer public dummyRenderer = new DummyMetadataRenderer();
    address public constant DEFAULT_OWNER_ADDRESS = address(0x23499);
    address payable public constant DEFAULT_FUNDS_RECIPIENT_ADDRESS =
        payable(address(0x21303));
    uint64 DEFAULT_EDITION_SIZE = 10_000;

    modifier setupCre8orsNFTBase(uint64 editionSize) {
        cre8orsNFTBase = new Cre8ors({
            _contractName: "CRE8ORS",
            _contractSymbol: "CRE8",
            _initialOwner: DEFAULT_OWNER_ADDRESS,
            _fundsRecipient: payable(DEFAULT_FUNDS_RECIPIENT_ADDRESS),
            _editionSize: editionSize,
            _royaltyBPS: 808,
            _metadataRenderer: dummyRenderer,
            _metadataRendererInit: "",
            _salesConfig: IERC721Drop.SalesConfiguration({
                publicSaleStart: 0,
                publicSaleEnd: 0,
                presaleStart: 0,
                presaleEnd: 0,
                publicSalePrice: 0,
                maxSalePurchasePerAddress: 0,
                presaleMerkleRoot: bytes32(0)
            })
        });

        _;
    }

    function test_Erc721() public setupCre8orsNFTBase(DEFAULT_EDITION_SIZE) {
        assertEq("CRE8ORS", cre8orsNFTBase.name());
        assertEq("CRE8", cre8orsNFTBase.symbol());
        assertEq(DEFAULT_EDITION_SIZE, cre8orsNFTBase.saleDetails().maxSupply);
    }

    function test_Purchase(uint64 amount)
        public
        setupCre8orsNFTBase(DEFAULT_EDITION_SIZE)
    {
        vm.prank(DEFAULT_OWNER_ADDRESS);
        cre8orsNFTBase.setSaleConfiguration({
            publicSaleStart: 0,
            publicSaleEnd: type(uint64).max,
            presaleStart: 0,
            presaleEnd: 0,
            publicSalePrice: amount,
            maxSalePurchasePerAddress: 2,
            presaleMerkleRoot: bytes32(0)
        });

        vm.deal(address(456), uint256(amount) * 2);
        vm.prank(address(456));
        cre8orsNFTBase.purchase{value: amount}(1);

        assertEq(cre8orsNFTBase.saleDetails().maxSupply, DEFAULT_EDITION_SIZE);
        assertEq(cre8orsNFTBase.saleDetails().totalMinted, 1);
        require(
            cre8orsNFTBase.ownerOf(1) == address(456),
            "owner is wrong for new minted token"
        );
        assertEq(address(cre8orsNFTBase).balance, amount);
    }
}

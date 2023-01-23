// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import "forge-std/Test.sol";
import {Cre8ing} from "../src/Cre8ing.sol";
import {Cre8ors} from "../src/Cre8ors.sol";
import {TraitRenderer} from "../src/TraitRenderer.sol";
import {DummyMetadataRenderer} from "./utils/DummyMetadataRenderer.sol";
import {IERC721Drop} from "../src/interfaces/IERC721Drop.sol";
import {Strings} from "lib/openzeppelin-contracts/contracts/utils/Strings.sol";

contract TraitRendererTest is Test {
    TraitRenderer public traitRenderer;
    Cre8ing public cre8ingBase;
    Cre8ors public cre8orsNFTBase;
    DummyMetadataRenderer public dummyRenderer = new DummyMetadataRenderer();

    address public constant DEFAULT_OWNER_ADDRESS = address(0x23499);
    address public constant DEFAULT_CRE8OR_ADDRESS = address(456);
    address public constant DEFAULT_TRANSFER_ADDRESS = address(0x2);

    function setUp() public {
        cre8ingBase = new Cre8ing(DEFAULT_OWNER_ADDRESS);
    }

    modifier setupCre8orsNFTBase() {
        cre8orsNFTBase = new Cre8ors({
            _contractName: "CRE8ORS",
            _contractSymbol: "CRE8",
            _initialOwner: DEFAULT_OWNER_ADDRESS,
            _fundsRecipient: payable(DEFAULT_OWNER_ADDRESS),
            _editionSize: 10_000,
            _royaltyBPS: 808,
            _metadataRenderer: dummyRenderer,
            _metadataURIBase: "",
            _metadataContractURI: "",
            _salesConfig: IERC721Drop.SalesConfiguration({
                publicSaleStart: 0,
                publicSaleEnd: uint64(block.timestamp + 1000),
                presaleStart: 0,
                presaleEnd: 0,
                publicSalePrice: 0,
                maxSalePurchasePerAddress: 0,
                presaleMerkleRoot: bytes32(0)
            })
        });

        _;
    }

    function test_trait(uint256 _trait) public {
        string memory trait = traitRenderer.trait(_trait);
        assertEq(trait, "");
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import {Vm} from "forge-std/Vm.sol";
import {DSTest} from "ds-test/test.sol";
import {Cre8ors} from "../src/Cre8ors.sol";
import {DummyMetadataRenderer} from "./utils/DummyMetadataRenderer.sol";
import {IERC721Drop} from "../src/interfaces/IERC721Drop.sol";
import {IERC721A} from "lib/ERC721A/contracts/IERC721A.sol";
import {IERC2981, IERC165} from "lib/openzeppelin-contracts/contracts/interfaces/IERC2981.sol";
import {IOwnable} from "../src/interfaces/IOwnable.sol";
import {ERC721AC} from "lib/creator-token-contracts/contracts/erc721c/ERC721AC.sol";

contract Cre8ors721ACTest is DSTest {
    Cre8ors public cre8orsNFTBase;
    Vm public constant vm = Vm(HEVM_ADDRESS);
    DummyMetadataRenderer public dummyRenderer = new DummyMetadataRenderer();
    address public constant DEFAULT_OWNER_ADDRESS = address(0x23499);
    address payable public constant DEFAULT_FUNDS_RECIPIENT_ADDRESS =
        payable(address(0x21303));
    uint64 DEFAULT_EDITION_SIZE = 10_000;

    function setUp() public {
        cre8orsNFTBase = new Cre8ors({
            _contractName: "CRE8ORS",
            _contractSymbol: "CRE8",
            _initialOwner: DEFAULT_OWNER_ADDRESS,
            _fundsRecipient: payable(DEFAULT_FUNDS_RECIPIENT_ADDRESS),
            _editionSize: DEFAULT_EDITION_SIZE,
            _royaltyBPS: 808,
            _metadataRenderer: dummyRenderer,
            _salesConfig: IERC721Drop.SalesConfiguration({
                publicSaleStart: 0,
                erc20PaymentToken: address(0),
                publicSaleEnd: 0,
                presaleStart: 0,
                presaleEnd: 0,
                publicSalePrice: 0,
                maxSalePurchasePerAddress: 0,
                presaleMerkleRoot: bytes32(0)
            })
        });
    }

    function test_supportsERC721AC() public {
        assertTrue(
            cre8orsNFTBase.supportsInterface(type(ERC721AC).interfaceId)
        );
    }

    function test_supportsOwnable() public {
        assertTrue(
            cre8orsNFTBase.supportsInterface(type(IOwnable).interfaceId)
        );
    }

    function test_supportsERC2981_NFTRoyaltyStandard() public {
        assertTrue(
            cre8orsNFTBase.supportsInterface(type(IERC2981).interfaceId)
        );
    }

    function test_supportsERC721Drop() public {
        assertTrue(
            cre8orsNFTBase.supportsInterface(type(IERC721Drop).interfaceId)
        );
    }
}

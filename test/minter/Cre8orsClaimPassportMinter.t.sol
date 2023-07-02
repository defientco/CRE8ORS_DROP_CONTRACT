// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import {Vm} from "forge-std/Vm.sol";
import {DSTest} from "ds-test/test.sol";
import {console} from "forge-std/console.sol";
import {Cre8ors} from "../../src/Cre8ors.sol";
import {Cre8orsClaimPassportMinter} from "../../src/minter/Cre8orsClaimPassportMinter.sol";
import {DummyMetadataRenderer} from "../utils/DummyMetadataRenderer.sol";
import {IERC721Drop} from "../../src/interfaces/IERC721Drop.sol";
import {IERC721A} from "lib/ERC721A/contracts/IERC721A.sol";
import {IERC2981, IERC165} from "lib/openzeppelin-contracts/contracts/interfaces/IERC2981.sol";
import {IOwnable} from "../../src/interfaces/IOwnable.sol";

contract Cre8orsClaimPassportMinterTest is DSTest {
    Cre8ors public cre8orsNFTBase;
    Cre8ors public cre8orsPassport;
    Cre8orsClaimPassportMinter public minter;
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

        cre8orsPassport = new Cre8ors({
            _contractName: "CRE8ORS_PASSPORT",
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

        minter = new Cre8orsClaimPassportMinter(
            address(cre8orsNFTBase),
            address(cre8orsPassport)
        );
    }

    function test_purchase() public {
        vm.startPrank(DEFAULT_OWNER_ADDRESS);
        cre8orsPassport.grantRole(
            cre8orsPassport.MINTER_ROLE(),
            address(minter)
        );
        bool minterHasRole = cre8orsPassport.hasRole(
            cre8orsPassport.MINTER_ROLE(),
            address(minter)
        );
        assertTrue(minterHasRole, "Minter does not have role");
        vm.stopPrank();

        uint256 price = 0.8 ether;
        vm.deal(DEFAULT_BUYER, 1 ether);
        vm.startPrank(DEFAULT_BUYER);
        uint256 tokenId = cre8orsNFTBase.purchase{value: price}(1);
        cre8orsNFTBase.approve(address(minter), tokenId + 1);
        uint256 passportId = minter.claimPassport(tokenId + 1);
        vm.stopPrank();
        assertEq(passportId, 1);
    }

    function test_purchase_Wrong_Owner() public {
        vm.startPrank(DEFAULT_OWNER_ADDRESS);
        cre8orsPassport.grantRole(
            cre8orsPassport.MINTER_ROLE(),
            address(minter)
        );
        bool minterHasRole = cre8orsPassport.hasRole(
            cre8orsPassport.MINTER_ROLE(),
            address(minter)
        );
        assertTrue(minterHasRole, "Minter does not have role");
        vm.stopPrank();

        uint256 price = 0.8 ether;
        vm.deal(DEFAULT_BUYER, 1 ether);
        vm.startPrank(DEFAULT_BUYER);
        uint256 tokenId = cre8orsNFTBase.purchase{value: price}(1);
        cre8orsNFTBase.approve(address(minter), tokenId + 1);
        vm.stopPrank();
        vm.startPrank(address(0x123456));
        vm.expectRevert("You do not own this token");
        minter.claimPassport(tokenId + 1);
        vm.stopPrank();
    }
}

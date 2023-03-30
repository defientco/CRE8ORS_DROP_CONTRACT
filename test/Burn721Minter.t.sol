// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import {Vm} from "forge-std/Vm.sol";
import {DSTest} from "ds-test/test.sol";
import {Cre8ors} from "../src/Cre8ors.sol";
import {Burn721Minter} from "../src/Burn721Minter.sol";
import {DummyMetadataRenderer} from "./utils/DummyMetadataRenderer.sol";
import {IERC721Drop} from "../src/interfaces/IERC721Drop.sol";
import {IERC721A} from "lib/ERC721A/contracts/IERC721A.sol";
import {IERC2981, IERC165} from "lib/openzeppelin-contracts/contracts/interfaces/IERC2981.sol";
import {IOwnable} from "../src/interfaces/IOwnable.sol";

contract Burn721MinterTest is DSTest {
    Cre8ors public cre8orsNFTBase;
    Burn721Minter public minter;
    Vm public constant vm = Vm(HEVM_ADDRESS);
    DummyMetadataRenderer public dummyRenderer = new DummyMetadataRenderer();
    address public constant DEFAULT_OWNER_ADDRESS = address(0x23499);
    address payable public constant DEFAULT_FUNDS_RECIPIENT_ADDRESS =
        payable(address(0x21303));
    uint64 DEFAULT_EDITION_SIZE = type(uint64).max;

    function setUp() public {
        cre8orsNFTBase = new Cre8ors({
            _contractName: "CRE8ORS",
            _contractSymbol: "CRE8",
            _initialOwner: DEFAULT_OWNER_ADDRESS,
            _fundsRecipient: payable(DEFAULT_FUNDS_RECIPIENT_ADDRESS),
            _editionSize: type(uint64).max,
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
        minter = new Burn721Minter();
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

    function test_AdminMint() public {
        address minter = address(0x32402);
        vm.startPrank(DEFAULT_OWNER_ADDRESS);
        cre8orsNFTBase.adminMint(DEFAULT_OWNER_ADDRESS, 1);
        require(
            cre8orsNFTBase.balanceOf(DEFAULT_OWNER_ADDRESS) == 1,
            "Wrong balance"
        );
        cre8orsNFTBase.grantRole(cre8orsNFTBase.MINTER_ROLE(), minter);
        vm.stopPrank();
        vm.prank(minter);
        cre8orsNFTBase.adminMint(minter, 1);
        require(cre8orsNFTBase.balanceOf(minter) == 1, "Wrong balance");
        assertEq(cre8orsNFTBase.saleDetails().totalMinted, 2);
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
}

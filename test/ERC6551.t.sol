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
import {ERC6551Registry} from "lib/ERC6551/src/ERC6551Registry.sol";
import {Account} from "lib/tokenbound/src/Account.sol";
import {AccountGuardian} from "lib/tokenbound/src/AccountGuardian.sol";
import {EntryPoint} from "lib/account-abstraction/contracts/core/EntryPoint.sol";
import {Cre8ing} from "../src/Cre8ing.sol";


error NotAuthorized();

contract ERC6551Test is DSTest {
    Cre8ing public cre8ingBase;
    Cre8ors public cre8orsNFTBase;
    Vm public constant vm = Vm(HEVM_ADDRESS);
    ERC6551Registry erc6551Registry;
    AccountGuardian guardian;
    EntryPoint entryPoint;
    Account erc6551Implementation;
    DummyMetadataRenderer public dummyRenderer = new DummyMetadataRenderer();
    address public constant DEFAULT_OWNER_ADDRESS = address(0x23499);
    address payable public constant DEFAULT_FUNDS_RECIPIENT_ADDRESS =
        payable(address(0x21303));
    address constant DEAD_ADDRESS =
        address(0x000000000000000000000000000000000000dEaD);
    uint64 DEFAULT_EDITION_SIZE = 8888;

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
                publicSaleEnd: type(uint64).max,
                presaleStart: 0,
                presaleEnd: 0,
                publicSalePrice: 0,
                maxSalePurchasePerAddress: 0,
                presaleMerkleRoot: bytes32(0)
            })
        });
        vm.chainId(1);
        erc6551Registry = new ERC6551Registry();
        guardian = new AccountGuardian();
        entryPoint = new EntryPoint();
        erc6551Implementation = new Account(
            address(guardian),
            address(entryPoint)
        );
        cre8ingBase = new Cre8ing(DEFAULT_OWNER_ADDRESS);

        vm.startPrank(DEFAULT_OWNER_ADDRESS);
        cre8ingBase.setCre8or(cre8orsNFTBase);
        cre8orsNFTBase.setCre8ing(cre8ingBase);
        vm.stopPrank();
    }

    function test_Erc6551Registry() public {
        address tokenBoundAccount = getTBA(1);
        assertTrue(!isContract(tokenBoundAccount));
    }

    function test_setErc6551Registry_revert_Access_OnlyAdmin() public {
        vm.expectRevert(IERC721Drop.Access_OnlyAdmin.selector);
        cre8orsNFTBase.setErc6551Registry(address(erc6551Registry));
    }

    function test_setErc6551Implementation_revert_Access_OnlyAdmin() public {
        vm.expectRevert(IERC721Drop.Access_OnlyAdmin.selector);
        cre8orsNFTBase.setErc6551Implementation(address(erc6551Implementation));
    }

    function test_createAccount() public setupErc6551 {
        address tokenBoundAccount = getTBA(1);

        // MINT REGISTERS WITH ERC6511
        assertTrue(!isContract(tokenBoundAccount));
        cre8orsNFTBase.purchase(1);
        assertTrue(isContract(tokenBoundAccount));
    }

    function test_createMultipleAccounts() public setupErc6551 {
        uint256 quantity = 88;

        // No ERC6551 before purchase
        for (uint256 i = 1; i <= quantity; i++) {
            address tokenBoundAccount = getTBA(i);
            assertTrue(!isContract(tokenBoundAccount));
        }

        // MINT REGISTERS WITH ERC6511
        cre8orsNFTBase.purchase(quantity);

        // All CRE8ORS have ERC6551 after purchase
        for (uint256 i = 1; i <= quantity; i++) {
            address tokenBoundAccount = getTBA(i);
            assertTrue(isContract(tokenBoundAccount));
        }
    }

    function test_sendWithTBA() public setupErc6551 {
        address payable tokenBoundAccount = payable(getTBA(1));

        // MINT REGISTERS WITH ERC6511
        assertTrue(!isContract(tokenBoundAccount));
        cre8orsNFTBase.purchase(3);
        assertTrue(isContract(tokenBoundAccount));

        // TBA used to mint another CRE8OR
        assertEq(cre8orsNFTBase.balanceOf(tokenBoundAccount), 0);
        uint256 value;
        bytes memory data = abi.encodeWithSignature("purchase(uint256)", 1);
        bytes memory response = Account(tokenBoundAccount).executeCall(
            address(cre8orsNFTBase),
            value,
            data
        );
        uint256 tokenId = abi.decode(response, (uint256));
        assertEq(cre8orsNFTBase.balanceOf(tokenBoundAccount), 1);

        // use TBA to burn CRE8OR
        data = abi.encodeWithSignature(
            "safeTransferFrom(address,address,uint256)",
            tokenBoundAccount,
            DEAD_ADDRESS,
            tokenId + 1
        );
        Account(tokenBoundAccount).executeCall(
            address(cre8orsNFTBase),
            value,
            data
        );
        assertEq(cre8orsNFTBase.balanceOf(tokenBoundAccount), 0);
    }

    function test_sendWithTBA_revert_NotAuthorized() public setupErc6551 {
        address payable tokenBoundAccount = payable(getTBA(1));

        // MINT REGISTERS WITH ERC6511
        assertTrue(!isContract(tokenBoundAccount));
        vm.prank(DEFAULT_OWNER_ADDRESS);
        cre8orsNFTBase.purchase(3);
        assertTrue(isContract(tokenBoundAccount));

        // TBA used to mint another CRE8OR
        assertEq(cre8orsNFTBase.balanceOf(tokenBoundAccount), 0);
        uint256 value;
        bytes memory data = abi.encodeWithSignature("purchase(uint256)", 1);
        vm.expectRevert(NotAuthorized.selector);
        Account(tokenBoundAccount).executeCall(
            address(cre8orsNFTBase),
            value,
            data
        );
        assertEq(cre8orsNFTBase.balanceOf(tokenBoundAccount), 0);
    }

    function test_transfer_only() public setupErc6551 {
        uint256 quantity = 888;
        address BUYER = address(0x123);
        vm.startPrank(BUYER);
        cre8orsNFTBase.purchase(quantity);
        for (uint256 i = 1; i <= quantity; i++) {
            cre8orsNFTBase.safeTransferFrom(BUYER, DEAD_ADDRESS, i);
        }
    }

    modifier setupErc6551() {
        vm.startPrank(DEFAULT_OWNER_ADDRESS);
        cre8orsNFTBase.setErc6551Registry(address(erc6551Registry));
        cre8orsNFTBase.setErc6551Implementation(address(erc6551Implementation));
        vm.stopPrank();
        _;
    }

    function isContract(address _addr) private view returns (bool) {
        uint32 size;
        assembly {
            size := extcodesize(_addr)
        }
        return (size > 0);
    }

    function getTBA(uint256 tokenId) private view returns (address) {
        address payable tokenBoundAccount = payable(
            erc6551Registry.account(
                address(erc6551Implementation),
                1,
                address(cre8orsNFTBase),
                tokenId,
                0
            )
        );
        return tokenBoundAccount;
    }
}

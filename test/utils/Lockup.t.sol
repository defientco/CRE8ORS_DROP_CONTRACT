// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import {Vm} from "forge-std/Vm.sol";
import {DSTest} from "ds-test/test.sol";
import {Cre8ors} from "../../src/Cre8ors.sol";
import {DummyMetadataRenderer} from "./DummyMetadataRenderer.sol";
import {IERC721Drop} from "../../src/interfaces/IERC721Drop.sol";
import {Lockup} from "../../src/utils/Lockup.sol";
import {IERC721A} from "lib/ERC721A/contracts/IERC721A.sol";
import {IERC2981, IERC165} from "lib/openzeppelin-contracts/contracts/interfaces/IERC2981.sol";
import {IOwnable} from "../../src/interfaces/IOwnable.sol";
import {ERC721AC} from "lib/creator-token-contracts/contracts/erc721c/ERC721AC.sol";
import {CreatorTokenTransferValidator} from "lib/creator-token-contracts/contracts/utils/CreatorTokenTransferValidator.sol";
import {TransferSecurityLevels} from "lib/creator-token-contracts/contracts/utils/TransferPolicy.sol";

contract LockupTest is DSTest {
    Cre8ors public cre8orsNFTBase;
    Vm public constant vm = Vm(HEVM_ADDRESS);
    DummyMetadataRenderer public dummyRenderer = new DummyMetadataRenderer();
    address public constant DEFAULT_OWNER_ADDRESS = address(0x23499);
    address payable public constant DEFAULT_FUNDS_RECIPIENT_ADDRESS =
        payable(address(0x21303));
    uint64 DEFAULT_EDITION_SIZE = 10_000;
    uint16 DEFAULT_ROYALTY_BPS = 888;
    CreatorTokenTransferValidator public transferValidator;
    address whitelistedOperator;
    Lockup lockup = new Lockup();

    function setUp() public {
        vm.startPrank(DEFAULT_OWNER_ADDRESS);
        cre8orsNFTBase = new Cre8ors({
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
        transferValidator = new CreatorTokenTransferValidator(
            DEFAULT_OWNER_ADDRESS
        );
        whitelistedOperator = vm.addr(2);
        transferValidator.addOperatorToWhitelist(1, whitelistedOperator);
        vm.stopPrank();
    }

    function test_lockup() public {
        assertEq(address(cre8orsNFTBase.lockup()), address(0));
    }

    function test_setLockup() public {
        assertEq(address(cre8orsNFTBase.lockup()), address(0));
        vm.prank(DEFAULT_OWNER_ADDRESS);
        cre8orsNFTBase.setLockup(lockup);
        assertEq(address(cre8orsNFTBase.lockup()), address(lockup));
    }

    function test_setLockup_revert_Access_OnlyAdmin() public {
        assertEq(address(cre8orsNFTBase.lockup()), address(0));
        vm.expectRevert(IERC721Drop.Access_OnlyAdmin.selector);
        cre8orsNFTBase.setLockup(lockup);
        assertEq(address(cre8orsNFTBase.lockup()), address(0));
    }
}

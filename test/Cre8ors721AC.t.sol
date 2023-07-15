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
import {CreatorTokenTransferValidator} from "lib/creator-token-contracts/contracts/utils/CreatorTokenTransferValidator.sol";
import {TransferSecurityLevels} from "lib/creator-token-contracts/contracts/utils/TransferPolicy.sol";

contract Cre8ors721ACTest is DSTest {
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

    function test_royaltyInfo() public {
        uint256 royaltyAmount = 1000;
        (address receiver, uint256 amount) = cre8orsNFTBase.royaltyInfo(
            1,
            royaltyAmount
        );
        assertEq(amount, (royaltyAmount * DEFAULT_ROYALTY_BPS) / 10_000);
        assertEq(receiver, DEFAULT_FUNDS_RECIPIENT_ADDRESS);
    }

    function test_setTransferValidator() public {
        assertEq(address(cre8orsNFTBase.getTransferValidator()), address(0));
        vm.startPrank(DEFAULT_OWNER_ADDRESS);
        cre8orsNFTBase.setTransferValidator(address(transferValidator));
        assertEq(
            address(cre8orsNFTBase.getTransferValidator()),
            address(transferValidator)
        );
    }

    function test_setTransferValidator_revert_requireCallerIsContractOwner()
        public
    {
        assertEq(address(cre8orsNFTBase.getTransferValidator()), address(0));
        vm.expectRevert(IERC721Drop.Access_OnlyAdmin.selector);
        cre8orsNFTBase.setTransferValidator(address(transferValidator));
        assertEq(address(cre8orsNFTBase.getTransferValidator()), address(0));
    }

    function test_PolicyBlocksTransfersWhenCallerNotWhitelistedOrOwner(
        address caller,
        address from,
        address to
    ) public {
        vm.assume(caller != address(cre8orsNFTBase));
        vm.assume(caller != whitelistedOperator);
        vm.assume(caller != address(0));
        vm.assume(caller != from);
        vm.assume(from != address(0));
        vm.assume(from != caller);
        vm.assume(from != address(cre8orsNFTBase));
        vm.assume(to != address(0));
        vm.assume(to != address(cre8orsNFTBase));

        vm.startPrank(DEFAULT_OWNER_ADDRESS);
        cre8orsNFTBase.setTransferValidator(address(transferValidator));
        transferValidator.setTransferSecurityLevelOfCollection(
            address(cre8orsNFTBase),
            TransferSecurityLevels.One
        );
        transferValidator.setOperatorWhitelistOfCollection(
            address(cre8orsNFTBase),
            1
        );
        vm.stopPrank();

        assertTrue(!cre8orsNFTBase.isTransferAllowed(caller, from, to));

        vm.prank(from);
        cre8orsNFTBase.purchase(1);

        vm.prank(from);
        cre8orsNFTBase.setApprovalForAll(caller, true);

        vm.prank(caller);
        vm.expectRevert(
            CreatorTokenTransferValidator
                .CreatorTokenTransferValidator__CallerMustBeWhitelistedOperator
                .selector
        );
        cre8orsNFTBase.transferFrom(from, to, 1);
    }

    function test_policyAllowsTransfersWhenCalledByOwner(
        address tokenOwner,
        address to
    ) public {
        vm.assume(tokenOwner != address(cre8orsNFTBase));
        vm.assume(tokenOwner != whitelistedOperator);
        vm.assume(tokenOwner != address(0));
        vm.assume(to != address(0));
        vm.assume(to != address(cre8orsNFTBase));

        vm.startPrank(DEFAULT_OWNER_ADDRESS);
        cre8orsNFTBase.setTransferValidator(address(transferValidator));
        transferValidator.setTransferSecurityLevelOfCollection(
            address(cre8orsNFTBase),
            TransferSecurityLevels.One
        );
        transferValidator.setOperatorWhitelistOfCollection(
            address(cre8orsNFTBase),
            1
        );
        vm.stopPrank();

        assertTrue(
            cre8orsNFTBase.isTransferAllowed(tokenOwner, tokenOwner, to)
        );

        vm.prank(tokenOwner);
        cre8orsNFTBase.purchase(1);

        vm.prank(tokenOwner);
        cre8orsNFTBase.transferFrom(tokenOwner, to, 1);

        assertEq(cre8orsNFTBase.ownerOf(1), to);
    }

    function test_policyAllowsTransfersWhenCalledByWhitelisted(
        address tokenOwner,
        address to
    ) public {
        vm.assume(tokenOwner != address(cre8orsNFTBase));
        vm.assume(tokenOwner != whitelistedOperator);
        vm.assume(tokenOwner != address(0));
        vm.assume(to != address(0));
        vm.assume(to != address(cre8orsNFTBase));

        vm.startPrank(DEFAULT_OWNER_ADDRESS);
        cre8orsNFTBase.setTransferValidator(address(transferValidator));
        transferValidator.setTransferSecurityLevelOfCollection(
            address(cre8orsNFTBase),
            TransferSecurityLevels.One
        );
        transferValidator.setOperatorWhitelistOfCollection(
            address(cre8orsNFTBase),
            1
        );
        vm.stopPrank();

        vm.prank(tokenOwner);
        cre8orsNFTBase.setApprovalForAll(whitelistedOperator, true);

        assertTrue(
            cre8orsNFTBase.isTransferAllowed(tokenOwner, tokenOwner, to)
        );

        vm.prank(tokenOwner);
        cre8orsNFTBase.purchase(1);

        vm.prank(whitelistedOperator);
        cre8orsNFTBase.transferFrom(tokenOwner, to, 1);

        assertEq(cre8orsNFTBase.ownerOf(1), to);
    }

    function _sanitizeAddress(address addr) internal view virtual {
        vm.assume(addr.code.length == 0);
        vm.assume(uint160(addr) > 0xFF);
        vm.assume(addr != address(0x000000000000000000636F6e736F6c652e6c6f67));
        vm.assume(addr != address(0xDDc10602782af652bB913f7bdE1fD82981Db7dd9));
    }
}

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
import {Cre8ing} from "../../src/Cre8ing.sol";
import {ICre8ors} from "../../src/interfaces/ICre8ors.sol";
import {TransferHook} from "../../src/hooks/Transfers.sol";
import {IERC721ACH} from "ERC721H/interfaces/IERC721ACH.sol";
import {Cre8orTestBase} from "../utils/Cre8orTestBase.sol";

contract Cre8orsClaimPassportMinterTest is DSTest, Cre8orTestBase {
    Cre8ing public cre8ingBase;
    Cre8ors public cre8orsPassport;
    Cre8orsClaimPassportMinter public minter;
    TransferHook public transferHookCre8orsNFTBase;
    TransferHook public transferHookCre8orsPassport;
    string public DEFAULT_PASSCODE = "password";
    address public constant DEFAULT_BUYER = address(0x111);

    function setUp() public {
        cre8orsNFTBase = _deployCre8or();

        cre8orsPassport = _deployCre8or();

        minter = new Cre8orsClaimPassportMinter(
            address(cre8orsNFTBase),
            address(cre8orsPassport)
        );
        cre8ingBase = new Cre8ing();
        transferHookCre8orsNFTBase = new TransferHook(
            address(cre8orsNFTBase),
            address(erc6551Registry),
            address(erc6551Implementation)
        );
        transferHookCre8orsPassport = new TransferHook(
            address(cre8orsPassport),
            address(erc6551Registry),
            address(erc6551Implementation)
        );
        vm.startPrank(DEFAULT_OWNER_ADDRESS);
        transferHookCre8orsNFTBase.setCre8ing(address(cre8ingBase));
        transferHookCre8orsPassport.setCre8ing(address(cre8ingBase));
        cre8orsNFTBase.setHook(
            IERC721ACH.HookType.BeforeTokenTransfers,
            address(transferHookCre8orsNFTBase)
        );
        cre8orsPassport.setHook(
            IERC721ACH.HookType.BeforeTokenTransfers,
            address(transferHookCre8orsPassport)
        );
        vm.stopPrank();
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

        vm.startPrank(DEFAULT_BUYER);
        uint256 tokenId = cre8orsNFTBase.purchase(1);
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

        vm.startPrank(DEFAULT_BUYER);
        uint256 tokenId = cre8orsNFTBase.purchase(1);
        cre8orsNFTBase.approve(address(minter), tokenId + 1);
        vm.stopPrank();
        vm.startPrank(address(0x123456));
        vm.expectRevert("You do not own this token");
        minter.claimPassport(tokenId + 1);
        vm.stopPrank();
    }
}

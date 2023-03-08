// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import "@forge-std/src/Test.sol";
import {Cre8orRewards1155} from "../src/Cre8orRewards1155.sol";

contract Cre8orRewards1155Test is Test {
    Cre8orRewards1155 public rewards;
    address public constant DEFAULT_OWNER_ADDRESS = address(0x23499);

    function setUp() public {
        vm.prank(DEFAULT_OWNER_ADDRESS);
        rewards = new Cre8orRewards1155("uri/{id}");
    }

    function test_Erc1155() public {
        assertEq("uri/{id}", rewards.uri(1));
        assertEq(0, rewards.balanceOf(DEFAULT_OWNER_ADDRESS, 1));
    }

    function test_mint_revert_nonMinterRole(uint256 amount) public {
        vm.expectRevert(
            "ERC1155PresetMinterPauser: must have minter role to mint"
        );
        rewards.mint(DEFAULT_OWNER_ADDRESS, 1, amount, "0x0");
        assertEq(0, rewards.balanceOf(DEFAULT_OWNER_ADDRESS, 1));
        assertEq(0, rewards.totalSupply(1));
    }

    function test_mint(uint256 tokenId, uint256 amount) public {
        vm.startPrank(DEFAULT_OWNER_ADDRESS);
        rewards.mint(DEFAULT_OWNER_ADDRESS, tokenId, amount, "0x0");
        assertEq(amount, rewards.balanceOf(DEFAULT_OWNER_ADDRESS, tokenId));
        assertEq(amount, rewards.totalSupply(tokenId));
    }

    function test_setTokenURI_revert_nonAdminRole(
        uint256 tokenId,
        string memory uri
    ) public {
        vm.expectRevert(
            "ERC1155PresetMinterPauser: must have admin role to change URI"
        );
        rewards.setTokenURI(tokenId, uri);
        assertEq("uri/{id}", rewards.uri(1));
    }

    function test_setTokenURI(uint256 tokenId) public {
        vm.startPrank(DEFAULT_OWNER_ADDRESS);
        rewards.setTokenURI(tokenId, "wagmi");
        assertEq("wagmi", rewards.uri(tokenId));
    }

    function test_airdrop_revert_nonMinterRole(
        address[] memory airdrop,
        uint256 tokenId
    ) public {
        if (airdrop.length == 0) {
            return;
        }
        vm.expectRevert(
            "ERC1155PresetMinterPauser: must have minter role to mint"
        );
        rewards.airdrop(tokenId, airdrop);
        assertEq(rewards.totalSupply(tokenId), 0);
    }

    function test_airdrop(uint256 tokenId) public {
        vm.startPrank(DEFAULT_OWNER_ADDRESS);
        address[] memory airdrop = new address[](3);
        airdrop[0] = address(0x1);
        airdrop[1] = address(0x2);
        airdrop[2] = address(0x3);
        rewards.airdrop(tokenId, airdrop);
        assertEq(rewards.totalSupply(tokenId), airdrop.length);
        assertEq(rewards.balanceOf(address(0x1), tokenId), 1);
        assertEq(rewards.balanceOf(address(0x2), tokenId), 1);
        assertEq(rewards.balanceOf(address(0x3), tokenId), 1);
    }
}

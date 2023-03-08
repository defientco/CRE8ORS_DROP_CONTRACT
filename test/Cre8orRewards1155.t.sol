// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import "@forge-std/src/Test.sol";
import {Cre8orRewards1155} from "../src/Cre8orRewards1155.sol";

contract Cre8orRewards1155Test is Test {
    Cre8orRewards1155 public rewards;
    address public constant DEFAULT_OWNER_ADDRESS = address(0x23499);

    function setUp() public {
        rewards = new Cre8orRewards1155("uri/{id}");
    }

    function test_Erc1155() public {
        assertEq("uri/{id}", rewards.uri(1));
        assertEq(0, rewards.balanceOf(DEFAULT_OWNER_ADDRESS, 1));
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import {DSTest} from "ds-test/test.sol";
import {Vm} from "forge-std/Vm.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";
import {DropMockBase} from "./DropMockBase.sol";
import {Cre8orsCollectiveMetadataRenderer} from "../../src/metadata/Cre8orsCollectiveMetadataRenderer.sol";

contract Cre8orsCollectiveMetadataRendererTest is DSTest {
    Vm public constant vm = Vm(HEVM_ADDRESS);
    address public constant mediaContract = address(123456);
    Cre8orsCollectiveMetadataRenderer public renderer;
    string METADATA_BASE_FOUNDERS = "http://uri.base/";
    string METADATA_BASE_COLLECTIVE = "http://uri.collectiveBase/";
    string CONTRACT_BASE_URL = "http://uri.base/contract.json";

    function setUp() public {
        renderer = new Cre8orsCollectiveMetadataRenderer();
    }

    function getUri(uint256 tokenId) public view returns (string memory) {
        string memory base = tokenId > 88
            ? METADATA_BASE_COLLECTIVE
            : METADATA_BASE_FOUNDERS;
        return string(abi.encodePacked(base, Strings.toString(tokenId)));
    }

    function test_SetupInitializes() public {
        vm.startPrank(address(0x12));
        bytes memory initData = abi.encode(
            METADATA_BASE_FOUNDERS,
            METADATA_BASE_COLLECTIVE,
            CONTRACT_BASE_URL
        );
        renderer.initializeWithData(initData);
        assertEq(renderer.tokenURI(1), getUri(1));
        assertEq(renderer.tokenURI(12), getUri(12));
        assertEq(renderer.tokenURI(89), getUri(89));
        assertEq(renderer.tokenURI(888), getUri(888));
        assertEq(renderer.contractURI(), CONTRACT_BASE_URL);
        vm.stopPrank();
        vm.prank(address(0x14));
        vm.expectRevert();
        renderer.tokenURI(12);
        vm.expectRevert();
        renderer.contractURI();
    }

    function test_UninitalizesReverts() public {
        vm.prank(address(0x12));
        vm.expectRevert();
        renderer.tokenURI(12);
        vm.expectRevert();
        renderer.contractURI();
    }

    function test_UpdateURIsFromContract() public {
        vm.startPrank(address(0x12));
        bytes memory initData = abi.encode(
            METADATA_BASE_FOUNDERS,
            METADATA_BASE_COLLECTIVE,
            CONTRACT_BASE_URL
        );
        renderer.initializeWithData(initData);
        assertEq(renderer.tokenURI(12), getUri(12));
        assertEq(renderer.contractURI(), CONTRACT_BASE_URL);
        renderer.updateMetadataBase(
            address(0x12),
            "http://uri.base.new/",
            "http://uri.base.newCollective/",
            "http://uri.base.new/contract.json"
        );
        assertEq(renderer.tokenURI(1), "http://uri.base.new/1");
        assertEq(renderer.tokenURI(12), "http://uri.base.new/12");
        assertEq(renderer.tokenURI(88), "http://uri.base.new/88");
        assertEq(renderer.tokenURI(89), "http://uri.base.newCollective/89");
        assertEq(renderer.tokenURI(888), "http://uri.base.newCollective/888");
        assertEq(renderer.contractURI(), "http://uri.base.new/contract.json");
    }

    function test_UpdateURIsFromAdmin() public {
        DropMockBase base = new DropMockBase();
        base.setIsAdmin(address(0x123), true);
        vm.startPrank(address(base));
        bytes memory initData = abi.encode(
            METADATA_BASE_FOUNDERS,
            METADATA_BASE_COLLECTIVE,
            CONTRACT_BASE_URL
        );
        renderer.initializeWithData(initData);
        assertEq(renderer.tokenURI(8), getUri(8));
        assertEq(renderer.contractURI(), CONTRACT_BASE_URL);
        vm.stopPrank();
        vm.prank(address(0x123));
        renderer.updateMetadataBase(
            address(base),
            "http://uri.base.new/",
            "http://uri.base.newCollective/",
            "http://uri.base.new/contract.json"
        );
        vm.startPrank(address(base));
        assertEq(renderer.tokenURI(5), "http://uri.base.new/5");
        assertEq(renderer.tokenURI(89), "http://uri.base.newCollective/89");
        assertEq(renderer.contractURI(), "http://uri.base.new/contract.json");
    }
}

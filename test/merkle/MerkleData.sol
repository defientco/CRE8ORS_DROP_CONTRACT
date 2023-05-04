// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

/***
****    :WARNING:
**** This file is auto-generated from a template (MerkleData.sol.ejs).
**** To update, update the template not the resulting test file.
****
****
***/

contract MerkleData {
  struct MerkleEntry {
    address user;
    uint256 maxMint;
    uint256 mintPrice;
    bytes32[] proof;
  }

  struct TestData {
    MerkleEntry[] entries;
    bytes32 root;
  }

  mapping(string => TestData) public data;

  function getTestSetByName(string memory name) external view returns (TestData memory) {
    return data[name];
  }

  constructor() {
    bytes32[] memory proof;
    
    data["test-3-addresses"].root = 0x17fd3b63857e2260948e1b1c1eb2029cbc98e0c78713197225324a234b319cd1;
    
    proof = new bytes32[](2);
    
    proof[0] = bytes32(0x410850346a047658db0d67e0a2755371caf856be5b4692dd69895577f9172d5b);
    
    proof[1] = bytes32(0xc97b6b12a9053ef9561f3ba1a26d6f089fa77055a4a254f71094c89168ae2aaf);
    
    data["test-3-addresses"].entries.push(MerkleEntry({
      user: 0x0000000000000000000000000000000000000010,
      maxMint: 1,
      mintPrice: 10000000000000000,
      proof: proof 
    }));
    
    proof = new bytes32[](2);
    
    proof[0] = bytes32(0x5466cc65fe36e24c9d6533d916f4db0096816deb47bdf805634d105ed273c8ab);
    
    proof[1] = bytes32(0xc97b6b12a9053ef9561f3ba1a26d6f089fa77055a4a254f71094c89168ae2aaf);
    
    data["test-3-addresses"].entries.push(MerkleEntry({
      user: 0x0000000000000000000000000000000000000011,
      maxMint: 2,
      mintPrice: 10000000000000000,
      proof: proof 
    }));
    
    proof = new bytes32[](1);
    
    proof[0] = bytes32(0x0e39a7a99a7f041bb3d20ec2d4724dd9541d631fdaf2c15820def3c077c71e26);
    
    data["test-3-addresses"].entries.push(MerkleEntry({
      user: 0x0000000000000000000000000000000000000012,
      maxMint: 3,
      mintPrice: 10000000000000000,
      proof: proof 
    }));
    
    
    data["test-2-prices"].root = 0xb7d8ff9be4b222c3049431d7b5982cbd3e64e5902f0ca4a2e3527be999a12d87;
    
    proof = new bytes32[](1);
    
    proof[0] = bytes32(0xcd1f92f2177fa8f6c51829045204caf23439f3e448bb0b94e5134e5b9f11ea4c);
    
    data["test-2-prices"].entries.push(MerkleEntry({
      user: 0x0000000000000000000000000000000000000010,
      maxMint: 2,
      mintPrice: 100000000000000000,
      proof: proof 
    }));
    
    proof = new bytes32[](1);
    
    proof[0] = bytes32(0xbabae39e08c9636595a1a4edd5850334f105c1cedb96c37659d1a9e39cb48615);
    
    data["test-2-prices"].entries.push(MerkleEntry({
      user: 0x0000000000000000000000000000000000000010,
      maxMint: 2,
      mintPrice: 200000000000000000,
      proof: proof 
    }));
    
    
    data["test-max-count"].root = 0xb7d8ff9be4b222c3049431d7b5982cbd3e64e5902f0ca4a2e3527be999a12d87;
    
    proof = new bytes32[](1);
    
    proof[0] = bytes32(0xcd1f92f2177fa8f6c51829045204caf23439f3e448bb0b94e5134e5b9f11ea4c);
    
    data["test-max-count"].entries.push(MerkleEntry({
      user: 0x0000000000000000000000000000000000000010,
      maxMint: 2,
      mintPrice: 100000000000000000,
      proof: proof 
    }));
    
    proof = new bytes32[](1);
    
    proof[0] = bytes32(0xbabae39e08c9636595a1a4edd5850334f105c1cedb96c37659d1a9e39cb48615);
    
    data["test-max-count"].entries.push(MerkleEntry({
      user: 0x0000000000000000000000000000000000000010,
      maxMint: 2,
      mintPrice: 200000000000000000,
      proof: proof 
    }));
    
    
    data["test-88-founders"].root = 0xf7fd08011ae6c4feeacd7d387105af9077beef5e467051445c72cbd834b1a251;
    
    proof = new bytes32[](7);
    
    proof[0] = bytes32(0x65171034bc62f46506e352a3e4c96b8c51b0139379c7fe7b66ce43252affbec0);
    
    proof[1] = bytes32(0xd49fb77847c0ebbdf601842db67ad769871e6b7f1361505e379dd2dc33547c14);
    
    proof[2] = bytes32(0xa7c6a7460726ced5d7f1f794a775a416961dba57ce5e64ba44e776bd9572720b);
    
    proof[3] = bytes32(0x2d51bdcde578e18c6c09b495ee3af87619d12427415f2d6d302a4c35319913cf);
    
    proof[4] = bytes32(0x6b407a9489f6ae21067ad57988e361d3ec0bae234da1b9953c84ef2dc4be3947);
    
    proof[5] = bytes32(0x773171460446845fbfcdef671826e7a43a1a69163de39dc3b956a029f2f84422);
    
    proof[6] = bytes32(0x618c1144f751364acc8f1b61dfd59ff984815677073db3c3bae29179fec8e033);
    
    data["test-88-founders"].entries.push(MerkleEntry({
      user: 0x0000000000000000000000000000000000000100,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](7);
    
    proof[0] = bytes32(0xba9fcbac8ebef0ab7cf0f2f5aa5ba95d5af5d11c7f0fdd908227780706fa7748);
    
    proof[1] = bytes32(0xd49fb77847c0ebbdf601842db67ad769871e6b7f1361505e379dd2dc33547c14);
    
    proof[2] = bytes32(0xa7c6a7460726ced5d7f1f794a775a416961dba57ce5e64ba44e776bd9572720b);
    
    proof[3] = bytes32(0x2d51bdcde578e18c6c09b495ee3af87619d12427415f2d6d302a4c35319913cf);
    
    proof[4] = bytes32(0x6b407a9489f6ae21067ad57988e361d3ec0bae234da1b9953c84ef2dc4be3947);
    
    proof[5] = bytes32(0x773171460446845fbfcdef671826e7a43a1a69163de39dc3b956a029f2f84422);
    
    proof[6] = bytes32(0x618c1144f751364acc8f1b61dfd59ff984815677073db3c3bae29179fec8e033);
    
    data["test-88-founders"].entries.push(MerkleEntry({
      user: 0x0000000000000000000000000000000000000101,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](7);
    
    proof[0] = bytes32(0x36ec051c80e80dea6e2a878f292c7b9adcfa221e96e374fd340009f2a5297855);
    
    proof[1] = bytes32(0xa51958b61dff31b120fb5de5a6d00a8167a075b8cf802a40729d5f3949f7d753);
    
    proof[2] = bytes32(0xa7c6a7460726ced5d7f1f794a775a416961dba57ce5e64ba44e776bd9572720b);
    
    proof[3] = bytes32(0x2d51bdcde578e18c6c09b495ee3af87619d12427415f2d6d302a4c35319913cf);
    
    proof[4] = bytes32(0x6b407a9489f6ae21067ad57988e361d3ec0bae234da1b9953c84ef2dc4be3947);
    
    proof[5] = bytes32(0x773171460446845fbfcdef671826e7a43a1a69163de39dc3b956a029f2f84422);
    
    proof[6] = bytes32(0x618c1144f751364acc8f1b61dfd59ff984815677073db3c3bae29179fec8e033);
    
    data["test-88-founders"].entries.push(MerkleEntry({
      user: 0x0000000000000000000000000000000000000102,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](7);
    
    proof[0] = bytes32(0x30e3dc5ff81e06aa88aa63ea30c4533044c34850f35ee13b415c902fb3793add);
    
    proof[1] = bytes32(0xa51958b61dff31b120fb5de5a6d00a8167a075b8cf802a40729d5f3949f7d753);
    
    proof[2] = bytes32(0xa7c6a7460726ced5d7f1f794a775a416961dba57ce5e64ba44e776bd9572720b);
    
    proof[3] = bytes32(0x2d51bdcde578e18c6c09b495ee3af87619d12427415f2d6d302a4c35319913cf);
    
    proof[4] = bytes32(0x6b407a9489f6ae21067ad57988e361d3ec0bae234da1b9953c84ef2dc4be3947);
    
    proof[5] = bytes32(0x773171460446845fbfcdef671826e7a43a1a69163de39dc3b956a029f2f84422);
    
    proof[6] = bytes32(0x618c1144f751364acc8f1b61dfd59ff984815677073db3c3bae29179fec8e033);
    
    data["test-88-founders"].entries.push(MerkleEntry({
      user: 0x0000000000000000000000000000000000000103,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](7);
    
    proof[0] = bytes32(0xd006493e5e416cad6d390f10ba021fd9070f65462f19bab76852ff3eaa2e5dd5);
    
    proof[1] = bytes32(0xa00289d53cbd41125ea96b6d8407dd22860b0a9249f503a8474dd4270e829eec);
    
    proof[2] = bytes32(0xe798bb6526145cfb9511fd27c0928d7b7637e57358e48369230ce21427d72bd3);
    
    proof[3] = bytes32(0x2d51bdcde578e18c6c09b495ee3af87619d12427415f2d6d302a4c35319913cf);
    
    proof[4] = bytes32(0x6b407a9489f6ae21067ad57988e361d3ec0bae234da1b9953c84ef2dc4be3947);
    
    proof[5] = bytes32(0x773171460446845fbfcdef671826e7a43a1a69163de39dc3b956a029f2f84422);
    
    proof[6] = bytes32(0x618c1144f751364acc8f1b61dfd59ff984815677073db3c3bae29179fec8e033);
    
    data["test-88-founders"].entries.push(MerkleEntry({
      user: 0x0000000000000000000000000000000000000104,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](7);
    
    proof[0] = bytes32(0xfc64f097e002874721709b5cf30e062d98d0da56eb6310162347cce85e8bb136);
    
    proof[1] = bytes32(0xa00289d53cbd41125ea96b6d8407dd22860b0a9249f503a8474dd4270e829eec);
    
    proof[2] = bytes32(0xe798bb6526145cfb9511fd27c0928d7b7637e57358e48369230ce21427d72bd3);
    
    proof[3] = bytes32(0x2d51bdcde578e18c6c09b495ee3af87619d12427415f2d6d302a4c35319913cf);
    
    proof[4] = bytes32(0x6b407a9489f6ae21067ad57988e361d3ec0bae234da1b9953c84ef2dc4be3947);
    
    proof[5] = bytes32(0x773171460446845fbfcdef671826e7a43a1a69163de39dc3b956a029f2f84422);
    
    proof[6] = bytes32(0x618c1144f751364acc8f1b61dfd59ff984815677073db3c3bae29179fec8e033);
    
    data["test-88-founders"].entries.push(MerkleEntry({
      user: 0x0000000000000000000000000000000000000105,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](7);
    
    proof[0] = bytes32(0x25fb6534317f23706d5db8b86c3a97345052880d461c8e37181c539c4882f425);
    
    proof[1] = bytes32(0x5022ceb494187e7d6789339bbe8f4c64799f191dc473878823936769bc513e80);
    
    proof[2] = bytes32(0xe798bb6526145cfb9511fd27c0928d7b7637e57358e48369230ce21427d72bd3);
    
    proof[3] = bytes32(0x2d51bdcde578e18c6c09b495ee3af87619d12427415f2d6d302a4c35319913cf);
    
    proof[4] = bytes32(0x6b407a9489f6ae21067ad57988e361d3ec0bae234da1b9953c84ef2dc4be3947);
    
    proof[5] = bytes32(0x773171460446845fbfcdef671826e7a43a1a69163de39dc3b956a029f2f84422);
    
    proof[6] = bytes32(0x618c1144f751364acc8f1b61dfd59ff984815677073db3c3bae29179fec8e033);
    
    data["test-88-founders"].entries.push(MerkleEntry({
      user: 0x0000000000000000000000000000000000000106,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](7);
    
    proof[0] = bytes32(0xf5e59cee27d1cfd61e3a30bcd908d1b4a38f931b56098518203cf8605d599bb2);
    
    proof[1] = bytes32(0x5022ceb494187e7d6789339bbe8f4c64799f191dc473878823936769bc513e80);
    
    proof[2] = bytes32(0xe798bb6526145cfb9511fd27c0928d7b7637e57358e48369230ce21427d72bd3);
    
    proof[3] = bytes32(0x2d51bdcde578e18c6c09b495ee3af87619d12427415f2d6d302a4c35319913cf);
    
    proof[4] = bytes32(0x6b407a9489f6ae21067ad57988e361d3ec0bae234da1b9953c84ef2dc4be3947);
    
    proof[5] = bytes32(0x773171460446845fbfcdef671826e7a43a1a69163de39dc3b956a029f2f84422);
    
    proof[6] = bytes32(0x618c1144f751364acc8f1b61dfd59ff984815677073db3c3bae29179fec8e033);
    
    data["test-88-founders"].entries.push(MerkleEntry({
      user: 0x0000000000000000000000000000000000000107,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](7);
    
    proof[0] = bytes32(0x8df79431000776ebf8f85cbb2c021336e845ecc47071a6ab37cc98ebc9d3873b);
    
    proof[1] = bytes32(0xd0d453aaee5087f3d2452507833f9aea7f5dad0e9de54388c134dc169e8d4acb);
    
    proof[2] = bytes32(0x825e2ba1d3d7cd4c73d86e558d80ab1c29f51f43469e5a09d57a7eefce14fd9c);
    
    proof[3] = bytes32(0x693e6452e510f5e6727c504ba46f05a20e004ed866223a6db256269d36099308);
    
    proof[4] = bytes32(0x6b407a9489f6ae21067ad57988e361d3ec0bae234da1b9953c84ef2dc4be3947);
    
    proof[5] = bytes32(0x773171460446845fbfcdef671826e7a43a1a69163de39dc3b956a029f2f84422);
    
    proof[6] = bytes32(0x618c1144f751364acc8f1b61dfd59ff984815677073db3c3bae29179fec8e033);
    
    data["test-88-founders"].entries.push(MerkleEntry({
      user: 0x0000000000000000000000000000000000000108,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](7);
    
    proof[0] = bytes32(0xa4c2164734ac96e90ec7524cf95bc646e293582b8847b68e1ee7d7f0445b4c2a);
    
    proof[1] = bytes32(0xd0d453aaee5087f3d2452507833f9aea7f5dad0e9de54388c134dc169e8d4acb);
    
    proof[2] = bytes32(0x825e2ba1d3d7cd4c73d86e558d80ab1c29f51f43469e5a09d57a7eefce14fd9c);
    
    proof[3] = bytes32(0x693e6452e510f5e6727c504ba46f05a20e004ed866223a6db256269d36099308);
    
    proof[4] = bytes32(0x6b407a9489f6ae21067ad57988e361d3ec0bae234da1b9953c84ef2dc4be3947);
    
    proof[5] = bytes32(0x773171460446845fbfcdef671826e7a43a1a69163de39dc3b956a029f2f84422);
    
    proof[6] = bytes32(0x618c1144f751364acc8f1b61dfd59ff984815677073db3c3bae29179fec8e033);
    
    data["test-88-founders"].entries.push(MerkleEntry({
      user: 0x0000000000000000000000000000000000000109,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](7);
    
    proof[0] = bytes32(0xb261ae2eeea0caaad786fd4c785fe1465086888162c6f0f7a34143b8d738bd34);
    
    proof[1] = bytes32(0xa4115bf0f77dd1c8a297c687077d9156356016d318e635dbb1612993800fe53a);
    
    proof[2] = bytes32(0x825e2ba1d3d7cd4c73d86e558d80ab1c29f51f43469e5a09d57a7eefce14fd9c);
    
    proof[3] = bytes32(0x693e6452e510f5e6727c504ba46f05a20e004ed866223a6db256269d36099308);
    
    proof[4] = bytes32(0x6b407a9489f6ae21067ad57988e361d3ec0bae234da1b9953c84ef2dc4be3947);
    
    proof[5] = bytes32(0x773171460446845fbfcdef671826e7a43a1a69163de39dc3b956a029f2f84422);
    
    proof[6] = bytes32(0x618c1144f751364acc8f1b61dfd59ff984815677073db3c3bae29179fec8e033);
    
    data["test-88-founders"].entries.push(MerkleEntry({
      user: 0x0000000000000000000000000000000000000110,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](7);
    
    proof[0] = bytes32(0x521d956b51ff5f0ae67f80316cc28ca8971d701ec817fd502ca0b402dde3cec3);
    
    proof[1] = bytes32(0xa4115bf0f77dd1c8a297c687077d9156356016d318e635dbb1612993800fe53a);
    
    proof[2] = bytes32(0x825e2ba1d3d7cd4c73d86e558d80ab1c29f51f43469e5a09d57a7eefce14fd9c);
    
    proof[3] = bytes32(0x693e6452e510f5e6727c504ba46f05a20e004ed866223a6db256269d36099308);
    
    proof[4] = bytes32(0x6b407a9489f6ae21067ad57988e361d3ec0bae234da1b9953c84ef2dc4be3947);
    
    proof[5] = bytes32(0x773171460446845fbfcdef671826e7a43a1a69163de39dc3b956a029f2f84422);
    
    proof[6] = bytes32(0x618c1144f751364acc8f1b61dfd59ff984815677073db3c3bae29179fec8e033);
    
    data["test-88-founders"].entries.push(MerkleEntry({
      user: 0x0000000000000000000000000000000000000111,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](7);
    
    proof[0] = bytes32(0x78df96bf09e7b7bdcae3826656afdff406206ec59a5e52b64ee0cfa7a4cd3d52);
    
    proof[1] = bytes32(0x75179d2c6512702346aed12a9d592a4cd0a948a0f0efd61d086e6f70c63979c4);
    
    proof[2] = bytes32(0x013ac4ff956f7a1beaf12e8b2c5c2717070cf5f6e488eb30d06bc89c1154b479);
    
    proof[3] = bytes32(0x693e6452e510f5e6727c504ba46f05a20e004ed866223a6db256269d36099308);
    
    proof[4] = bytes32(0x6b407a9489f6ae21067ad57988e361d3ec0bae234da1b9953c84ef2dc4be3947);
    
    proof[5] = bytes32(0x773171460446845fbfcdef671826e7a43a1a69163de39dc3b956a029f2f84422);
    
    proof[6] = bytes32(0x618c1144f751364acc8f1b61dfd59ff984815677073db3c3bae29179fec8e033);
    
    data["test-88-founders"].entries.push(MerkleEntry({
      user: 0x0000000000000000000000000000000000000112,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](7);
    
    proof[0] = bytes32(0x39f1be4e80cebecf38c3c13a863a48487c908e99e72ad699916392041a7e633e);
    
    proof[1] = bytes32(0x75179d2c6512702346aed12a9d592a4cd0a948a0f0efd61d086e6f70c63979c4);
    
    proof[2] = bytes32(0x013ac4ff956f7a1beaf12e8b2c5c2717070cf5f6e488eb30d06bc89c1154b479);
    
    proof[3] = bytes32(0x693e6452e510f5e6727c504ba46f05a20e004ed866223a6db256269d36099308);
    
    proof[4] = bytes32(0x6b407a9489f6ae21067ad57988e361d3ec0bae234da1b9953c84ef2dc4be3947);
    
    proof[5] = bytes32(0x773171460446845fbfcdef671826e7a43a1a69163de39dc3b956a029f2f84422);
    
    proof[6] = bytes32(0x618c1144f751364acc8f1b61dfd59ff984815677073db3c3bae29179fec8e033);
    
    data["test-88-founders"].entries.push(MerkleEntry({
      user: 0x0000000000000000000000000000000000000113,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](7);
    
    proof[0] = bytes32(0x120d9f0aae79ef40da9e887ad50433b58f45f48fd7426055ae5d153f33ab1784);
    
    proof[1] = bytes32(0xd2e76dfa1992a18844d135d54d2586aed719345271a6b3542aaa195cc7e7eafa);
    
    proof[2] = bytes32(0x013ac4ff956f7a1beaf12e8b2c5c2717070cf5f6e488eb30d06bc89c1154b479);
    
    proof[3] = bytes32(0x693e6452e510f5e6727c504ba46f05a20e004ed866223a6db256269d36099308);
    
    proof[4] = bytes32(0x6b407a9489f6ae21067ad57988e361d3ec0bae234da1b9953c84ef2dc4be3947);
    
    proof[5] = bytes32(0x773171460446845fbfcdef671826e7a43a1a69163de39dc3b956a029f2f84422);
    
    proof[6] = bytes32(0x618c1144f751364acc8f1b61dfd59ff984815677073db3c3bae29179fec8e033);
    
    data["test-88-founders"].entries.push(MerkleEntry({
      user: 0x0000000000000000000000000000000000000114,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](7);
    
    proof[0] = bytes32(0x949aef967ccdc5bb82ca35b6bbda92999a4d6b44e1888d57a316b8f8ebb64d90);
    
    proof[1] = bytes32(0xd2e76dfa1992a18844d135d54d2586aed719345271a6b3542aaa195cc7e7eafa);
    
    proof[2] = bytes32(0x013ac4ff956f7a1beaf12e8b2c5c2717070cf5f6e488eb30d06bc89c1154b479);
    
    proof[3] = bytes32(0x693e6452e510f5e6727c504ba46f05a20e004ed866223a6db256269d36099308);
    
    proof[4] = bytes32(0x6b407a9489f6ae21067ad57988e361d3ec0bae234da1b9953c84ef2dc4be3947);
    
    proof[5] = bytes32(0x773171460446845fbfcdef671826e7a43a1a69163de39dc3b956a029f2f84422);
    
    proof[6] = bytes32(0x618c1144f751364acc8f1b61dfd59ff984815677073db3c3bae29179fec8e033);
    
    data["test-88-founders"].entries.push(MerkleEntry({
      user: 0x0000000000000000000000000000000000000115,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](7);
    
    proof[0] = bytes32(0x7fe9307d7a14cd381a29bc0291d9c65e1b7fc16a5eaf2d1786cb23729e81bd31);
    
    proof[1] = bytes32(0x585ca89e4dd2fecf21d6f9e537b78cbfdae414fb3aaa455397aa8fc35f6f9d0e);
    
    proof[2] = bytes32(0x5399972c28f9dd5b6efe9fadb1fc1ce33e003486d62d6c64f608a13ee61bba41);
    
    proof[3] = bytes32(0xdc7a7f0f99d34e31a198f67a6e7daadb94fad841e9f62271aa6e76b281873704);
    
    proof[4] = bytes32(0xc6ea1950e00104dd6b0ed30d3d20a822e6982dea3738ae61a3b9bad55c0a2140);
    
    proof[5] = bytes32(0x773171460446845fbfcdef671826e7a43a1a69163de39dc3b956a029f2f84422);
    
    proof[6] = bytes32(0x618c1144f751364acc8f1b61dfd59ff984815677073db3c3bae29179fec8e033);
    
    data["test-88-founders"].entries.push(MerkleEntry({
      user: 0x0000000000000000000000000000000000000116,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](7);
    
    proof[0] = bytes32(0xf2c72d114945e8d2eccb1e8e8ef9f73dc0cee6c0e7af3da19a8c01fbb0c3a10c);
    
    proof[1] = bytes32(0x585ca89e4dd2fecf21d6f9e537b78cbfdae414fb3aaa455397aa8fc35f6f9d0e);
    
    proof[2] = bytes32(0x5399972c28f9dd5b6efe9fadb1fc1ce33e003486d62d6c64f608a13ee61bba41);
    
    proof[3] = bytes32(0xdc7a7f0f99d34e31a198f67a6e7daadb94fad841e9f62271aa6e76b281873704);
    
    proof[4] = bytes32(0xc6ea1950e00104dd6b0ed30d3d20a822e6982dea3738ae61a3b9bad55c0a2140);
    
    proof[5] = bytes32(0x773171460446845fbfcdef671826e7a43a1a69163de39dc3b956a029f2f84422);
    
    proof[6] = bytes32(0x618c1144f751364acc8f1b61dfd59ff984815677073db3c3bae29179fec8e033);
    
    data["test-88-founders"].entries.push(MerkleEntry({
      user: 0x0000000000000000000000000000000000000117,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](7);
    
    proof[0] = bytes32(0xf02d3af7e8a5e4c400e3b63f653c651eccd7c01b4d31c08e8c27cda0ed0cb4f4);
    
    proof[1] = bytes32(0x39c19705c3c1cced46cbc0c04266b466ea5804568cafe766ba43678615823062);
    
    proof[2] = bytes32(0x5399972c28f9dd5b6efe9fadb1fc1ce33e003486d62d6c64f608a13ee61bba41);
    
    proof[3] = bytes32(0xdc7a7f0f99d34e31a198f67a6e7daadb94fad841e9f62271aa6e76b281873704);
    
    proof[4] = bytes32(0xc6ea1950e00104dd6b0ed30d3d20a822e6982dea3738ae61a3b9bad55c0a2140);
    
    proof[5] = bytes32(0x773171460446845fbfcdef671826e7a43a1a69163de39dc3b956a029f2f84422);
    
    proof[6] = bytes32(0x618c1144f751364acc8f1b61dfd59ff984815677073db3c3bae29179fec8e033);
    
    data["test-88-founders"].entries.push(MerkleEntry({
      user: 0x0000000000000000000000000000000000000118,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](7);
    
    proof[0] = bytes32(0x2619474a6f2b29b80484422f66c2082d2bf3d4e85af25aca736bab70c6418b7b);
    
    proof[1] = bytes32(0x39c19705c3c1cced46cbc0c04266b466ea5804568cafe766ba43678615823062);
    
    proof[2] = bytes32(0x5399972c28f9dd5b6efe9fadb1fc1ce33e003486d62d6c64f608a13ee61bba41);
    
    proof[3] = bytes32(0xdc7a7f0f99d34e31a198f67a6e7daadb94fad841e9f62271aa6e76b281873704);
    
    proof[4] = bytes32(0xc6ea1950e00104dd6b0ed30d3d20a822e6982dea3738ae61a3b9bad55c0a2140);
    
    proof[5] = bytes32(0x773171460446845fbfcdef671826e7a43a1a69163de39dc3b956a029f2f84422);
    
    proof[6] = bytes32(0x618c1144f751364acc8f1b61dfd59ff984815677073db3c3bae29179fec8e033);
    
    data["test-88-founders"].entries.push(MerkleEntry({
      user: 0x0000000000000000000000000000000000000119,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](7);
    
    proof[0] = bytes32(0x160829b07bb41a1e6ea1ef032e46569cb32123a81e2d1f9609cf6de929c84ce9);
    
    proof[1] = bytes32(0xb4cc979e2c2781d4d425c22aa844062840cb7bc1dbe036125545b41dcdba25d8);
    
    proof[2] = bytes32(0x9ad517bb2c02d3bef602db53124ef0f7b4a3cf84225fdab49c7c542a007d2c95);
    
    proof[3] = bytes32(0xdc7a7f0f99d34e31a198f67a6e7daadb94fad841e9f62271aa6e76b281873704);
    
    proof[4] = bytes32(0xc6ea1950e00104dd6b0ed30d3d20a822e6982dea3738ae61a3b9bad55c0a2140);
    
    proof[5] = bytes32(0x773171460446845fbfcdef671826e7a43a1a69163de39dc3b956a029f2f84422);
    
    proof[6] = bytes32(0x618c1144f751364acc8f1b61dfd59ff984815677073db3c3bae29179fec8e033);
    
    data["test-88-founders"].entries.push(MerkleEntry({
      user: 0x0000000000000000000000000000000000000120,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](7);
    
    proof[0] = bytes32(0xbf9342c3caa5d63d6b6d4eb39ac45716a0dd4098f41a120ae93310077b6dbba5);
    
    proof[1] = bytes32(0xb4cc979e2c2781d4d425c22aa844062840cb7bc1dbe036125545b41dcdba25d8);
    
    proof[2] = bytes32(0x9ad517bb2c02d3bef602db53124ef0f7b4a3cf84225fdab49c7c542a007d2c95);
    
    proof[3] = bytes32(0xdc7a7f0f99d34e31a198f67a6e7daadb94fad841e9f62271aa6e76b281873704);
    
    proof[4] = bytes32(0xc6ea1950e00104dd6b0ed30d3d20a822e6982dea3738ae61a3b9bad55c0a2140);
    
    proof[5] = bytes32(0x773171460446845fbfcdef671826e7a43a1a69163de39dc3b956a029f2f84422);
    
    proof[6] = bytes32(0x618c1144f751364acc8f1b61dfd59ff984815677073db3c3bae29179fec8e033);
    
    data["test-88-founders"].entries.push(MerkleEntry({
      user: 0x0000000000000000000000000000000000000121,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](7);
    
    proof[0] = bytes32(0x199e8e7246c360a50376021ea78a1f1ee5562950503bff69061b047395b8f076);
    
    proof[1] = bytes32(0xe106545e81507d154f8cc38738dae82af03f3a0c15925b2c0771b0b460501645);
    
    proof[2] = bytes32(0x9ad517bb2c02d3bef602db53124ef0f7b4a3cf84225fdab49c7c542a007d2c95);
    
    proof[3] = bytes32(0xdc7a7f0f99d34e31a198f67a6e7daadb94fad841e9f62271aa6e76b281873704);
    
    proof[4] = bytes32(0xc6ea1950e00104dd6b0ed30d3d20a822e6982dea3738ae61a3b9bad55c0a2140);
    
    proof[5] = bytes32(0x773171460446845fbfcdef671826e7a43a1a69163de39dc3b956a029f2f84422);
    
    proof[6] = bytes32(0x618c1144f751364acc8f1b61dfd59ff984815677073db3c3bae29179fec8e033);
    
    data["test-88-founders"].entries.push(MerkleEntry({
      user: 0x0000000000000000000000000000000000000122,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](7);
    
    proof[0] = bytes32(0x9fd66690e26403aa78737e5c1f424897502e9756e79d230d100e7e8d1460208d);
    
    proof[1] = bytes32(0xe106545e81507d154f8cc38738dae82af03f3a0c15925b2c0771b0b460501645);
    
    proof[2] = bytes32(0x9ad517bb2c02d3bef602db53124ef0f7b4a3cf84225fdab49c7c542a007d2c95);
    
    proof[3] = bytes32(0xdc7a7f0f99d34e31a198f67a6e7daadb94fad841e9f62271aa6e76b281873704);
    
    proof[4] = bytes32(0xc6ea1950e00104dd6b0ed30d3d20a822e6982dea3738ae61a3b9bad55c0a2140);
    
    proof[5] = bytes32(0x773171460446845fbfcdef671826e7a43a1a69163de39dc3b956a029f2f84422);
    
    proof[6] = bytes32(0x618c1144f751364acc8f1b61dfd59ff984815677073db3c3bae29179fec8e033);
    
    data["test-88-founders"].entries.push(MerkleEntry({
      user: 0x0000000000000000000000000000000000000123,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](7);
    
    proof[0] = bytes32(0xdf6581a33f033b280049575f23e21f4fa697faad4d99da638a68412487361d85);
    
    proof[1] = bytes32(0x30b414f69e9e1b4f84e0444d5135212d93448642c0ef10c3068128303f05363d);
    
    proof[2] = bytes32(0xa57d79a942b743e1315f0e456720192eabf9c6b47c039d279f27c8924500868a);
    
    proof[3] = bytes32(0x696bfa003988ac36b23192b562e10379b2d1ae0c60bb4849c62ed7ec37b3536f);
    
    proof[4] = bytes32(0xc6ea1950e00104dd6b0ed30d3d20a822e6982dea3738ae61a3b9bad55c0a2140);
    
    proof[5] = bytes32(0x773171460446845fbfcdef671826e7a43a1a69163de39dc3b956a029f2f84422);
    
    proof[6] = bytes32(0x618c1144f751364acc8f1b61dfd59ff984815677073db3c3bae29179fec8e033);
    
    data["test-88-founders"].entries.push(MerkleEntry({
      user: 0x0000000000000000000000000000000000000124,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](7);
    
    proof[0] = bytes32(0x954f900a69a1205306c7ef0f219e08013217423e2306ef08e7d2202ff00c15b4);
    
    proof[1] = bytes32(0x30b414f69e9e1b4f84e0444d5135212d93448642c0ef10c3068128303f05363d);
    
    proof[2] = bytes32(0xa57d79a942b743e1315f0e456720192eabf9c6b47c039d279f27c8924500868a);
    
    proof[3] = bytes32(0x696bfa003988ac36b23192b562e10379b2d1ae0c60bb4849c62ed7ec37b3536f);
    
    proof[4] = bytes32(0xc6ea1950e00104dd6b0ed30d3d20a822e6982dea3738ae61a3b9bad55c0a2140);
    
    proof[5] = bytes32(0x773171460446845fbfcdef671826e7a43a1a69163de39dc3b956a029f2f84422);
    
    proof[6] = bytes32(0x618c1144f751364acc8f1b61dfd59ff984815677073db3c3bae29179fec8e033);
    
    data["test-88-founders"].entries.push(MerkleEntry({
      user: 0x0000000000000000000000000000000000000125,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](7);
    
    proof[0] = bytes32(0xde80df3891b94f259a6b3eecdb53417e9a5d967b1448c4336eca873e1617380c);
    
    proof[1] = bytes32(0x53d64d6ae4257900fcac16140fda5dd51f215be9a11bebf09a9193db69ef3f9d);
    
    proof[2] = bytes32(0xa57d79a942b743e1315f0e456720192eabf9c6b47c039d279f27c8924500868a);
    
    proof[3] = bytes32(0x696bfa003988ac36b23192b562e10379b2d1ae0c60bb4849c62ed7ec37b3536f);
    
    proof[4] = bytes32(0xc6ea1950e00104dd6b0ed30d3d20a822e6982dea3738ae61a3b9bad55c0a2140);
    
    proof[5] = bytes32(0x773171460446845fbfcdef671826e7a43a1a69163de39dc3b956a029f2f84422);
    
    proof[6] = bytes32(0x618c1144f751364acc8f1b61dfd59ff984815677073db3c3bae29179fec8e033);
    
    data["test-88-founders"].entries.push(MerkleEntry({
      user: 0x0000000000000000000000000000000000000126,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](7);
    
    proof[0] = bytes32(0x9ee12dae4de84eaf5e0e36fdf3df6d81ffa84d1d820b8976bfab97a51653c4fd);
    
    proof[1] = bytes32(0x53d64d6ae4257900fcac16140fda5dd51f215be9a11bebf09a9193db69ef3f9d);
    
    proof[2] = bytes32(0xa57d79a942b743e1315f0e456720192eabf9c6b47c039d279f27c8924500868a);
    
    proof[3] = bytes32(0x696bfa003988ac36b23192b562e10379b2d1ae0c60bb4849c62ed7ec37b3536f);
    
    proof[4] = bytes32(0xc6ea1950e00104dd6b0ed30d3d20a822e6982dea3738ae61a3b9bad55c0a2140);
    
    proof[5] = bytes32(0x773171460446845fbfcdef671826e7a43a1a69163de39dc3b956a029f2f84422);
    
    proof[6] = bytes32(0x618c1144f751364acc8f1b61dfd59ff984815677073db3c3bae29179fec8e033);
    
    data["test-88-founders"].entries.push(MerkleEntry({
      user: 0x0000000000000000000000000000000000000127,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](7);
    
    proof[0] = bytes32(0x1d82f5b78900fe7d64e039bffec9321772165f73fd0c78cee8173d01b2d66b83);
    
    proof[1] = bytes32(0xab74c6c511e243da23ba344ac41dd5d5753fddeda484f266537df67f0752325e);
    
    proof[2] = bytes32(0xe12d90f6fe5531651ed99faf89c61de46d99c012b918d9a71eff655f1fe7cebe);
    
    proof[3] = bytes32(0x696bfa003988ac36b23192b562e10379b2d1ae0c60bb4849c62ed7ec37b3536f);
    
    proof[4] = bytes32(0xc6ea1950e00104dd6b0ed30d3d20a822e6982dea3738ae61a3b9bad55c0a2140);
    
    proof[5] = bytes32(0x773171460446845fbfcdef671826e7a43a1a69163de39dc3b956a029f2f84422);
    
    proof[6] = bytes32(0x618c1144f751364acc8f1b61dfd59ff984815677073db3c3bae29179fec8e033);
    
    data["test-88-founders"].entries.push(MerkleEntry({
      user: 0x0000000000000000000000000000000000000128,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](7);
    
    proof[0] = bytes32(0xe0565679953cb43d06a63065c8044af3a27f5d778f5deddd999219738d09a913);
    
    proof[1] = bytes32(0xab74c6c511e243da23ba344ac41dd5d5753fddeda484f266537df67f0752325e);
    
    proof[2] = bytes32(0xe12d90f6fe5531651ed99faf89c61de46d99c012b918d9a71eff655f1fe7cebe);
    
    proof[3] = bytes32(0x696bfa003988ac36b23192b562e10379b2d1ae0c60bb4849c62ed7ec37b3536f);
    
    proof[4] = bytes32(0xc6ea1950e00104dd6b0ed30d3d20a822e6982dea3738ae61a3b9bad55c0a2140);
    
    proof[5] = bytes32(0x773171460446845fbfcdef671826e7a43a1a69163de39dc3b956a029f2f84422);
    
    proof[6] = bytes32(0x618c1144f751364acc8f1b61dfd59ff984815677073db3c3bae29179fec8e033);
    
    data["test-88-founders"].entries.push(MerkleEntry({
      user: 0x0000000000000000000000000000000000000129,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](7);
    
    proof[0] = bytes32(0x60ad395af2b6aa9f7146181a40a16c534ffb049b34b4e015bad11d71c219fe22);
    
    proof[1] = bytes32(0xafb09e693b31215e23f098d9ad325912a0a4f10c4cc1c74ffe259c79eb8423c6);
    
    proof[2] = bytes32(0xe12d90f6fe5531651ed99faf89c61de46d99c012b918d9a71eff655f1fe7cebe);
    
    proof[3] = bytes32(0x696bfa003988ac36b23192b562e10379b2d1ae0c60bb4849c62ed7ec37b3536f);
    
    proof[4] = bytes32(0xc6ea1950e00104dd6b0ed30d3d20a822e6982dea3738ae61a3b9bad55c0a2140);
    
    proof[5] = bytes32(0x773171460446845fbfcdef671826e7a43a1a69163de39dc3b956a029f2f84422);
    
    proof[6] = bytes32(0x618c1144f751364acc8f1b61dfd59ff984815677073db3c3bae29179fec8e033);
    
    data["test-88-founders"].entries.push(MerkleEntry({
      user: 0x0000000000000000000000000000000000000130,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](7);
    
    proof[0] = bytes32(0xb477c1e42cd8e909e188a68e23c26e905bb287c36f800159d7a98187f366fdca);
    
    proof[1] = bytes32(0xafb09e693b31215e23f098d9ad325912a0a4f10c4cc1c74ffe259c79eb8423c6);
    
    proof[2] = bytes32(0xe12d90f6fe5531651ed99faf89c61de46d99c012b918d9a71eff655f1fe7cebe);
    
    proof[3] = bytes32(0x696bfa003988ac36b23192b562e10379b2d1ae0c60bb4849c62ed7ec37b3536f);
    
    proof[4] = bytes32(0xc6ea1950e00104dd6b0ed30d3d20a822e6982dea3738ae61a3b9bad55c0a2140);
    
    proof[5] = bytes32(0x773171460446845fbfcdef671826e7a43a1a69163de39dc3b956a029f2f84422);
    
    proof[6] = bytes32(0x618c1144f751364acc8f1b61dfd59ff984815677073db3c3bae29179fec8e033);
    
    data["test-88-founders"].entries.push(MerkleEntry({
      user: 0x0000000000000000000000000000000000000131,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](7);
    
    proof[0] = bytes32(0xb5cf6fb9b0809626dfc5d4177997d301fc6bd9d9ef1cabfef3bb2468ac6ab865);
    
    proof[1] = bytes32(0x620a07c62c18d13273b85e3cf196dfa22c96cfe1ddd26955e5f987f5a0d29063);
    
    proof[2] = bytes32(0x7a5cd7b8400da086d891dd4f57d9124951a54d0e9ba34f5c143644b95df02f2a);
    
    proof[3] = bytes32(0x743f4ea55371a855f436f07e503354cc6ae1ee03848df36da4e3261cbd0332ce);
    
    proof[4] = bytes32(0xa70f1f927a064634a0263ba500e37dcdf4df81769ef284a64fcdb828ef3b4d74);
    
    proof[5] = bytes32(0x0098cc5aed3ac9f857718d0a9e1ecd0dd43d5d28b4c74b6df7a8f7c11c34db57);
    
    proof[6] = bytes32(0x618c1144f751364acc8f1b61dfd59ff984815677073db3c3bae29179fec8e033);
    
    data["test-88-founders"].entries.push(MerkleEntry({
      user: 0x0000000000000000000000000000000000000132,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](7);
    
    proof[0] = bytes32(0x7110e291cbe9d738ecb1b4dcc37998397c9d1e87abc5a29b8682123094091e7c);
    
    proof[1] = bytes32(0x620a07c62c18d13273b85e3cf196dfa22c96cfe1ddd26955e5f987f5a0d29063);
    
    proof[2] = bytes32(0x7a5cd7b8400da086d891dd4f57d9124951a54d0e9ba34f5c143644b95df02f2a);
    
    proof[3] = bytes32(0x743f4ea55371a855f436f07e503354cc6ae1ee03848df36da4e3261cbd0332ce);
    
    proof[4] = bytes32(0xa70f1f927a064634a0263ba500e37dcdf4df81769ef284a64fcdb828ef3b4d74);
    
    proof[5] = bytes32(0x0098cc5aed3ac9f857718d0a9e1ecd0dd43d5d28b4c74b6df7a8f7c11c34db57);
    
    proof[6] = bytes32(0x618c1144f751364acc8f1b61dfd59ff984815677073db3c3bae29179fec8e033);
    
    data["test-88-founders"].entries.push(MerkleEntry({
      user: 0x0000000000000000000000000000000000000133,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](7);
    
    proof[0] = bytes32(0xa1059884a9a7a6e7299038c72ae36241004501f3ac20f01d6f96c2c808e6adba);
    
    proof[1] = bytes32(0x6a6a18f6d0ad13e4c32f7ef078114f7aaa9047b3cb8b5ae6e81f6cb2da658982);
    
    proof[2] = bytes32(0x7a5cd7b8400da086d891dd4f57d9124951a54d0e9ba34f5c143644b95df02f2a);
    
    proof[3] = bytes32(0x743f4ea55371a855f436f07e503354cc6ae1ee03848df36da4e3261cbd0332ce);
    
    proof[4] = bytes32(0xa70f1f927a064634a0263ba500e37dcdf4df81769ef284a64fcdb828ef3b4d74);
    
    proof[5] = bytes32(0x0098cc5aed3ac9f857718d0a9e1ecd0dd43d5d28b4c74b6df7a8f7c11c34db57);
    
    proof[6] = bytes32(0x618c1144f751364acc8f1b61dfd59ff984815677073db3c3bae29179fec8e033);
    
    data["test-88-founders"].entries.push(MerkleEntry({
      user: 0x0000000000000000000000000000000000000134,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](7);
    
    proof[0] = bytes32(0x946d9302eb04ffc303ef850363c09f84ac3a2dd55614739f9c5f85f76e4170f5);
    
    proof[1] = bytes32(0x6a6a18f6d0ad13e4c32f7ef078114f7aaa9047b3cb8b5ae6e81f6cb2da658982);
    
    proof[2] = bytes32(0x7a5cd7b8400da086d891dd4f57d9124951a54d0e9ba34f5c143644b95df02f2a);
    
    proof[3] = bytes32(0x743f4ea55371a855f436f07e503354cc6ae1ee03848df36da4e3261cbd0332ce);
    
    proof[4] = bytes32(0xa70f1f927a064634a0263ba500e37dcdf4df81769ef284a64fcdb828ef3b4d74);
    
    proof[5] = bytes32(0x0098cc5aed3ac9f857718d0a9e1ecd0dd43d5d28b4c74b6df7a8f7c11c34db57);
    
    proof[6] = bytes32(0x618c1144f751364acc8f1b61dfd59ff984815677073db3c3bae29179fec8e033);
    
    data["test-88-founders"].entries.push(MerkleEntry({
      user: 0x0000000000000000000000000000000000000135,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](7);
    
    proof[0] = bytes32(0x4a29a0a6d300dc8b8decf6f5499e0fcedcbbad7baa45cc12227ce16a9fb64396);
    
    proof[1] = bytes32(0x8d4228376ee2ec11e83efdaab34f5702d1bdb2f2a0100319af5919766aff802b);
    
    proof[2] = bytes32(0x1310f25427fafd0a3fe66b1d3e4980a49ee1f27220a594aa3e1305d9c30444a2);
    
    proof[3] = bytes32(0x743f4ea55371a855f436f07e503354cc6ae1ee03848df36da4e3261cbd0332ce);
    
    proof[4] = bytes32(0xa70f1f927a064634a0263ba500e37dcdf4df81769ef284a64fcdb828ef3b4d74);
    
    proof[5] = bytes32(0x0098cc5aed3ac9f857718d0a9e1ecd0dd43d5d28b4c74b6df7a8f7c11c34db57);
    
    proof[6] = bytes32(0x618c1144f751364acc8f1b61dfd59ff984815677073db3c3bae29179fec8e033);
    
    data["test-88-founders"].entries.push(MerkleEntry({
      user: 0x0000000000000000000000000000000000000136,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](7);
    
    proof[0] = bytes32(0x85bdaa13da387df411f155497aeb9bbaf3e7d7f1fe22a7ef984fd4f7327f6f83);
    
    proof[1] = bytes32(0x8d4228376ee2ec11e83efdaab34f5702d1bdb2f2a0100319af5919766aff802b);
    
    proof[2] = bytes32(0x1310f25427fafd0a3fe66b1d3e4980a49ee1f27220a594aa3e1305d9c30444a2);
    
    proof[3] = bytes32(0x743f4ea55371a855f436f07e503354cc6ae1ee03848df36da4e3261cbd0332ce);
    
    proof[4] = bytes32(0xa70f1f927a064634a0263ba500e37dcdf4df81769ef284a64fcdb828ef3b4d74);
    
    proof[5] = bytes32(0x0098cc5aed3ac9f857718d0a9e1ecd0dd43d5d28b4c74b6df7a8f7c11c34db57);
    
    proof[6] = bytes32(0x618c1144f751364acc8f1b61dfd59ff984815677073db3c3bae29179fec8e033);
    
    data["test-88-founders"].entries.push(MerkleEntry({
      user: 0x0000000000000000000000000000000000000137,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](7);
    
    proof[0] = bytes32(0xcea913cef76884647611662fb0d92e92bd21617bc84e2cf3dae22d9190879568);
    
    proof[1] = bytes32(0x6e4ee8fa25fb1f61fd75358208efb57a17749f4543b8cd4a6e02a99f9175d3b3);
    
    proof[2] = bytes32(0x1310f25427fafd0a3fe66b1d3e4980a49ee1f27220a594aa3e1305d9c30444a2);
    
    proof[3] = bytes32(0x743f4ea55371a855f436f07e503354cc6ae1ee03848df36da4e3261cbd0332ce);
    
    proof[4] = bytes32(0xa70f1f927a064634a0263ba500e37dcdf4df81769ef284a64fcdb828ef3b4d74);
    
    proof[5] = bytes32(0x0098cc5aed3ac9f857718d0a9e1ecd0dd43d5d28b4c74b6df7a8f7c11c34db57);
    
    proof[6] = bytes32(0x618c1144f751364acc8f1b61dfd59ff984815677073db3c3bae29179fec8e033);
    
    data["test-88-founders"].entries.push(MerkleEntry({
      user: 0x0000000000000000000000000000000000000138,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](7);
    
    proof[0] = bytes32(0x56b0305336ee30105e2ccae38e9c4a91c8f2b72cb335b8c057cefca84f7b7d74);
    
    proof[1] = bytes32(0x6e4ee8fa25fb1f61fd75358208efb57a17749f4543b8cd4a6e02a99f9175d3b3);
    
    proof[2] = bytes32(0x1310f25427fafd0a3fe66b1d3e4980a49ee1f27220a594aa3e1305d9c30444a2);
    
    proof[3] = bytes32(0x743f4ea55371a855f436f07e503354cc6ae1ee03848df36da4e3261cbd0332ce);
    
    proof[4] = bytes32(0xa70f1f927a064634a0263ba500e37dcdf4df81769ef284a64fcdb828ef3b4d74);
    
    proof[5] = bytes32(0x0098cc5aed3ac9f857718d0a9e1ecd0dd43d5d28b4c74b6df7a8f7c11c34db57);
    
    proof[6] = bytes32(0x618c1144f751364acc8f1b61dfd59ff984815677073db3c3bae29179fec8e033);
    
    data["test-88-founders"].entries.push(MerkleEntry({
      user: 0x0000000000000000000000000000000000000139,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](7);
    
    proof[0] = bytes32(0x410858b09bc8a690987549fb4deb3bb6a1abe1c26318aed62d028e39e5f293a6);
    
    proof[1] = bytes32(0xb487c458d8d9d26cad263978c7828383ae582b452b67750abb5e22a3ebb635e2);
    
    proof[2] = bytes32(0xe9023f819d06143a2c561a4148ec69e038a4e1eaf91a2043f28acbf8cb879ba0);
    
    proof[3] = bytes32(0x0e6c504dee69a39ecf995f45b6df692c61263f070ad3729b988da6dc1c487646);
    
    proof[4] = bytes32(0xa70f1f927a064634a0263ba500e37dcdf4df81769ef284a64fcdb828ef3b4d74);
    
    proof[5] = bytes32(0x0098cc5aed3ac9f857718d0a9e1ecd0dd43d5d28b4c74b6df7a8f7c11c34db57);
    
    proof[6] = bytes32(0x618c1144f751364acc8f1b61dfd59ff984815677073db3c3bae29179fec8e033);
    
    data["test-88-founders"].entries.push(MerkleEntry({
      user: 0x0000000000000000000000000000000000000140,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](7);
    
    proof[0] = bytes32(0x393c10258cd4c17cbb38218e047f9904c27d28a26b097457a14e82341317df75);
    
    proof[1] = bytes32(0xb487c458d8d9d26cad263978c7828383ae582b452b67750abb5e22a3ebb635e2);
    
    proof[2] = bytes32(0xe9023f819d06143a2c561a4148ec69e038a4e1eaf91a2043f28acbf8cb879ba0);
    
    proof[3] = bytes32(0x0e6c504dee69a39ecf995f45b6df692c61263f070ad3729b988da6dc1c487646);
    
    proof[4] = bytes32(0xa70f1f927a064634a0263ba500e37dcdf4df81769ef284a64fcdb828ef3b4d74);
    
    proof[5] = bytes32(0x0098cc5aed3ac9f857718d0a9e1ecd0dd43d5d28b4c74b6df7a8f7c11c34db57);
    
    proof[6] = bytes32(0x618c1144f751364acc8f1b61dfd59ff984815677073db3c3bae29179fec8e033);
    
    data["test-88-founders"].entries.push(MerkleEntry({
      user: 0x0000000000000000000000000000000000000141,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](7);
    
    proof[0] = bytes32(0xcee462c9391e3a5730fd32e77e8b3951161375d6c6a75c771c1294dc12f100a3);
    
    proof[1] = bytes32(0xe3668862c214b1ad7eba008065f3f6ed56dff048dae329c2ac59b00a8825110d);
    
    proof[2] = bytes32(0xe9023f819d06143a2c561a4148ec69e038a4e1eaf91a2043f28acbf8cb879ba0);
    
    proof[3] = bytes32(0x0e6c504dee69a39ecf995f45b6df692c61263f070ad3729b988da6dc1c487646);
    
    proof[4] = bytes32(0xa70f1f927a064634a0263ba500e37dcdf4df81769ef284a64fcdb828ef3b4d74);
    
    proof[5] = bytes32(0x0098cc5aed3ac9f857718d0a9e1ecd0dd43d5d28b4c74b6df7a8f7c11c34db57);
    
    proof[6] = bytes32(0x618c1144f751364acc8f1b61dfd59ff984815677073db3c3bae29179fec8e033);
    
    data["test-88-founders"].entries.push(MerkleEntry({
      user: 0x0000000000000000000000000000000000000142,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](7);
    
    proof[0] = bytes32(0xdcab59797a7c35bc706325a9a532939a4520669c32c29f721dabd0de4c527b23);
    
    proof[1] = bytes32(0xe3668862c214b1ad7eba008065f3f6ed56dff048dae329c2ac59b00a8825110d);
    
    proof[2] = bytes32(0xe9023f819d06143a2c561a4148ec69e038a4e1eaf91a2043f28acbf8cb879ba0);
    
    proof[3] = bytes32(0x0e6c504dee69a39ecf995f45b6df692c61263f070ad3729b988da6dc1c487646);
    
    proof[4] = bytes32(0xa70f1f927a064634a0263ba500e37dcdf4df81769ef284a64fcdb828ef3b4d74);
    
    proof[5] = bytes32(0x0098cc5aed3ac9f857718d0a9e1ecd0dd43d5d28b4c74b6df7a8f7c11c34db57);
    
    proof[6] = bytes32(0x618c1144f751364acc8f1b61dfd59ff984815677073db3c3bae29179fec8e033);
    
    data["test-88-founders"].entries.push(MerkleEntry({
      user: 0x0000000000000000000000000000000000000143,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](7);
    
    proof[0] = bytes32(0xf5a0086282458e09f20dcb519e3bf131ce2c02bec1d63c3e631abf0d48d97a96);
    
    proof[1] = bytes32(0x4f44eb8b57aecfe0be1ed3e0c8062bc0763f9820189cfd3f676d317fe876e52f);
    
    proof[2] = bytes32(0x7ea49076385ce3088d2528998d5b4819037637fae2285b1c270b5be0f8f1e207);
    
    proof[3] = bytes32(0x0e6c504dee69a39ecf995f45b6df692c61263f070ad3729b988da6dc1c487646);
    
    proof[4] = bytes32(0xa70f1f927a064634a0263ba500e37dcdf4df81769ef284a64fcdb828ef3b4d74);
    
    proof[5] = bytes32(0x0098cc5aed3ac9f857718d0a9e1ecd0dd43d5d28b4c74b6df7a8f7c11c34db57);
    
    proof[6] = bytes32(0x618c1144f751364acc8f1b61dfd59ff984815677073db3c3bae29179fec8e033);
    
    data["test-88-founders"].entries.push(MerkleEntry({
      user: 0x0000000000000000000000000000000000000144,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](7);
    
    proof[0] = bytes32(0xd156f2bdd20da5f02cd5b4ecf336fa2b1fcd00d6200d8365c123f87745b65e61);
    
    proof[1] = bytes32(0x4f44eb8b57aecfe0be1ed3e0c8062bc0763f9820189cfd3f676d317fe876e52f);
    
    proof[2] = bytes32(0x7ea49076385ce3088d2528998d5b4819037637fae2285b1c270b5be0f8f1e207);
    
    proof[3] = bytes32(0x0e6c504dee69a39ecf995f45b6df692c61263f070ad3729b988da6dc1c487646);
    
    proof[4] = bytes32(0xa70f1f927a064634a0263ba500e37dcdf4df81769ef284a64fcdb828ef3b4d74);
    
    proof[5] = bytes32(0x0098cc5aed3ac9f857718d0a9e1ecd0dd43d5d28b4c74b6df7a8f7c11c34db57);
    
    proof[6] = bytes32(0x618c1144f751364acc8f1b61dfd59ff984815677073db3c3bae29179fec8e033);
    
    data["test-88-founders"].entries.push(MerkleEntry({
      user: 0x0000000000000000000000000000000000000145,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](7);
    
    proof[0] = bytes32(0x6d522abde84862665cd23dec4115502afbf099caf530229499b7400587938a46);
    
    proof[1] = bytes32(0xef8adf657e4ea50bccbc614fb9a2512f8b8450f1ccef7686388f59d5cd0e6ef1);
    
    proof[2] = bytes32(0x7ea49076385ce3088d2528998d5b4819037637fae2285b1c270b5be0f8f1e207);
    
    proof[3] = bytes32(0x0e6c504dee69a39ecf995f45b6df692c61263f070ad3729b988da6dc1c487646);
    
    proof[4] = bytes32(0xa70f1f927a064634a0263ba500e37dcdf4df81769ef284a64fcdb828ef3b4d74);
    
    proof[5] = bytes32(0x0098cc5aed3ac9f857718d0a9e1ecd0dd43d5d28b4c74b6df7a8f7c11c34db57);
    
    proof[6] = bytes32(0x618c1144f751364acc8f1b61dfd59ff984815677073db3c3bae29179fec8e033);
    
    data["test-88-founders"].entries.push(MerkleEntry({
      user: 0x0000000000000000000000000000000000000146,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](7);
    
    proof[0] = bytes32(0xc26b738da3f54e62674fd1bbf1a2cafa439caed2d01ff07c007c19fe15d09d33);
    
    proof[1] = bytes32(0xef8adf657e4ea50bccbc614fb9a2512f8b8450f1ccef7686388f59d5cd0e6ef1);
    
    proof[2] = bytes32(0x7ea49076385ce3088d2528998d5b4819037637fae2285b1c270b5be0f8f1e207);
    
    proof[3] = bytes32(0x0e6c504dee69a39ecf995f45b6df692c61263f070ad3729b988da6dc1c487646);
    
    proof[4] = bytes32(0xa70f1f927a064634a0263ba500e37dcdf4df81769ef284a64fcdb828ef3b4d74);
    
    proof[5] = bytes32(0x0098cc5aed3ac9f857718d0a9e1ecd0dd43d5d28b4c74b6df7a8f7c11c34db57);
    
    proof[6] = bytes32(0x618c1144f751364acc8f1b61dfd59ff984815677073db3c3bae29179fec8e033);
    
    data["test-88-founders"].entries.push(MerkleEntry({
      user: 0x0000000000000000000000000000000000000147,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](7);
    
    proof[0] = bytes32(0x186cbb010985ad9c1cc0bdc04603b6976798e745e5dcb71325965b118b9535b3);
    
    proof[1] = bytes32(0xfe25b824cd3d8f0989256ef8e7af5b2a2fdc5f608d9ad3e2514e1cb0ee3c67ab);
    
    proof[2] = bytes32(0xeff576822830284bc4087054e11ff7dad040735f365f71466d97575055898f5c);
    
    proof[3] = bytes32(0x81d59b411e9ed53ef52908ed73ad4f6e30467ea8c37bd1984a5cdf913054c86a);
    
    proof[4] = bytes32(0x83751d960be8b7cdf4e58fe3d6d3465d5df9da3488717875f613e6382134a2b9);
    
    proof[5] = bytes32(0x0098cc5aed3ac9f857718d0a9e1ecd0dd43d5d28b4c74b6df7a8f7c11c34db57);
    
    proof[6] = bytes32(0x618c1144f751364acc8f1b61dfd59ff984815677073db3c3bae29179fec8e033);
    
    data["test-88-founders"].entries.push(MerkleEntry({
      user: 0x0000000000000000000000000000000000000148,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](7);
    
    proof[0] = bytes32(0x6006e538db775b2bbe31adbe325570b1d2648991b38425a76e3835655d4871f6);
    
    proof[1] = bytes32(0xfe25b824cd3d8f0989256ef8e7af5b2a2fdc5f608d9ad3e2514e1cb0ee3c67ab);
    
    proof[2] = bytes32(0xeff576822830284bc4087054e11ff7dad040735f365f71466d97575055898f5c);
    
    proof[3] = bytes32(0x81d59b411e9ed53ef52908ed73ad4f6e30467ea8c37bd1984a5cdf913054c86a);
    
    proof[4] = bytes32(0x83751d960be8b7cdf4e58fe3d6d3465d5df9da3488717875f613e6382134a2b9);
    
    proof[5] = bytes32(0x0098cc5aed3ac9f857718d0a9e1ecd0dd43d5d28b4c74b6df7a8f7c11c34db57);
    
    proof[6] = bytes32(0x618c1144f751364acc8f1b61dfd59ff984815677073db3c3bae29179fec8e033);
    
    data["test-88-founders"].entries.push(MerkleEntry({
      user: 0x0000000000000000000000000000000000000149,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](7);
    
    proof[0] = bytes32(0xe4b56cf771cf859d782a703a71c99f4efc00754b1008232ac9e744344655c254);
    
    proof[1] = bytes32(0x9ab975ed7450a680cd035751d83c2fe88a2ff97297275481f6a72f37f3b871a5);
    
    proof[2] = bytes32(0xeff576822830284bc4087054e11ff7dad040735f365f71466d97575055898f5c);
    
    proof[3] = bytes32(0x81d59b411e9ed53ef52908ed73ad4f6e30467ea8c37bd1984a5cdf913054c86a);
    
    proof[4] = bytes32(0x83751d960be8b7cdf4e58fe3d6d3465d5df9da3488717875f613e6382134a2b9);
    
    proof[5] = bytes32(0x0098cc5aed3ac9f857718d0a9e1ecd0dd43d5d28b4c74b6df7a8f7c11c34db57);
    
    proof[6] = bytes32(0x618c1144f751364acc8f1b61dfd59ff984815677073db3c3bae29179fec8e033);
    
    data["test-88-founders"].entries.push(MerkleEntry({
      user: 0x0000000000000000000000000000000000000150,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](7);
    
    proof[0] = bytes32(0x74007e1d36f6df12495acc845b4e70caba4c88d9a8fd52cc0ec3396320c5bfe3);
    
    proof[1] = bytes32(0x9ab975ed7450a680cd035751d83c2fe88a2ff97297275481f6a72f37f3b871a5);
    
    proof[2] = bytes32(0xeff576822830284bc4087054e11ff7dad040735f365f71466d97575055898f5c);
    
    proof[3] = bytes32(0x81d59b411e9ed53ef52908ed73ad4f6e30467ea8c37bd1984a5cdf913054c86a);
    
    proof[4] = bytes32(0x83751d960be8b7cdf4e58fe3d6d3465d5df9da3488717875f613e6382134a2b9);
    
    proof[5] = bytes32(0x0098cc5aed3ac9f857718d0a9e1ecd0dd43d5d28b4c74b6df7a8f7c11c34db57);
    
    proof[6] = bytes32(0x618c1144f751364acc8f1b61dfd59ff984815677073db3c3bae29179fec8e033);
    
    data["test-88-founders"].entries.push(MerkleEntry({
      user: 0x0000000000000000000000000000000000000151,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](7);
    
    proof[0] = bytes32(0xe7b00b1efbd97b42b9c9989fd48c781e3695d97dce3d2dabea71f5efcc7d1684);
    
    proof[1] = bytes32(0x93b42324bb1b56ae33a1144843e209005fa012d0ec109dbb65af95134b4af52a);
    
    proof[2] = bytes32(0x12b2e054d85e321c9d33563aafef05701ec9812bbf37fee1b81daa5ed0dcf18b);
    
    proof[3] = bytes32(0x81d59b411e9ed53ef52908ed73ad4f6e30467ea8c37bd1984a5cdf913054c86a);
    
    proof[4] = bytes32(0x83751d960be8b7cdf4e58fe3d6d3465d5df9da3488717875f613e6382134a2b9);
    
    proof[5] = bytes32(0x0098cc5aed3ac9f857718d0a9e1ecd0dd43d5d28b4c74b6df7a8f7c11c34db57);
    
    proof[6] = bytes32(0x618c1144f751364acc8f1b61dfd59ff984815677073db3c3bae29179fec8e033);
    
    data["test-88-founders"].entries.push(MerkleEntry({
      user: 0x0000000000000000000000000000000000000152,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](7);
    
    proof[0] = bytes32(0xa63d882dc0856ef45021bf5bacd609badeedc7f09a9a8d5a0679dd9332ae7894);
    
    proof[1] = bytes32(0x93b42324bb1b56ae33a1144843e209005fa012d0ec109dbb65af95134b4af52a);
    
    proof[2] = bytes32(0x12b2e054d85e321c9d33563aafef05701ec9812bbf37fee1b81daa5ed0dcf18b);
    
    proof[3] = bytes32(0x81d59b411e9ed53ef52908ed73ad4f6e30467ea8c37bd1984a5cdf913054c86a);
    
    proof[4] = bytes32(0x83751d960be8b7cdf4e58fe3d6d3465d5df9da3488717875f613e6382134a2b9);
    
    proof[5] = bytes32(0x0098cc5aed3ac9f857718d0a9e1ecd0dd43d5d28b4c74b6df7a8f7c11c34db57);
    
    proof[6] = bytes32(0x618c1144f751364acc8f1b61dfd59ff984815677073db3c3bae29179fec8e033);
    
    data["test-88-founders"].entries.push(MerkleEntry({
      user: 0x0000000000000000000000000000000000000153,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](7);
    
    proof[0] = bytes32(0x93b0ed5cf2d49b75e2e680d412353a6b717b65c2ebd6adfc155f85408d0f5817);
    
    proof[1] = bytes32(0x795e11cde28d1e3f499ee0b62c568721638fe705a34171d4b08b65831382a78c);
    
    proof[2] = bytes32(0x12b2e054d85e321c9d33563aafef05701ec9812bbf37fee1b81daa5ed0dcf18b);
    
    proof[3] = bytes32(0x81d59b411e9ed53ef52908ed73ad4f6e30467ea8c37bd1984a5cdf913054c86a);
    
    proof[4] = bytes32(0x83751d960be8b7cdf4e58fe3d6d3465d5df9da3488717875f613e6382134a2b9);
    
    proof[5] = bytes32(0x0098cc5aed3ac9f857718d0a9e1ecd0dd43d5d28b4c74b6df7a8f7c11c34db57);
    
    proof[6] = bytes32(0x618c1144f751364acc8f1b61dfd59ff984815677073db3c3bae29179fec8e033);
    
    data["test-88-founders"].entries.push(MerkleEntry({
      user: 0x0000000000000000000000000000000000000154,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](7);
    
    proof[0] = bytes32(0xb566904e155c63cb46de910dcf13931f365bc3dd1c683da4d467d7e6d96f82fa);
    
    proof[1] = bytes32(0x795e11cde28d1e3f499ee0b62c568721638fe705a34171d4b08b65831382a78c);
    
    proof[2] = bytes32(0x12b2e054d85e321c9d33563aafef05701ec9812bbf37fee1b81daa5ed0dcf18b);
    
    proof[3] = bytes32(0x81d59b411e9ed53ef52908ed73ad4f6e30467ea8c37bd1984a5cdf913054c86a);
    
    proof[4] = bytes32(0x83751d960be8b7cdf4e58fe3d6d3465d5df9da3488717875f613e6382134a2b9);
    
    proof[5] = bytes32(0x0098cc5aed3ac9f857718d0a9e1ecd0dd43d5d28b4c74b6df7a8f7c11c34db57);
    
    proof[6] = bytes32(0x618c1144f751364acc8f1b61dfd59ff984815677073db3c3bae29179fec8e033);
    
    data["test-88-founders"].entries.push(MerkleEntry({
      user: 0x0000000000000000000000000000000000000155,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](7);
    
    proof[0] = bytes32(0xaf4d74ffb04faec7ef3f3baaedd2fb514afde98a76ccedbd140196628dab7e45);
    
    proof[1] = bytes32(0xae102fd44a1d8113d43eb87c17d4f8c29dae3909246a2e08056d2d318547bdc6);
    
    proof[2] = bytes32(0x09d06000334005eafc22eb030ed9c57f0c71b3f1d445b9141c6b73574dd34af4);
    
    proof[3] = bytes32(0x9221b6ac69714f7134b1338a4cea6e840d8c1601f0d5359aeb3591e24299250d);
    
    proof[4] = bytes32(0x83751d960be8b7cdf4e58fe3d6d3465d5df9da3488717875f613e6382134a2b9);
    
    proof[5] = bytes32(0x0098cc5aed3ac9f857718d0a9e1ecd0dd43d5d28b4c74b6df7a8f7c11c34db57);
    
    proof[6] = bytes32(0x618c1144f751364acc8f1b61dfd59ff984815677073db3c3bae29179fec8e033);
    
    data["test-88-founders"].entries.push(MerkleEntry({
      user: 0x0000000000000000000000000000000000000156,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](7);
    
    proof[0] = bytes32(0x43df7b2b98e13ed43bf7daf7cfb058d266b1e58bbc4acf75fbb9a178ded5de58);
    
    proof[1] = bytes32(0xae102fd44a1d8113d43eb87c17d4f8c29dae3909246a2e08056d2d318547bdc6);
    
    proof[2] = bytes32(0x09d06000334005eafc22eb030ed9c57f0c71b3f1d445b9141c6b73574dd34af4);
    
    proof[3] = bytes32(0x9221b6ac69714f7134b1338a4cea6e840d8c1601f0d5359aeb3591e24299250d);
    
    proof[4] = bytes32(0x83751d960be8b7cdf4e58fe3d6d3465d5df9da3488717875f613e6382134a2b9);
    
    proof[5] = bytes32(0x0098cc5aed3ac9f857718d0a9e1ecd0dd43d5d28b4c74b6df7a8f7c11c34db57);
    
    proof[6] = bytes32(0x618c1144f751364acc8f1b61dfd59ff984815677073db3c3bae29179fec8e033);
    
    data["test-88-founders"].entries.push(MerkleEntry({
      user: 0x0000000000000000000000000000000000000157,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](7);
    
    proof[0] = bytes32(0x8ba2b820a7462e5da2147b542afd9b6d384074b4c17f2637fc686b94733379c5);
    
    proof[1] = bytes32(0x0327f85e246ba22a11059c81dddefbf4808543e0a52d41191e88fd91de37f37d);
    
    proof[2] = bytes32(0x09d06000334005eafc22eb030ed9c57f0c71b3f1d445b9141c6b73574dd34af4);
    
    proof[3] = bytes32(0x9221b6ac69714f7134b1338a4cea6e840d8c1601f0d5359aeb3591e24299250d);
    
    proof[4] = bytes32(0x83751d960be8b7cdf4e58fe3d6d3465d5df9da3488717875f613e6382134a2b9);
    
    proof[5] = bytes32(0x0098cc5aed3ac9f857718d0a9e1ecd0dd43d5d28b4c74b6df7a8f7c11c34db57);
    
    proof[6] = bytes32(0x618c1144f751364acc8f1b61dfd59ff984815677073db3c3bae29179fec8e033);
    
    data["test-88-founders"].entries.push(MerkleEntry({
      user: 0x0000000000000000000000000000000000000158,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](7);
    
    proof[0] = bytes32(0x566a4db28d633c3c2f715160241f97be95d04a16e2d896aa50a384199ce9f5aa);
    
    proof[1] = bytes32(0x0327f85e246ba22a11059c81dddefbf4808543e0a52d41191e88fd91de37f37d);
    
    proof[2] = bytes32(0x09d06000334005eafc22eb030ed9c57f0c71b3f1d445b9141c6b73574dd34af4);
    
    proof[3] = bytes32(0x9221b6ac69714f7134b1338a4cea6e840d8c1601f0d5359aeb3591e24299250d);
    
    proof[4] = bytes32(0x83751d960be8b7cdf4e58fe3d6d3465d5df9da3488717875f613e6382134a2b9);
    
    proof[5] = bytes32(0x0098cc5aed3ac9f857718d0a9e1ecd0dd43d5d28b4c74b6df7a8f7c11c34db57);
    
    proof[6] = bytes32(0x618c1144f751364acc8f1b61dfd59ff984815677073db3c3bae29179fec8e033);
    
    data["test-88-founders"].entries.push(MerkleEntry({
      user: 0x0000000000000000000000000000000000000159,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](7);
    
    proof[0] = bytes32(0x6dafcdabfbd8047d504ec382e7a45b162db0f1d814f118bd87c95afb7a14a547);
    
    proof[1] = bytes32(0x2d44aa1ea755f77552e19783cee6c11102284f1e701dab1d51b818019a2298cd);
    
    proof[2] = bytes32(0xc79e13279cfae0f2c5eb91458d61557351ab1080691cb6e3975e0968f5526609);
    
    proof[3] = bytes32(0x9221b6ac69714f7134b1338a4cea6e840d8c1601f0d5359aeb3591e24299250d);
    
    proof[4] = bytes32(0x83751d960be8b7cdf4e58fe3d6d3465d5df9da3488717875f613e6382134a2b9);
    
    proof[5] = bytes32(0x0098cc5aed3ac9f857718d0a9e1ecd0dd43d5d28b4c74b6df7a8f7c11c34db57);
    
    proof[6] = bytes32(0x618c1144f751364acc8f1b61dfd59ff984815677073db3c3bae29179fec8e033);
    
    data["test-88-founders"].entries.push(MerkleEntry({
      user: 0x0000000000000000000000000000000000000190,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](7);
    
    proof[0] = bytes32(0xfedacd8f6daec675ff2d07cac003b377118a9af9315d21bfff0dae9e85ed6ee4);
    
    proof[1] = bytes32(0x2d44aa1ea755f77552e19783cee6c11102284f1e701dab1d51b818019a2298cd);
    
    proof[2] = bytes32(0xc79e13279cfae0f2c5eb91458d61557351ab1080691cb6e3975e0968f5526609);
    
    proof[3] = bytes32(0x9221b6ac69714f7134b1338a4cea6e840d8c1601f0d5359aeb3591e24299250d);
    
    proof[4] = bytes32(0x83751d960be8b7cdf4e58fe3d6d3465d5df9da3488717875f613e6382134a2b9);
    
    proof[5] = bytes32(0x0098cc5aed3ac9f857718d0a9e1ecd0dd43d5d28b4c74b6df7a8f7c11c34db57);
    
    proof[6] = bytes32(0x618c1144f751364acc8f1b61dfd59ff984815677073db3c3bae29179fec8e033);
    
    data["test-88-founders"].entries.push(MerkleEntry({
      user: 0x0000000000000000000000000000000000000161,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](7);
    
    proof[0] = bytes32(0x41cfdfeb92f12dfde023e60606fb879c7aaf32b56efe3fd101d7f81626e1e680);
    
    proof[1] = bytes32(0xc04ffa0daa4f73790cf64c3856de384a35ae201617efd937313240e366f51901);
    
    proof[2] = bytes32(0xc79e13279cfae0f2c5eb91458d61557351ab1080691cb6e3975e0968f5526609);
    
    proof[3] = bytes32(0x9221b6ac69714f7134b1338a4cea6e840d8c1601f0d5359aeb3591e24299250d);
    
    proof[4] = bytes32(0x83751d960be8b7cdf4e58fe3d6d3465d5df9da3488717875f613e6382134a2b9);
    
    proof[5] = bytes32(0x0098cc5aed3ac9f857718d0a9e1ecd0dd43d5d28b4c74b6df7a8f7c11c34db57);
    
    proof[6] = bytes32(0x618c1144f751364acc8f1b61dfd59ff984815677073db3c3bae29179fec8e033);
    
    data["test-88-founders"].entries.push(MerkleEntry({
      user: 0x0000000000000000000000000000000000000162,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](7);
    
    proof[0] = bytes32(0x6172c71c47de1ab92dad0867608cdcb0508ab79b1e025b0e62e3b0236b43e71b);
    
    proof[1] = bytes32(0xc04ffa0daa4f73790cf64c3856de384a35ae201617efd937313240e366f51901);
    
    proof[2] = bytes32(0xc79e13279cfae0f2c5eb91458d61557351ab1080691cb6e3975e0968f5526609);
    
    proof[3] = bytes32(0x9221b6ac69714f7134b1338a4cea6e840d8c1601f0d5359aeb3591e24299250d);
    
    proof[4] = bytes32(0x83751d960be8b7cdf4e58fe3d6d3465d5df9da3488717875f613e6382134a2b9);
    
    proof[5] = bytes32(0x0098cc5aed3ac9f857718d0a9e1ecd0dd43d5d28b4c74b6df7a8f7c11c34db57);
    
    proof[6] = bytes32(0x618c1144f751364acc8f1b61dfd59ff984815677073db3c3bae29179fec8e033);
    
    data["test-88-founders"].entries.push(MerkleEntry({
      user: 0x0000000000000000000000000000000000000163,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](6);
    
    proof[0] = bytes32(0x88262ee1a0b5f33d706c7dd9fbfa00a2ffa8edd0d0cf16dfeb440042033fd5b1);
    
    proof[1] = bytes32(0x3d97443740423a889ab74d5788347f2e938440114b0ce09e7a6d07ae1c29035f);
    
    proof[2] = bytes32(0x428689f11391b39e601654ed3971a1b560bed75a108a26d6c57c926939af0e53);
    
    proof[3] = bytes32(0xe0fb1ab0f913bdd9d93551c79d76d0236f5c7bf93c6533199c4aa3b6302dfc1f);
    
    proof[4] = bytes32(0x8b52e774d88983d22339826f149e762c1c1f5837461f9cfaa96e39886af55c6e);
    
    proof[5] = bytes32(0x125db996b9a9107c35258d70bba28311f1652465823dce86eeba80a8df5cf2c0);
    
    data["test-88-founders"].entries.push(MerkleEntry({
      user: 0x0000000000000000000000000000000000000164,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](6);
    
    proof[0] = bytes32(0xf318329a432f825d0006dfb1a46db29007fc6c6850bd0d3dddd5dfe12cb53a1f);
    
    proof[1] = bytes32(0x3d97443740423a889ab74d5788347f2e938440114b0ce09e7a6d07ae1c29035f);
    
    proof[2] = bytes32(0x428689f11391b39e601654ed3971a1b560bed75a108a26d6c57c926939af0e53);
    
    proof[3] = bytes32(0xe0fb1ab0f913bdd9d93551c79d76d0236f5c7bf93c6533199c4aa3b6302dfc1f);
    
    proof[4] = bytes32(0x8b52e774d88983d22339826f149e762c1c1f5837461f9cfaa96e39886af55c6e);
    
    proof[5] = bytes32(0x125db996b9a9107c35258d70bba28311f1652465823dce86eeba80a8df5cf2c0);
    
    data["test-88-founders"].entries.push(MerkleEntry({
      user: 0x0000000000000000000000000000000000000165,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](6);
    
    proof[0] = bytes32(0x8188bff7c871d031c42b64b0c0f8920d1b25d154c3a88ab8ecc6ccb3fbdb1ef2);
    
    proof[1] = bytes32(0x2344276342b0e7142e02a7249d3d50837a53aeca4723c12f2c873e2860d0c93f);
    
    proof[2] = bytes32(0x428689f11391b39e601654ed3971a1b560bed75a108a26d6c57c926939af0e53);
    
    proof[3] = bytes32(0xe0fb1ab0f913bdd9d93551c79d76d0236f5c7bf93c6533199c4aa3b6302dfc1f);
    
    proof[4] = bytes32(0x8b52e774d88983d22339826f149e762c1c1f5837461f9cfaa96e39886af55c6e);
    
    proof[5] = bytes32(0x125db996b9a9107c35258d70bba28311f1652465823dce86eeba80a8df5cf2c0);
    
    data["test-88-founders"].entries.push(MerkleEntry({
      user: 0x0000000000000000000000000000000000000166,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](6);
    
    proof[0] = bytes32(0x5b78d06b32de8a8ec88edac14a863f5fac79e8b6ea56922c9f955c3b88f84096);
    
    proof[1] = bytes32(0x2344276342b0e7142e02a7249d3d50837a53aeca4723c12f2c873e2860d0c93f);
    
    proof[2] = bytes32(0x428689f11391b39e601654ed3971a1b560bed75a108a26d6c57c926939af0e53);
    
    proof[3] = bytes32(0xe0fb1ab0f913bdd9d93551c79d76d0236f5c7bf93c6533199c4aa3b6302dfc1f);
    
    proof[4] = bytes32(0x8b52e774d88983d22339826f149e762c1c1f5837461f9cfaa96e39886af55c6e);
    
    proof[5] = bytes32(0x125db996b9a9107c35258d70bba28311f1652465823dce86eeba80a8df5cf2c0);
    
    data["test-88-founders"].entries.push(MerkleEntry({
      user: 0x0000000000000000000000000000000000000167,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](6);
    
    proof[0] = bytes32(0x1e88f5f05226e0d99cb992920cb125e02066bd5204f3eb8907fd1b8747b2e4d6);
    
    proof[1] = bytes32(0x626f1dc1cb4de3407241d66c0668f62011ddf96943687da82da6e16eb3484a2d);
    
    proof[2] = bytes32(0x294a95437a2d195d728e50198699200888c31d1606cfc4f17d6e3e87241f6a65);
    
    proof[3] = bytes32(0xe0fb1ab0f913bdd9d93551c79d76d0236f5c7bf93c6533199c4aa3b6302dfc1f);
    
    proof[4] = bytes32(0x8b52e774d88983d22339826f149e762c1c1f5837461f9cfaa96e39886af55c6e);
    
    proof[5] = bytes32(0x125db996b9a9107c35258d70bba28311f1652465823dce86eeba80a8df5cf2c0);
    
    data["test-88-founders"].entries.push(MerkleEntry({
      user: 0x0000000000000000000000000000000000000168,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](6);
    
    proof[0] = bytes32(0xa6c68954c78b59cc7ac61c3380ad278a3b63bf495ef4a9c9f0979a422969fe88);
    
    proof[1] = bytes32(0x626f1dc1cb4de3407241d66c0668f62011ddf96943687da82da6e16eb3484a2d);
    
    proof[2] = bytes32(0x294a95437a2d195d728e50198699200888c31d1606cfc4f17d6e3e87241f6a65);
    
    proof[3] = bytes32(0xe0fb1ab0f913bdd9d93551c79d76d0236f5c7bf93c6533199c4aa3b6302dfc1f);
    
    proof[4] = bytes32(0x8b52e774d88983d22339826f149e762c1c1f5837461f9cfaa96e39886af55c6e);
    
    proof[5] = bytes32(0x125db996b9a9107c35258d70bba28311f1652465823dce86eeba80a8df5cf2c0);
    
    data["test-88-founders"].entries.push(MerkleEntry({
      user: 0x0000000000000000000000000000000000000169,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](6);
    
    proof[0] = bytes32(0x8a03efd13f4391b07ce74a383b4a45070ae34cb3c69fbb57dfc0176452aeba10);
    
    proof[1] = bytes32(0x890df6af5070d04faa9a8af8cad6fcef1be3928200d19dd9637c5c11433f3eee);
    
    proof[2] = bytes32(0x294a95437a2d195d728e50198699200888c31d1606cfc4f17d6e3e87241f6a65);
    
    proof[3] = bytes32(0xe0fb1ab0f913bdd9d93551c79d76d0236f5c7bf93c6533199c4aa3b6302dfc1f);
    
    proof[4] = bytes32(0x8b52e774d88983d22339826f149e762c1c1f5837461f9cfaa96e39886af55c6e);
    
    proof[5] = bytes32(0x125db996b9a9107c35258d70bba28311f1652465823dce86eeba80a8df5cf2c0);
    
    data["test-88-founders"].entries.push(MerkleEntry({
      user: 0x0000000000000000000000000000000000000170,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](6);
    
    proof[0] = bytes32(0x81d413cc9aeee5c14a0e64a6faf66135ece4437e86d47a86acff177ed182f461);
    
    proof[1] = bytes32(0x890df6af5070d04faa9a8af8cad6fcef1be3928200d19dd9637c5c11433f3eee);
    
    proof[2] = bytes32(0x294a95437a2d195d728e50198699200888c31d1606cfc4f17d6e3e87241f6a65);
    
    proof[3] = bytes32(0xe0fb1ab0f913bdd9d93551c79d76d0236f5c7bf93c6533199c4aa3b6302dfc1f);
    
    proof[4] = bytes32(0x8b52e774d88983d22339826f149e762c1c1f5837461f9cfaa96e39886af55c6e);
    
    proof[5] = bytes32(0x125db996b9a9107c35258d70bba28311f1652465823dce86eeba80a8df5cf2c0);
    
    data["test-88-founders"].entries.push(MerkleEntry({
      user: 0x0000000000000000000000000000000000000171,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](6);
    
    proof[0] = bytes32(0x90debbc1bbc9b7a0366cb4f4cd6bff4d9999e17456e6e82c2e3e83a81eed405d);
    
    proof[1] = bytes32(0xb94ec9bda125877f4349c6a69b919ddae878fdc58c99322ecf1e17eaae5e3d30);
    
    proof[2] = bytes32(0x590cd00de2bf78a90b93d2865c07141a1b63d76df58ca46ee6f7a02350c9a9da);
    
    proof[3] = bytes32(0x5afef715cbd81b4bca67bb64df8fe62a45f2fca75cca29805c82e56bacd1a9b1);
    
    proof[4] = bytes32(0x8b52e774d88983d22339826f149e762c1c1f5837461f9cfaa96e39886af55c6e);
    
    proof[5] = bytes32(0x125db996b9a9107c35258d70bba28311f1652465823dce86eeba80a8df5cf2c0);
    
    data["test-88-founders"].entries.push(MerkleEntry({
      user: 0x0000000000000000000000000000000000000172,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](6);
    
    proof[0] = bytes32(0x66f9a6f532da537b17f7a88232394cd34419199085c247756eaa2d9cc90a80aa);
    
    proof[1] = bytes32(0xb94ec9bda125877f4349c6a69b919ddae878fdc58c99322ecf1e17eaae5e3d30);
    
    proof[2] = bytes32(0x590cd00de2bf78a90b93d2865c07141a1b63d76df58ca46ee6f7a02350c9a9da);
    
    proof[3] = bytes32(0x5afef715cbd81b4bca67bb64df8fe62a45f2fca75cca29805c82e56bacd1a9b1);
    
    proof[4] = bytes32(0x8b52e774d88983d22339826f149e762c1c1f5837461f9cfaa96e39886af55c6e);
    
    proof[5] = bytes32(0x125db996b9a9107c35258d70bba28311f1652465823dce86eeba80a8df5cf2c0);
    
    data["test-88-founders"].entries.push(MerkleEntry({
      user: 0x0000000000000000000000000000000000000173,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](6);
    
    proof[0] = bytes32(0x78f0bbe718b4e24d466c97026c82a97165b7b898b6f2ee87b679d0c717f2e001);
    
    proof[1] = bytes32(0xeef44555a61a41df318225a79f2d7c83aee2975905eeffa122f3e137472401fa);
    
    proof[2] = bytes32(0x590cd00de2bf78a90b93d2865c07141a1b63d76df58ca46ee6f7a02350c9a9da);
    
    proof[3] = bytes32(0x5afef715cbd81b4bca67bb64df8fe62a45f2fca75cca29805c82e56bacd1a9b1);
    
    proof[4] = bytes32(0x8b52e774d88983d22339826f149e762c1c1f5837461f9cfaa96e39886af55c6e);
    
    proof[5] = bytes32(0x125db996b9a9107c35258d70bba28311f1652465823dce86eeba80a8df5cf2c0);
    
    data["test-88-founders"].entries.push(MerkleEntry({
      user: 0x0000000000000000000000000000000000000174,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](6);
    
    proof[0] = bytes32(0xcdfd1c15eecb74bb536c173a16a6e8539b98998d08672ade16c695aea57e05ab);
    
    proof[1] = bytes32(0xeef44555a61a41df318225a79f2d7c83aee2975905eeffa122f3e137472401fa);
    
    proof[2] = bytes32(0x590cd00de2bf78a90b93d2865c07141a1b63d76df58ca46ee6f7a02350c9a9da);
    
    proof[3] = bytes32(0x5afef715cbd81b4bca67bb64df8fe62a45f2fca75cca29805c82e56bacd1a9b1);
    
    proof[4] = bytes32(0x8b52e774d88983d22339826f149e762c1c1f5837461f9cfaa96e39886af55c6e);
    
    proof[5] = bytes32(0x125db996b9a9107c35258d70bba28311f1652465823dce86eeba80a8df5cf2c0);
    
    data["test-88-founders"].entries.push(MerkleEntry({
      user: 0x0000000000000000000000000000000000000175,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](6);
    
    proof[0] = bytes32(0x25b75bcd9461bea65019574ca97fa4f4ed7d817529016872afb8e1004f95c33d);
    
    proof[1] = bytes32(0x9e40be7426b07bff0491702bb23906894c9973975fdd8ccd67ffdd88e4cb6f2b);
    
    proof[2] = bytes32(0x1a4bc3c24070cb2af471242266c0dde566622ddb9c47c5a239e767f076880afa);
    
    proof[3] = bytes32(0x5afef715cbd81b4bca67bb64df8fe62a45f2fca75cca29805c82e56bacd1a9b1);
    
    proof[4] = bytes32(0x8b52e774d88983d22339826f149e762c1c1f5837461f9cfaa96e39886af55c6e);
    
    proof[5] = bytes32(0x125db996b9a9107c35258d70bba28311f1652465823dce86eeba80a8df5cf2c0);
    
    data["test-88-founders"].entries.push(MerkleEntry({
      user: 0x0000000000000000000000000000000000000176,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](6);
    
    proof[0] = bytes32(0xbb95230993fc38daab47f7cb0050996c085af7d459cf1683593da83d51b2f341);
    
    proof[1] = bytes32(0x9e40be7426b07bff0491702bb23906894c9973975fdd8ccd67ffdd88e4cb6f2b);
    
    proof[2] = bytes32(0x1a4bc3c24070cb2af471242266c0dde566622ddb9c47c5a239e767f076880afa);
    
    proof[3] = bytes32(0x5afef715cbd81b4bca67bb64df8fe62a45f2fca75cca29805c82e56bacd1a9b1);
    
    proof[4] = bytes32(0x8b52e774d88983d22339826f149e762c1c1f5837461f9cfaa96e39886af55c6e);
    
    proof[5] = bytes32(0x125db996b9a9107c35258d70bba28311f1652465823dce86eeba80a8df5cf2c0);
    
    data["test-88-founders"].entries.push(MerkleEntry({
      user: 0x0000000000000000000000000000000000000177,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](6);
    
    proof[0] = bytes32(0x22d23008722ffb79b0058f0aa98331475896cca2e27bdefbcf0130c24976b3db);
    
    proof[1] = bytes32(0x4988beaf439f1bafcebae1fdad5071e2f0a33e40665c09952991f1f22480ed25);
    
    proof[2] = bytes32(0x1a4bc3c24070cb2af471242266c0dde566622ddb9c47c5a239e767f076880afa);
    
    proof[3] = bytes32(0x5afef715cbd81b4bca67bb64df8fe62a45f2fca75cca29805c82e56bacd1a9b1);
    
    proof[4] = bytes32(0x8b52e774d88983d22339826f149e762c1c1f5837461f9cfaa96e39886af55c6e);
    
    proof[5] = bytes32(0x125db996b9a9107c35258d70bba28311f1652465823dce86eeba80a8df5cf2c0);
    
    data["test-88-founders"].entries.push(MerkleEntry({
      user: 0x0000000000000000000000000000000000000178,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](6);
    
    proof[0] = bytes32(0xf1a559226683afcc6b1a4bbc19ebce6798e6d5b603bbf1af6147d39b1c93182a);
    
    proof[1] = bytes32(0x4988beaf439f1bafcebae1fdad5071e2f0a33e40665c09952991f1f22480ed25);
    
    proof[2] = bytes32(0x1a4bc3c24070cb2af471242266c0dde566622ddb9c47c5a239e767f076880afa);
    
    proof[3] = bytes32(0x5afef715cbd81b4bca67bb64df8fe62a45f2fca75cca29805c82e56bacd1a9b1);
    
    proof[4] = bytes32(0x8b52e774d88983d22339826f149e762c1c1f5837461f9cfaa96e39886af55c6e);
    
    proof[5] = bytes32(0x125db996b9a9107c35258d70bba28311f1652465823dce86eeba80a8df5cf2c0);
    
    data["test-88-founders"].entries.push(MerkleEntry({
      user: 0x0000000000000000000000000000000000000179,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](5);
    
    proof[0] = bytes32(0x5cb61c430095c3315891c8f43d1dbcfb5a6fdb7b47092419974985c340f7d756);
    
    proof[1] = bytes32(0x2a10daadfb6b586ed6c1d7f8926f6d8ac72617d12bbc91b3c28cba021744fd52);
    
    proof[2] = bytes32(0xa22f61a1c1075264dc590bf7579b4044dd0fc8e6fb473727707d53d6aa6a1c18);
    
    proof[3] = bytes32(0x4807e8f4d5ed010f934c03cd4241ed801abf8f6be623dc15e8d2ea75d9f33ff6);
    
    proof[4] = bytes32(0x125db996b9a9107c35258d70bba28311f1652465823dce86eeba80a8df5cf2c0);
    
    data["test-88-founders"].entries.push(MerkleEntry({
      user: 0x0000000000000000000000000000000000000180,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](5);
    
    proof[0] = bytes32(0x2a6f15d94d90cc259577f03fed593828681beccd8a4a057e3078311e955c607c);
    
    proof[1] = bytes32(0x2a10daadfb6b586ed6c1d7f8926f6d8ac72617d12bbc91b3c28cba021744fd52);
    
    proof[2] = bytes32(0xa22f61a1c1075264dc590bf7579b4044dd0fc8e6fb473727707d53d6aa6a1c18);
    
    proof[3] = bytes32(0x4807e8f4d5ed010f934c03cd4241ed801abf8f6be623dc15e8d2ea75d9f33ff6);
    
    proof[4] = bytes32(0x125db996b9a9107c35258d70bba28311f1652465823dce86eeba80a8df5cf2c0);
    
    data["test-88-founders"].entries.push(MerkleEntry({
      user: 0x0000000000000000000000000000000000000181,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](5);
    
    proof[0] = bytes32(0x4fffa29d896bdd02bbeda8c84a908588b0184579b3999d057c41eec4423d24d1);
    
    proof[1] = bytes32(0x33fe5c497a500381339c5a09c599479da5eff053b2cedd68c5b79a1e26cf51bb);
    
    proof[2] = bytes32(0xa22f61a1c1075264dc590bf7579b4044dd0fc8e6fb473727707d53d6aa6a1c18);
    
    proof[3] = bytes32(0x4807e8f4d5ed010f934c03cd4241ed801abf8f6be623dc15e8d2ea75d9f33ff6);
    
    proof[4] = bytes32(0x125db996b9a9107c35258d70bba28311f1652465823dce86eeba80a8df5cf2c0);
    
    data["test-88-founders"].entries.push(MerkleEntry({
      user: 0x0000000000000000000000000000000000000182,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](5);
    
    proof[0] = bytes32(0x90f2018115bc27c3c83bd48b72831b06e3f0581adb4d1b2e345f166364d54933);
    
    proof[1] = bytes32(0x33fe5c497a500381339c5a09c599479da5eff053b2cedd68c5b79a1e26cf51bb);
    
    proof[2] = bytes32(0xa22f61a1c1075264dc590bf7579b4044dd0fc8e6fb473727707d53d6aa6a1c18);
    
    proof[3] = bytes32(0x4807e8f4d5ed010f934c03cd4241ed801abf8f6be623dc15e8d2ea75d9f33ff6);
    
    proof[4] = bytes32(0x125db996b9a9107c35258d70bba28311f1652465823dce86eeba80a8df5cf2c0);
    
    data["test-88-founders"].entries.push(MerkleEntry({
      user: 0x0000000000000000000000000000000000000183,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](5);
    
    proof[0] = bytes32(0x9d1666c813912abc02dc52517a50bb8a7f7a30da68844e3766d6dd43a3f06b23);
    
    proof[1] = bytes32(0x1347b1696e2099a44f3cbacd064436091c400c47b1e6a255537281b60cf3efd8);
    
    proof[2] = bytes32(0x9a161006804c888f5c84d53b51d33499cc71cc18ca9b98aefa9002a5d91699bf);
    
    proof[3] = bytes32(0x4807e8f4d5ed010f934c03cd4241ed801abf8f6be623dc15e8d2ea75d9f33ff6);
    
    proof[4] = bytes32(0x125db996b9a9107c35258d70bba28311f1652465823dce86eeba80a8df5cf2c0);
    
    data["test-88-founders"].entries.push(MerkleEntry({
      user: 0x0000000000000000000000000000000000000184,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](5);
    
    proof[0] = bytes32(0xec967c132de3da5649f9b4b130224860883af436715fa71d0cb2892ab8a0e198);
    
    proof[1] = bytes32(0x1347b1696e2099a44f3cbacd064436091c400c47b1e6a255537281b60cf3efd8);
    
    proof[2] = bytes32(0x9a161006804c888f5c84d53b51d33499cc71cc18ca9b98aefa9002a5d91699bf);
    
    proof[3] = bytes32(0x4807e8f4d5ed010f934c03cd4241ed801abf8f6be623dc15e8d2ea75d9f33ff6);
    
    proof[4] = bytes32(0x125db996b9a9107c35258d70bba28311f1652465823dce86eeba80a8df5cf2c0);
    
    data["test-88-founders"].entries.push(MerkleEntry({
      user: 0x0000000000000000000000000000000000000185,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](5);
    
    proof[0] = bytes32(0xac681bf80550294e19ca205f819334607ac6ef05a715f4ac021e748591ef4334);
    
    proof[1] = bytes32(0xeb4769a639bdd35dd02df03ded3d7f39347ed75bddb31f8af47fb9a7fbd12c85);
    
    proof[2] = bytes32(0x9a161006804c888f5c84d53b51d33499cc71cc18ca9b98aefa9002a5d91699bf);
    
    proof[3] = bytes32(0x4807e8f4d5ed010f934c03cd4241ed801abf8f6be623dc15e8d2ea75d9f33ff6);
    
    proof[4] = bytes32(0x125db996b9a9107c35258d70bba28311f1652465823dce86eeba80a8df5cf2c0);
    
    data["test-88-founders"].entries.push(MerkleEntry({
      user: 0x0000000000000000000000000000000000000196,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](5);
    
    proof[0] = bytes32(0xa944c0ac58f5217824dc7e67efccf3ac657efaeada1ffc97e10d1df3499b0bc5);
    
    proof[1] = bytes32(0xeb4769a639bdd35dd02df03ded3d7f39347ed75bddb31f8af47fb9a7fbd12c85);
    
    proof[2] = bytes32(0x9a161006804c888f5c84d53b51d33499cc71cc18ca9b98aefa9002a5d91699bf);
    
    proof[3] = bytes32(0x4807e8f4d5ed010f934c03cd4241ed801abf8f6be623dc15e8d2ea75d9f33ff6);
    
    proof[4] = bytes32(0x125db996b9a9107c35258d70bba28311f1652465823dce86eeba80a8df5cf2c0);
    
    data["test-88-founders"].entries.push(MerkleEntry({
      user: 0x0000000000000000000000000000000000000187,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    
  }
}
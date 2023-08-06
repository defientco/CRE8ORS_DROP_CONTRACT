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
    
    
    data["pre-mint-defient"].root = 0x669913b64a51840c67f9ccdb361fd44335e64f8500d01a253b5ab5cf3d526226;
    
    proof = new bytes32[](3);
    
    proof[0] = bytes32(0xd987eb760785050d5dd294efcfa1421716ed231d3e9f8cc48b88e60b78896c2e);
    
    proof[1] = bytes32(0xf320bae2fd47cb734e6f8e6ca2319456e0ac63079c2b02750c43d6ca3a7c8fd0);
    
    proof[2] = bytes32(0x74027e9a6f841db228d8bf7ae1ea4a383535b83ee0455a72164220326856e6cc);
    
    data["pre-mint-defient"].entries.push(MerkleEntry({
      user: 0xa061fBfa7dC7Ee9f838a717e8B55Fbc34641Bf6e,
      maxMint: 8,
      mintPrice: 150000000000000000,
      proof: proof 
    }));
    
    proof = new bytes32[](3);
    
    proof[0] = bytes32(0x8b99fd372f2b84004d913a8ee40935e8d5c5f80540cf31a7a124d2a2caa03f22);
    
    proof[1] = bytes32(0xf320bae2fd47cb734e6f8e6ca2319456e0ac63079c2b02750c43d6ca3a7c8fd0);
    
    proof[2] = bytes32(0x74027e9a6f841db228d8bf7ae1ea4a383535b83ee0455a72164220326856e6cc);
    
    data["pre-mint-defient"].entries.push(MerkleEntry({
      user: 0xEc11a95acA582F5ECF614695D2825b353Daf2454,
      maxMint: 8,
      mintPrice: 150000000000000000,
      proof: proof 
    }));
    
    proof = new bytes32[](3);
    
    proof[0] = bytes32(0x74830be68e345dc4dedb0913a3f66f96fea1ec51d96a89cabf8c266d0a4ad4cc);
    
    proof[1] = bytes32(0x120fca78c4c80b783ab2d47d061270e8bfb9a41751d408ef70044057c7a8efee);
    
    proof[2] = bytes32(0x74027e9a6f841db228d8bf7ae1ea4a383535b83ee0455a72164220326856e6cc);
    
    data["pre-mint-defient"].entries.push(MerkleEntry({
      user: 0xcfBf34d385EA2d5Eb947063b67eA226dcDA3DC38,
      maxMint: 8,
      mintPrice: 150000000000000000,
      proof: proof 
    }));
    
    proof = new bytes32[](3);
    
    proof[0] = bytes32(0xf99cae6c9d347071bdd0316e09b7b9340264b3d9275887f86a6ce994176e6baf);
    
    proof[1] = bytes32(0x120fca78c4c80b783ab2d47d061270e8bfb9a41751d408ef70044057c7a8efee);
    
    proof[2] = bytes32(0x74027e9a6f841db228d8bf7ae1ea4a383535b83ee0455a72164220326856e6cc);
    
    data["pre-mint-defient"].entries.push(MerkleEntry({
      user: 0x45a3143dC8e28A6d73ad6c6Fd78d80a4CAA17524,
      maxMint: 8,
      mintPrice: 150000000000000000,
      proof: proof 
    }));
    
    proof = new bytes32[](3);
    
    proof[0] = bytes32(0x041a901bf0cd0468688a8084290aaea6fa91f2cd78c791a2cf46853fb2dc8eb6);
    
    proof[1] = bytes32(0x9b7887f7032d6beeeece352e4da2dc2cafdc3ef532980ac4ca6ee0eae474f460);
    
    proof[2] = bytes32(0xce76e30bbd0bc685a5aef45c2c381baaa6bbd02b0a71ec7515f66a590eb6cb3e);
    
    data["pre-mint-defient"].entries.push(MerkleEntry({
      user: 0x9B33A23d46d18300E9fCEfa1A88d6a73D216F58D,
      maxMint: 8,
      mintPrice: 150000000000000000,
      proof: proof 
    }));
    
    proof = new bytes32[](0);
    
    data["pre-mint-defient"].entries.push(MerkleEntry({
      user: 0x282a134a17a330E0a238be2201506D5D786190F7,
      maxMint: 8,
      mintPrice: 150000000000000000,
      proof: proof 
    }));
    
    proof = new bytes32[](3);
    
    proof[0] = bytes32(0xdcb2fe1605e52d59b92cf30db67ca547aded1d9196ec59831ee80ba30ff1b879);
    
    proof[1] = bytes32(0x07671f1f2780ceba3c633cc6b111c7abd5067226b4ed75142ad4df58fdc81c94);
    
    proof[2] = bytes32(0xce76e30bbd0bc685a5aef45c2c381baaa6bbd02b0a71ec7515f66a590eb6cb3e);
    
    data["pre-mint-defient"].entries.push(MerkleEntry({
      user: 0x402E5373F770fb7D7E68Df7D02d5aB7fC43B4116,
      maxMint: 8,
      mintPrice: 150000000000000000,
      proof: proof 
    }));
    
    proof = new bytes32[](3);
    
    proof[0] = bytes32(0x3502d2e39b4f640159322121b5d73154d42934023d87df20c4a3f39bdb274775);
    
    proof[1] = bytes32(0x07671f1f2780ceba3c633cc6b111c7abd5067226b4ed75142ad4df58fdc81c94);
    
    proof[2] = bytes32(0xce76e30bbd0bc685a5aef45c2c381baaa6bbd02b0a71ec7515f66a590eb6cb3e);
    
    data["pre-mint-defient"].entries.push(MerkleEntry({
      user: 0x22e82D83A37CfD6aF2aCa7Db666799Bf14613D85,
      maxMint: 8,
      mintPrice: 150000000000000000,
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
    
    
    data["test-sweets-86-whitelisted-founder"].root = 0x4f0de22618687a8eb57c7805799e2670f22352ebc59ff291ca5ac79d7b448ec5;
    
    proof = new bytes32[](7);
    
    proof[0] = bytes32(0x8639050de2c8d2df9aa14fb2421d0244e89d4ab08a3b8b917d9f348f4014e9c8);
    
    proof[1] = bytes32(0x13e62b9ecb3505587876aadcbc80ece2f339fbb20957ce123bdcae64764ce7d2);
    
    proof[2] = bytes32(0xda49bc6bb152e13a40b1ef8abbb16b0ca6446e5e40abeab434bc38b28342c835);
    
    proof[3] = bytes32(0xd2ded2ce854ab1f4fa04872b9b30e5f5867c08c7668851b86eac007904a71d8b);
    
    proof[4] = bytes32(0x1e520cd96fe68d20ef955704052b064ad99000797f200e0017e8d4fb9c85c53b);
    
    proof[5] = bytes32(0x781a34291fcd5025f439d1d8abf07a6dd4c0f0ad99afb7c260ec2013722cc46a);
    
    proof[6] = bytes32(0x7cd14aac96870a2af0a742db7dd2052f92a4bd34b8bdf16e9c1aebe42142d7fc);
    
    data["test-sweets-86-whitelisted-founder"].entries.push(MerkleEntry({
      user: 0x53b50703c199b0e379575caFE6B3D208676D0593,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](7);
    
    proof[0] = bytes32(0x60cb983b92b627bbd910b7d83da5a27d5514fc3ee7145679daacee57701aecb6);
    
    proof[1] = bytes32(0x13e62b9ecb3505587876aadcbc80ece2f339fbb20957ce123bdcae64764ce7d2);
    
    proof[2] = bytes32(0xda49bc6bb152e13a40b1ef8abbb16b0ca6446e5e40abeab434bc38b28342c835);
    
    proof[3] = bytes32(0xd2ded2ce854ab1f4fa04872b9b30e5f5867c08c7668851b86eac007904a71d8b);
    
    proof[4] = bytes32(0x1e520cd96fe68d20ef955704052b064ad99000797f200e0017e8d4fb9c85c53b);
    
    proof[5] = bytes32(0x781a34291fcd5025f439d1d8abf07a6dd4c0f0ad99afb7c260ec2013722cc46a);
    
    proof[6] = bytes32(0x7cd14aac96870a2af0a742db7dd2052f92a4bd34b8bdf16e9c1aebe42142d7fc);
    
    data["test-sweets-86-whitelisted-founder"].entries.push(MerkleEntry({
      user: 0x1257EA6f17f3bD82B323789cF08B79191CC82b6D,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](7);
    
    proof[0] = bytes32(0x9946029c60ad89fe9561295dde00aa5afb11ebd67ad5657bf66e3118cfc0caed);
    
    proof[1] = bytes32(0xf41f954e406076c0b5ef31db9e1a7a17829276b8659b1fe6587c9116f815acdc);
    
    proof[2] = bytes32(0xda49bc6bb152e13a40b1ef8abbb16b0ca6446e5e40abeab434bc38b28342c835);
    
    proof[3] = bytes32(0xd2ded2ce854ab1f4fa04872b9b30e5f5867c08c7668851b86eac007904a71d8b);
    
    proof[4] = bytes32(0x1e520cd96fe68d20ef955704052b064ad99000797f200e0017e8d4fb9c85c53b);
    
    proof[5] = bytes32(0x781a34291fcd5025f439d1d8abf07a6dd4c0f0ad99afb7c260ec2013722cc46a);
    
    proof[6] = bytes32(0x7cd14aac96870a2af0a742db7dd2052f92a4bd34b8bdf16e9c1aebe42142d7fc);
    
    data["test-sweets-86-whitelisted-founder"].entries.push(MerkleEntry({
      user: 0x00D4da27deDce60F859471D8f595fDB4aE861557,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](7);
    
    proof[0] = bytes32(0x13466a124deb32fadcbad640475632e88bf745a32811ef14f8cfabf67df8914c);
    
    proof[1] = bytes32(0xf41f954e406076c0b5ef31db9e1a7a17829276b8659b1fe6587c9116f815acdc);
    
    proof[2] = bytes32(0xda49bc6bb152e13a40b1ef8abbb16b0ca6446e5e40abeab434bc38b28342c835);
    
    proof[3] = bytes32(0xd2ded2ce854ab1f4fa04872b9b30e5f5867c08c7668851b86eac007904a71d8b);
    
    proof[4] = bytes32(0x1e520cd96fe68d20ef955704052b064ad99000797f200e0017e8d4fb9c85c53b);
    
    proof[5] = bytes32(0x781a34291fcd5025f439d1d8abf07a6dd4c0f0ad99afb7c260ec2013722cc46a);
    
    proof[6] = bytes32(0x7cd14aac96870a2af0a742db7dd2052f92a4bd34b8bdf16e9c1aebe42142d7fc);
    
    data["test-sweets-86-whitelisted-founder"].entries.push(MerkleEntry({
      user: 0x0644161438Ce1e23F050573D0E45A86B98910425,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](7);
    
    proof[0] = bytes32(0x9c661b2bc42a666353bab19fd972e5bf4ff9e4a9041666bd521360b014d666fc);
    
    proof[1] = bytes32(0x8f3a7bc3cc9718bb49d3e57e612af0b4874dd12c51b98d9da9187a523caf960e);
    
    proof[2] = bytes32(0x8cb9860ea7b20e7e56788476b8d7f08ad6e3e0fe2c1028aff6f7e714a59cee48);
    
    proof[3] = bytes32(0xd2ded2ce854ab1f4fa04872b9b30e5f5867c08c7668851b86eac007904a71d8b);
    
    proof[4] = bytes32(0x1e520cd96fe68d20ef955704052b064ad99000797f200e0017e8d4fb9c85c53b);
    
    proof[5] = bytes32(0x781a34291fcd5025f439d1d8abf07a6dd4c0f0ad99afb7c260ec2013722cc46a);
    
    proof[6] = bytes32(0x7cd14aac96870a2af0a742db7dd2052f92a4bd34b8bdf16e9c1aebe42142d7fc);
    
    data["test-sweets-86-whitelisted-founder"].entries.push(MerkleEntry({
      user: 0x07E061ED6D32dE342dc4026f81E79eD87Ee22361,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](7);
    
    proof[0] = bytes32(0x47edb84cc0277cfd395bb7ef6429b6d41b5e74ce55a822ca5125a679eee3a739);
    
    proof[1] = bytes32(0x8f3a7bc3cc9718bb49d3e57e612af0b4874dd12c51b98d9da9187a523caf960e);
    
    proof[2] = bytes32(0x8cb9860ea7b20e7e56788476b8d7f08ad6e3e0fe2c1028aff6f7e714a59cee48);
    
    proof[3] = bytes32(0xd2ded2ce854ab1f4fa04872b9b30e5f5867c08c7668851b86eac007904a71d8b);
    
    proof[4] = bytes32(0x1e520cd96fe68d20ef955704052b064ad99000797f200e0017e8d4fb9c85c53b);
    
    proof[5] = bytes32(0x781a34291fcd5025f439d1d8abf07a6dd4c0f0ad99afb7c260ec2013722cc46a);
    
    proof[6] = bytes32(0x7cd14aac96870a2af0a742db7dd2052f92a4bd34b8bdf16e9c1aebe42142d7fc);
    
    data["test-sweets-86-whitelisted-founder"].entries.push(MerkleEntry({
      user: 0x1891D89e6598aE763C6565DE8Fe679f2Da76D868,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](7);
    
    proof[0] = bytes32(0x6b7148a5d66b755887ac68e31d16e2240ded1ed52ba84091a99663ce28067802);
    
    proof[1] = bytes32(0x2e8b92fe600a8b68367de5a28824b7317328f93ca5beeb87d9387c99a6c816c3);
    
    proof[2] = bytes32(0x8cb9860ea7b20e7e56788476b8d7f08ad6e3e0fe2c1028aff6f7e714a59cee48);
    
    proof[3] = bytes32(0xd2ded2ce854ab1f4fa04872b9b30e5f5867c08c7668851b86eac007904a71d8b);
    
    proof[4] = bytes32(0x1e520cd96fe68d20ef955704052b064ad99000797f200e0017e8d4fb9c85c53b);
    
    proof[5] = bytes32(0x781a34291fcd5025f439d1d8abf07a6dd4c0f0ad99afb7c260ec2013722cc46a);
    
    proof[6] = bytes32(0x7cd14aac96870a2af0a742db7dd2052f92a4bd34b8bdf16e9c1aebe42142d7fc);
    
    data["test-sweets-86-whitelisted-founder"].entries.push(MerkleEntry({
      user: 0x1ed577E7756Bc9b417B6CB4C77e880E761628216,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](7);
    
    proof[0] = bytes32(0x3e7079ec6d9909aa1f04109240eb11ee61e7c8d7bb1c5a4a0df325245034f40a);
    
    proof[1] = bytes32(0x2e8b92fe600a8b68367de5a28824b7317328f93ca5beeb87d9387c99a6c816c3);
    
    proof[2] = bytes32(0x8cb9860ea7b20e7e56788476b8d7f08ad6e3e0fe2c1028aff6f7e714a59cee48);
    
    proof[3] = bytes32(0xd2ded2ce854ab1f4fa04872b9b30e5f5867c08c7668851b86eac007904a71d8b);
    
    proof[4] = bytes32(0x1e520cd96fe68d20ef955704052b064ad99000797f200e0017e8d4fb9c85c53b);
    
    proof[5] = bytes32(0x781a34291fcd5025f439d1d8abf07a6dd4c0f0ad99afb7c260ec2013722cc46a);
    
    proof[6] = bytes32(0x7cd14aac96870a2af0a742db7dd2052f92a4bd34b8bdf16e9c1aebe42142d7fc);
    
    data["test-sweets-86-whitelisted-founder"].entries.push(MerkleEntry({
      user: 0x21dE2BBEc05468FC41aF5eF2E9e5bbFF21F487b3,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](7);
    
    proof[0] = bytes32(0x077815135b98a45e55ab757bd02a581db4672122798fa90bd2aae653a251849f);
    
    proof[1] = bytes32(0x7e1aa3a2617eb6b103abe461f256305c6ba6e89ff3d6455742294fed7da3f7bb);
    
    proof[2] = bytes32(0x9a6bf94e3c9b4ef1f5b3faa7155112b084349ef9af11b8bcce11a7fd6394718f);
    
    proof[3] = bytes32(0xe4b5131ad312c61c46580aac4d72069c617788199e1a068ab8bf721244ac5292);
    
    proof[4] = bytes32(0x1e520cd96fe68d20ef955704052b064ad99000797f200e0017e8d4fb9c85c53b);
    
    proof[5] = bytes32(0x781a34291fcd5025f439d1d8abf07a6dd4c0f0ad99afb7c260ec2013722cc46a);
    
    proof[6] = bytes32(0x7cd14aac96870a2af0a742db7dd2052f92a4bd34b8bdf16e9c1aebe42142d7fc);
    
    data["test-sweets-86-whitelisted-founder"].entries.push(MerkleEntry({
      user: 0x28a7849118c2AC997C24FA63E9B67D3aa3bb9001,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](0);
    
    data["test-sweets-86-whitelisted-founder"].entries.push(MerkleEntry({
      user: 0x2e9483d2426Ea7Acead4e6584463cCC62768d42F,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](7);
    
    proof[0] = bytes32(0xb9e958322a7bef10198513060aa5915606e7a806cd8f37b089b8f74e64845da9);
    
    proof[1] = bytes32(0xd0d4acff50576fa6d1d15517c242d237aab99073fbdea0ec2f4098b70d77ec94);
    
    proof[2] = bytes32(0x9a6bf94e3c9b4ef1f5b3faa7155112b084349ef9af11b8bcce11a7fd6394718f);
    
    proof[3] = bytes32(0xe4b5131ad312c61c46580aac4d72069c617788199e1a068ab8bf721244ac5292);
    
    proof[4] = bytes32(0x1e520cd96fe68d20ef955704052b064ad99000797f200e0017e8d4fb9c85c53b);
    
    proof[5] = bytes32(0x781a34291fcd5025f439d1d8abf07a6dd4c0f0ad99afb7c260ec2013722cc46a);
    
    proof[6] = bytes32(0x7cd14aac96870a2af0a742db7dd2052f92a4bd34b8bdf16e9c1aebe42142d7fc);
    
    data["test-sweets-86-whitelisted-founder"].entries.push(MerkleEntry({
      user: 0x344B16e9cCa560d29951ec2d56F0c2f61158a603,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](7);
    
    proof[0] = bytes32(0xaab1093f79ad3a6017901ea2be20e37bff070aa3172165266b6cee18b5564c76);
    
    proof[1] = bytes32(0xd0d4acff50576fa6d1d15517c242d237aab99073fbdea0ec2f4098b70d77ec94);
    
    proof[2] = bytes32(0x9a6bf94e3c9b4ef1f5b3faa7155112b084349ef9af11b8bcce11a7fd6394718f);
    
    proof[3] = bytes32(0xe4b5131ad312c61c46580aac4d72069c617788199e1a068ab8bf721244ac5292);
    
    proof[4] = bytes32(0x1e520cd96fe68d20ef955704052b064ad99000797f200e0017e8d4fb9c85c53b);
    
    proof[5] = bytes32(0x781a34291fcd5025f439d1d8abf07a6dd4c0f0ad99afb7c260ec2013722cc46a);
    
    proof[6] = bytes32(0x7cd14aac96870a2af0a742db7dd2052f92a4bd34b8bdf16e9c1aebe42142d7fc);
    
    data["test-sweets-86-whitelisted-founder"].entries.push(MerkleEntry({
      user: 0x419C77108b0eF4b1FA5c394AE4aECE0a14f4cea5,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](7);
    
    proof[0] = bytes32(0x89a2dd6d8558e9d1615b8ed87ea81018a7a3dcb0478727314ff89d69b41b8a87);
    
    proof[1] = bytes32(0xda1e920c6d7577bcc074586663788357eda016245efe382eb45c8d7f6e52037e);
    
    proof[2] = bytes32(0x23e1a7a305ea08ba4f9bb064242a5d5c4ae4e0c95ab605bbd270bfbea87f4aa3);
    
    proof[3] = bytes32(0xe4b5131ad312c61c46580aac4d72069c617788199e1a068ab8bf721244ac5292);
    
    proof[4] = bytes32(0x1e520cd96fe68d20ef955704052b064ad99000797f200e0017e8d4fb9c85c53b);
    
    proof[5] = bytes32(0x781a34291fcd5025f439d1d8abf07a6dd4c0f0ad99afb7c260ec2013722cc46a);
    
    proof[6] = bytes32(0x7cd14aac96870a2af0a742db7dd2052f92a4bd34b8bdf16e9c1aebe42142d7fc);
    
    data["test-sweets-86-whitelisted-founder"].entries.push(MerkleEntry({
      user: 0x56fa9263a6B02A5a1259F8d7489693c197836841,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](7);
    
    proof[0] = bytes32(0x44504192962a0861c6ebf849992024b9df5d9f17b2ba39ccfeae8b6bd073996d);
    
    proof[1] = bytes32(0xda1e920c6d7577bcc074586663788357eda016245efe382eb45c8d7f6e52037e);
    
    proof[2] = bytes32(0x23e1a7a305ea08ba4f9bb064242a5d5c4ae4e0c95ab605bbd270bfbea87f4aa3);
    
    proof[3] = bytes32(0xe4b5131ad312c61c46580aac4d72069c617788199e1a068ab8bf721244ac5292);
    
    proof[4] = bytes32(0x1e520cd96fe68d20ef955704052b064ad99000797f200e0017e8d4fb9c85c53b);
    
    proof[5] = bytes32(0x781a34291fcd5025f439d1d8abf07a6dd4c0f0ad99afb7c260ec2013722cc46a);
    
    proof[6] = bytes32(0x7cd14aac96870a2af0a742db7dd2052f92a4bd34b8bdf16e9c1aebe42142d7fc);
    
    data["test-sweets-86-whitelisted-founder"].entries.push(MerkleEntry({
      user: 0x6F4ed5952e0a76e792e80698e9Df47C477c29770,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](7);
    
    proof[0] = bytes32(0xe299dc700d71ecf8d50dd4d0114384b32df40210eb1540582a95fce6813cd5b8);
    
    proof[1] = bytes32(0x6bcdc8de247dba332ae8ef02e9e4e16a5c0f008e486c297f981448ea5cba4a26);
    
    proof[2] = bytes32(0x23e1a7a305ea08ba4f9bb064242a5d5c4ae4e0c95ab605bbd270bfbea87f4aa3);
    
    proof[3] = bytes32(0xe4b5131ad312c61c46580aac4d72069c617788199e1a068ab8bf721244ac5292);
    
    proof[4] = bytes32(0x1e520cd96fe68d20ef955704052b064ad99000797f200e0017e8d4fb9c85c53b);
    
    proof[5] = bytes32(0x781a34291fcd5025f439d1d8abf07a6dd4c0f0ad99afb7c260ec2013722cc46a);
    
    proof[6] = bytes32(0x7cd14aac96870a2af0a742db7dd2052f92a4bd34b8bdf16e9c1aebe42142d7fc);
    
    data["test-sweets-86-whitelisted-founder"].entries.push(MerkleEntry({
      user: 0x724c05D323Ef747465E68F621A2B10Edd9a84463,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](7);
    
    proof[0] = bytes32(0xae8c6b325daaaac9a4a67e53c2214e046458310455ac8fee561afbba103fbda3);
    
    proof[1] = bytes32(0x6bcdc8de247dba332ae8ef02e9e4e16a5c0f008e486c297f981448ea5cba4a26);
    
    proof[2] = bytes32(0x23e1a7a305ea08ba4f9bb064242a5d5c4ae4e0c95ab605bbd270bfbea87f4aa3);
    
    proof[3] = bytes32(0xe4b5131ad312c61c46580aac4d72069c617788199e1a068ab8bf721244ac5292);
    
    proof[4] = bytes32(0x1e520cd96fe68d20ef955704052b064ad99000797f200e0017e8d4fb9c85c53b);
    
    proof[5] = bytes32(0x781a34291fcd5025f439d1d8abf07a6dd4c0f0ad99afb7c260ec2013722cc46a);
    
    proof[6] = bytes32(0x7cd14aac96870a2af0a742db7dd2052f92a4bd34b8bdf16e9c1aebe42142d7fc);
    
    data["test-sweets-86-whitelisted-founder"].entries.push(MerkleEntry({
      user: 0x849f03ACc35C6F4A861b76e1F271d217CD24b18C,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](7);
    
    proof[0] = bytes32(0x9c1a31b0fac08e63387e20c2008fd8482c3737bcb2be07f081f9cc71d21162ab);
    
    proof[1] = bytes32(0xa1836f431f2fe5452ef846bf5c8e5b64b661c26ba0dfc5216db373b36505833e);
    
    proof[2] = bytes32(0x901b757951ef4c607df8e0f0be2a398739ce6a1c8bfeca4dbdbecc00a2e363fe);
    
    proof[3] = bytes32(0x5052afb6c734cea658b3f93fbab9a46bc4f29eb30cc8ee4fe9b063f092d92b1f);
    
    proof[4] = bytes32(0x1821a5edf29626d12e56702cbe4aa52814ce989a7f45cd0e29b6503bc396a843);
    
    proof[5] = bytes32(0x781a34291fcd5025f439d1d8abf07a6dd4c0f0ad99afb7c260ec2013722cc46a);
    
    proof[6] = bytes32(0x7cd14aac96870a2af0a742db7dd2052f92a4bd34b8bdf16e9c1aebe42142d7fc);
    
    data["test-sweets-86-whitelisted-founder"].entries.push(MerkleEntry({
      user: 0x9Bfff4Bb48e39a14dc945Eb8707B2a6EE8FdeC6D,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](7);
    
    proof[0] = bytes32(0x339241f650a193bebf8120175a2d09cce75cb7435fc655f3e3c40ad9d78f280b);
    
    proof[1] = bytes32(0xa1836f431f2fe5452ef846bf5c8e5b64b661c26ba0dfc5216db373b36505833e);
    
    proof[2] = bytes32(0x901b757951ef4c607df8e0f0be2a398739ce6a1c8bfeca4dbdbecc00a2e363fe);
    
    proof[3] = bytes32(0x5052afb6c734cea658b3f93fbab9a46bc4f29eb30cc8ee4fe9b063f092d92b1f);
    
    proof[4] = bytes32(0x1821a5edf29626d12e56702cbe4aa52814ce989a7f45cd0e29b6503bc396a843);
    
    proof[5] = bytes32(0x781a34291fcd5025f439d1d8abf07a6dd4c0f0ad99afb7c260ec2013722cc46a);
    
    proof[6] = bytes32(0x7cd14aac96870a2af0a742db7dd2052f92a4bd34b8bdf16e9c1aebe42142d7fc);
    
    data["test-sweets-86-whitelisted-founder"].entries.push(MerkleEntry({
      user: 0x9cFc48ED238190B7338DB2e7ED10891197590CEe,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](7);
    
    proof[0] = bytes32(0xa22e75d8212789cdfe7422a56db12238c8bdf1fe1d6c5b9df4c8f84d5c6e8b1a);
    
    proof[1] = bytes32(0x85ba45ccb43a47cd3552c882f806c71e3b4c64c2950594afc769bcce99cfa58c);
    
    proof[2] = bytes32(0x901b757951ef4c607df8e0f0be2a398739ce6a1c8bfeca4dbdbecc00a2e363fe);
    
    proof[3] = bytes32(0x5052afb6c734cea658b3f93fbab9a46bc4f29eb30cc8ee4fe9b063f092d92b1f);
    
    proof[4] = bytes32(0x1821a5edf29626d12e56702cbe4aa52814ce989a7f45cd0e29b6503bc396a843);
    
    proof[5] = bytes32(0x781a34291fcd5025f439d1d8abf07a6dd4c0f0ad99afb7c260ec2013722cc46a);
    
    proof[6] = bytes32(0x7cd14aac96870a2af0a742db7dd2052f92a4bd34b8bdf16e9c1aebe42142d7fc);
    
    data["test-sweets-86-whitelisted-founder"].entries.push(MerkleEntry({
      user: 0xA5D4A2c359C958C0530E37d801e851f7b7F7D69c,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](7);
    
    proof[0] = bytes32(0x86b106b13d844e9b1e4f824c27d8ce7350cf27e45c8297b496430eb33067c421);
    
    proof[1] = bytes32(0x85ba45ccb43a47cd3552c882f806c71e3b4c64c2950594afc769bcce99cfa58c);
    
    proof[2] = bytes32(0x901b757951ef4c607df8e0f0be2a398739ce6a1c8bfeca4dbdbecc00a2e363fe);
    
    proof[3] = bytes32(0x5052afb6c734cea658b3f93fbab9a46bc4f29eb30cc8ee4fe9b063f092d92b1f);
    
    proof[4] = bytes32(0x1821a5edf29626d12e56702cbe4aa52814ce989a7f45cd0e29b6503bc396a843);
    
    proof[5] = bytes32(0x781a34291fcd5025f439d1d8abf07a6dd4c0f0ad99afb7c260ec2013722cc46a);
    
    proof[6] = bytes32(0x7cd14aac96870a2af0a742db7dd2052f92a4bd34b8bdf16e9c1aebe42142d7fc);
    
    data["test-sweets-86-whitelisted-founder"].entries.push(MerkleEntry({
      user: 0xad7b71C53fE26F6896Cd3A2F0931a8Ab99B4107d,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](7);
    
    proof[0] = bytes32(0x261dfc87389d4c8c8b8645cb3a11ebba5a6c366fd0b36cf64add829ee57ea5bf);
    
    proof[1] = bytes32(0xd323b7976441f6d566a4855101ea3f1640bcc5eada51b5aa4d4ca32738436210);
    
    proof[2] = bytes32(0xd7ccc55fb54001ad125553cdfb53bf85ea177fde997242451c9c57da2a3b6fbd);
    
    proof[3] = bytes32(0x5052afb6c734cea658b3f93fbab9a46bc4f29eb30cc8ee4fe9b063f092d92b1f);
    
    proof[4] = bytes32(0x1821a5edf29626d12e56702cbe4aa52814ce989a7f45cd0e29b6503bc396a843);
    
    proof[5] = bytes32(0x781a34291fcd5025f439d1d8abf07a6dd4c0f0ad99afb7c260ec2013722cc46a);
    
    proof[6] = bytes32(0x7cd14aac96870a2af0a742db7dd2052f92a4bd34b8bdf16e9c1aebe42142d7fc);
    
    data["test-sweets-86-whitelisted-founder"].entries.push(MerkleEntry({
      user: 0xB06De036641C6D855C6D572E1a7C8CF27d64bcd1,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](7);
    
    proof[0] = bytes32(0x497d6446d67ecafae6e8b95cba209dd18da286ccec90219cab50e5c2b9002dfd);
    
    proof[1] = bytes32(0xd323b7976441f6d566a4855101ea3f1640bcc5eada51b5aa4d4ca32738436210);
    
    proof[2] = bytes32(0xd7ccc55fb54001ad125553cdfb53bf85ea177fde997242451c9c57da2a3b6fbd);
    
    proof[3] = bytes32(0x5052afb6c734cea658b3f93fbab9a46bc4f29eb30cc8ee4fe9b063f092d92b1f);
    
    proof[4] = bytes32(0x1821a5edf29626d12e56702cbe4aa52814ce989a7f45cd0e29b6503bc396a843);
    
    proof[5] = bytes32(0x781a34291fcd5025f439d1d8abf07a6dd4c0f0ad99afb7c260ec2013722cc46a);
    
    proof[6] = bytes32(0x7cd14aac96870a2af0a742db7dd2052f92a4bd34b8bdf16e9c1aebe42142d7fc);
    
    data["test-sweets-86-whitelisted-founder"].entries.push(MerkleEntry({
      user: 0xC808CB8b45257ab8E67bB87448F12128e0B2E4d0,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](7);
    
    proof[0] = bytes32(0xbe08428dd22e35dedc2f6a94859b427e8da9e72af048f0d4cd596d46eefc587a);
    
    proof[1] = bytes32(0x289d1351e34d04233af143829c26a5b1f3c2a90871a9d670493f71cdd66daa8b);
    
    proof[2] = bytes32(0xd7ccc55fb54001ad125553cdfb53bf85ea177fde997242451c9c57da2a3b6fbd);
    
    proof[3] = bytes32(0x5052afb6c734cea658b3f93fbab9a46bc4f29eb30cc8ee4fe9b063f092d92b1f);
    
    proof[4] = bytes32(0x1821a5edf29626d12e56702cbe4aa52814ce989a7f45cd0e29b6503bc396a843);
    
    proof[5] = bytes32(0x781a34291fcd5025f439d1d8abf07a6dd4c0f0ad99afb7c260ec2013722cc46a);
    
    proof[6] = bytes32(0x7cd14aac96870a2af0a742db7dd2052f92a4bd34b8bdf16e9c1aebe42142d7fc);
    
    data["test-sweets-86-whitelisted-founder"].entries.push(MerkleEntry({
      user: 0xCf86e52A434993AD77E9BC5673BAB7f15B65165e,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](7);
    
    proof[0] = bytes32(0x94494eb1f84008671731064cc7877a82524c72fe2a2a2abd12d9804fde4873dc);
    
    proof[1] = bytes32(0x289d1351e34d04233af143829c26a5b1f3c2a90871a9d670493f71cdd66daa8b);
    
    proof[2] = bytes32(0xd7ccc55fb54001ad125553cdfb53bf85ea177fde997242451c9c57da2a3b6fbd);
    
    proof[3] = bytes32(0x5052afb6c734cea658b3f93fbab9a46bc4f29eb30cc8ee4fe9b063f092d92b1f);
    
    proof[4] = bytes32(0x1821a5edf29626d12e56702cbe4aa52814ce989a7f45cd0e29b6503bc396a843);
    
    proof[5] = bytes32(0x781a34291fcd5025f439d1d8abf07a6dd4c0f0ad99afb7c260ec2013722cc46a);
    
    proof[6] = bytes32(0x7cd14aac96870a2af0a742db7dd2052f92a4bd34b8bdf16e9c1aebe42142d7fc);
    
    data["test-sweets-86-whitelisted-founder"].entries.push(MerkleEntry({
      user: 0xdC3c1c2126289bb2A4F5DdA0c6a0c67035697719,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](7);
    
    proof[0] = bytes32(0xb10608e999c6915e3cca9576fcc6269b53a96d874f0889e40bf61e4ba1642542);
    
    proof[1] = bytes32(0xff3d518bf7978afa870bcf6c90d10a6cb719020e998f2d35d0156e33ed388417);
    
    proof[2] = bytes32(0x9ea7e5d5a67a933842ac9895b38fa4a25f8f00a6d0a3e4f110c75a90a03f3af8);
    
    proof[3] = bytes32(0x56a42d828c86c2ef6c7b1fdc91f6d519997e2c7ca7d99464c643fbe526c9976e);
    
    proof[4] = bytes32(0x1821a5edf29626d12e56702cbe4aa52814ce989a7f45cd0e29b6503bc396a843);
    
    proof[5] = bytes32(0x781a34291fcd5025f439d1d8abf07a6dd4c0f0ad99afb7c260ec2013722cc46a);
    
    proof[6] = bytes32(0x7cd14aac96870a2af0a742db7dd2052f92a4bd34b8bdf16e9c1aebe42142d7fc);
    
    data["test-sweets-86-whitelisted-founder"].entries.push(MerkleEntry({
      user: 0xE65416906B8C0936aE0463d2B45bf7090102A438,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](7);
    
    proof[0] = bytes32(0xd7cb4c3a64dad4a7b035c23f420abd96c8a29487b8684b4595a84fbf13eca079);
    
    proof[1] = bytes32(0xff3d518bf7978afa870bcf6c90d10a6cb719020e998f2d35d0156e33ed388417);
    
    proof[2] = bytes32(0x9ea7e5d5a67a933842ac9895b38fa4a25f8f00a6d0a3e4f110c75a90a03f3af8);
    
    proof[3] = bytes32(0x56a42d828c86c2ef6c7b1fdc91f6d519997e2c7ca7d99464c643fbe526c9976e);
    
    proof[4] = bytes32(0x1821a5edf29626d12e56702cbe4aa52814ce989a7f45cd0e29b6503bc396a843);
    
    proof[5] = bytes32(0x781a34291fcd5025f439d1d8abf07a6dd4c0f0ad99afb7c260ec2013722cc46a);
    
    proof[6] = bytes32(0x7cd14aac96870a2af0a742db7dd2052f92a4bd34b8bdf16e9c1aebe42142d7fc);
    
    data["test-sweets-86-whitelisted-founder"].entries.push(MerkleEntry({
      user: 0xF9d08A28c634A5939c9F93368e438B55932E5806,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](7);
    
    proof[0] = bytes32(0x3cd7b02b89e03b157cb2210f64a1012e6e2ac02534d1184f9187207d8b844242);
    
    proof[1] = bytes32(0xa72ab1bcb498bd6191dc7b350702ebd235fa68a9816180de36b8c0e81a9fac44);
    
    proof[2] = bytes32(0x9ea7e5d5a67a933842ac9895b38fa4a25f8f00a6d0a3e4f110c75a90a03f3af8);
    
    proof[3] = bytes32(0x56a42d828c86c2ef6c7b1fdc91f6d519997e2c7ca7d99464c643fbe526c9976e);
    
    proof[4] = bytes32(0x1821a5edf29626d12e56702cbe4aa52814ce989a7f45cd0e29b6503bc396a843);
    
    proof[5] = bytes32(0x781a34291fcd5025f439d1d8abf07a6dd4c0f0ad99afb7c260ec2013722cc46a);
    
    proof[6] = bytes32(0x7cd14aac96870a2af0a742db7dd2052f92a4bd34b8bdf16e9c1aebe42142d7fc);
    
    data["test-sweets-86-whitelisted-founder"].entries.push(MerkleEntry({
      user: 0x18f2145e46E77Cb0405fF9A486A194698326Ee38,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](7);
    
    proof[0] = bytes32(0x9f6306f3b246acb8de04f32f1bf8125b780c47456bd0bb18922328075e13e0a0);
    
    proof[1] = bytes32(0xa72ab1bcb498bd6191dc7b350702ebd235fa68a9816180de36b8c0e81a9fac44);
    
    proof[2] = bytes32(0x9ea7e5d5a67a933842ac9895b38fa4a25f8f00a6d0a3e4f110c75a90a03f3af8);
    
    proof[3] = bytes32(0x56a42d828c86c2ef6c7b1fdc91f6d519997e2c7ca7d99464c643fbe526c9976e);
    
    proof[4] = bytes32(0x1821a5edf29626d12e56702cbe4aa52814ce989a7f45cd0e29b6503bc396a843);
    
    proof[5] = bytes32(0x781a34291fcd5025f439d1d8abf07a6dd4c0f0ad99afb7c260ec2013722cc46a);
    
    proof[6] = bytes32(0x7cd14aac96870a2af0a742db7dd2052f92a4bd34b8bdf16e9c1aebe42142d7fc);
    
    data["test-sweets-86-whitelisted-founder"].entries.push(MerkleEntry({
      user: 0x2697f24A0128F4BC44c37576152518EC6Cd70924,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](7);
    
    proof[0] = bytes32(0x14adcbe1628ed4fb76235ffc4d63158165fd9149b5eee78782da41fc46a5d211);
    
    proof[1] = bytes32(0x2ef960bd0b8ed006a9836d7fe8522a391ec1633ef4fea8de1cd0a9266c9021fc);
    
    proof[2] = bytes32(0xf90c834f31e8741d36de3bf398dda0de8cea5068dee455fc90f23af3971f6434);
    
    proof[3] = bytes32(0x56a42d828c86c2ef6c7b1fdc91f6d519997e2c7ca7d99464c643fbe526c9976e);
    
    proof[4] = bytes32(0x1821a5edf29626d12e56702cbe4aa52814ce989a7f45cd0e29b6503bc396a843);
    
    proof[5] = bytes32(0x781a34291fcd5025f439d1d8abf07a6dd4c0f0ad99afb7c260ec2013722cc46a);
    
    proof[6] = bytes32(0x7cd14aac96870a2af0a742db7dd2052f92a4bd34b8bdf16e9c1aebe42142d7fc);
    
    data["test-sweets-86-whitelisted-founder"].entries.push(MerkleEntry({
      user: 0x7f05D5F291922aC1fcF5aD07f419791853e34DA9,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](7);
    
    proof[0] = bytes32(0x3f5b349a9169789f7d3dff2d77370c3470da88b42de4ebd60a9eec25f47aa5ab);
    
    proof[1] = bytes32(0x2ef960bd0b8ed006a9836d7fe8522a391ec1633ef4fea8de1cd0a9266c9021fc);
    
    proof[2] = bytes32(0xf90c834f31e8741d36de3bf398dda0de8cea5068dee455fc90f23af3971f6434);
    
    proof[3] = bytes32(0x56a42d828c86c2ef6c7b1fdc91f6d519997e2c7ca7d99464c643fbe526c9976e);
    
    proof[4] = bytes32(0x1821a5edf29626d12e56702cbe4aa52814ce989a7f45cd0e29b6503bc396a843);
    
    proof[5] = bytes32(0x781a34291fcd5025f439d1d8abf07a6dd4c0f0ad99afb7c260ec2013722cc46a);
    
    proof[6] = bytes32(0x7cd14aac96870a2af0a742db7dd2052f92a4bd34b8bdf16e9c1aebe42142d7fc);
    
    data["test-sweets-86-whitelisted-founder"].entries.push(MerkleEntry({
      user: 0x045f5C44522cD53603664b7bA3DEa3928a6417d5,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](7);
    
    proof[0] = bytes32(0x43b3b8b5d4d2542c4ef4cd2a594122922e88ec7d361f3a38945511fdb4a2a44a);
    
    proof[1] = bytes32(0x06984d045871aa969f44af87f34a59ee243a336797a09c4c1fbfcc0b95934e5c);
    
    proof[2] = bytes32(0xf90c834f31e8741d36de3bf398dda0de8cea5068dee455fc90f23af3971f6434);
    
    proof[3] = bytes32(0x56a42d828c86c2ef6c7b1fdc91f6d519997e2c7ca7d99464c643fbe526c9976e);
    
    proof[4] = bytes32(0x1821a5edf29626d12e56702cbe4aa52814ce989a7f45cd0e29b6503bc396a843);
    
    proof[5] = bytes32(0x781a34291fcd5025f439d1d8abf07a6dd4c0f0ad99afb7c260ec2013722cc46a);
    
    proof[6] = bytes32(0x7cd14aac96870a2af0a742db7dd2052f92a4bd34b8bdf16e9c1aebe42142d7fc);
    
    data["test-sweets-86-whitelisted-founder"].entries.push(MerkleEntry({
      user: 0x4210EeE2bc528b0A846EaA016cE8167A840B8B23,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](7);
    
    proof[0] = bytes32(0x5cae91f3b56ff61b971f4c72331b49f6f0d53ca9caf860356edacb82689d6749);
    
    proof[1] = bytes32(0x06984d045871aa969f44af87f34a59ee243a336797a09c4c1fbfcc0b95934e5c);
    
    proof[2] = bytes32(0xf90c834f31e8741d36de3bf398dda0de8cea5068dee455fc90f23af3971f6434);
    
    proof[3] = bytes32(0x56a42d828c86c2ef6c7b1fdc91f6d519997e2c7ca7d99464c643fbe526c9976e);
    
    proof[4] = bytes32(0x1821a5edf29626d12e56702cbe4aa52814ce989a7f45cd0e29b6503bc396a843);
    
    proof[5] = bytes32(0x781a34291fcd5025f439d1d8abf07a6dd4c0f0ad99afb7c260ec2013722cc46a);
    
    proof[6] = bytes32(0x7cd14aac96870a2af0a742db7dd2052f92a4bd34b8bdf16e9c1aebe42142d7fc);
    
    data["test-sweets-86-whitelisted-founder"].entries.push(MerkleEntry({
      user: 0x476d8f71D85a4f2b12f6720fbd77d2E471a83B95,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](7);
    
    proof[0] = bytes32(0x1cb2a9070de67d9b0892ca03aa190d60d220382afc779c316fbb240bbd0f3f94);
    
    proof[1] = bytes32(0x44a89b21230c0be3ad384213e6a06aea81ea317bcfe4b44aa81892113895d808);
    
    proof[2] = bytes32(0xb15180db451eb8f90e180eb0015d5b29c669bf46f7f710da22de295f6cfc99aa);
    
    proof[3] = bytes32(0x4ed1b75f279cb1d94517c150b203c9c00633b437462550a3aa8f3fbecd17b601);
    
    proof[4] = bytes32(0x602ea1a3a520819c4f02c388e68dfae8b9590b32a8532da8d01acc3487fb7fb0);
    
    proof[5] = bytes32(0x62835db99b3a73e4627b73609b414714289c1c9f82cf228af5bdf6deda2f985d);
    
    proof[6] = bytes32(0x7cd14aac96870a2af0a742db7dd2052f92a4bd34b8bdf16e9c1aebe42142d7fc);
    
    data["test-sweets-86-whitelisted-founder"].entries.push(MerkleEntry({
      user: 0x547a9fAC996aDF04A865F7df3f8957Be4a224135,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](7);
    
    proof[0] = bytes32(0xbda54b78588563b530eb07b955666d323b7a0a308afb64f0e9418b8f7001e447);
    
    proof[1] = bytes32(0x44a89b21230c0be3ad384213e6a06aea81ea317bcfe4b44aa81892113895d808);
    
    proof[2] = bytes32(0xb15180db451eb8f90e180eb0015d5b29c669bf46f7f710da22de295f6cfc99aa);
    
    proof[3] = bytes32(0x4ed1b75f279cb1d94517c150b203c9c00633b437462550a3aa8f3fbecd17b601);
    
    proof[4] = bytes32(0x602ea1a3a520819c4f02c388e68dfae8b9590b32a8532da8d01acc3487fb7fb0);
    
    proof[5] = bytes32(0x62835db99b3a73e4627b73609b414714289c1c9f82cf228af5bdf6deda2f985d);
    
    proof[6] = bytes32(0x7cd14aac96870a2af0a742db7dd2052f92a4bd34b8bdf16e9c1aebe42142d7fc);
    
    data["test-sweets-86-whitelisted-founder"].entries.push(MerkleEntry({
      user: 0x5AE67754420a6FBB85270b9D71CA21977d889583,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](7);
    
    proof[0] = bytes32(0xbb4aa0ff1089dac1212d690ffff73a857add4273590b2eba954a2031046bbb14);
    
    proof[1] = bytes32(0x18f379d94a602fe7492c7d579b7467ea550d3347ff73571f6f16755f648f1c8f);
    
    proof[2] = bytes32(0xb15180db451eb8f90e180eb0015d5b29c669bf46f7f710da22de295f6cfc99aa);
    
    proof[3] = bytes32(0x4ed1b75f279cb1d94517c150b203c9c00633b437462550a3aa8f3fbecd17b601);
    
    proof[4] = bytes32(0x602ea1a3a520819c4f02c388e68dfae8b9590b32a8532da8d01acc3487fb7fb0);
    
    proof[5] = bytes32(0x62835db99b3a73e4627b73609b414714289c1c9f82cf228af5bdf6deda2f985d);
    
    proof[6] = bytes32(0x7cd14aac96870a2af0a742db7dd2052f92a4bd34b8bdf16e9c1aebe42142d7fc);
    
    data["test-sweets-86-whitelisted-founder"].entries.push(MerkleEntry({
      user: 0x5F8Fbf2a4E4e18cadDB4619635818667fC2A075B,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](7);
    
    proof[0] = bytes32(0x131e4e137a10d27014684e063c2ba8673bd93b9c828cd31a7f698816e0a0e862);
    
    proof[1] = bytes32(0x18f379d94a602fe7492c7d579b7467ea550d3347ff73571f6f16755f648f1c8f);
    
    proof[2] = bytes32(0xb15180db451eb8f90e180eb0015d5b29c669bf46f7f710da22de295f6cfc99aa);
    
    proof[3] = bytes32(0x4ed1b75f279cb1d94517c150b203c9c00633b437462550a3aa8f3fbecd17b601);
    
    proof[4] = bytes32(0x602ea1a3a520819c4f02c388e68dfae8b9590b32a8532da8d01acc3487fb7fb0);
    
    proof[5] = bytes32(0x62835db99b3a73e4627b73609b414714289c1c9f82cf228af5bdf6deda2f985d);
    
    proof[6] = bytes32(0x7cd14aac96870a2af0a742db7dd2052f92a4bd34b8bdf16e9c1aebe42142d7fc);
    
    data["test-sweets-86-whitelisted-founder"].entries.push(MerkleEntry({
      user: 0x6d8C6e7815dA0CFF6bE2c152Bd4F89b9d05bc416,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](7);
    
    proof[0] = bytes32(0x80fcc7558d9440003facbc9524e6895fac8eb45c13e0454ed923646383916fd9);
    
    proof[1] = bytes32(0x3163ae92a74f23cb3e88b43d89da0c334de3c4165370f9dab7a55d0f4af62c2b);
    
    proof[2] = bytes32(0x6e8c6f8dd30bf3297e9f430ad59b3ee93f8021f9a33a7c591ed98bd5947a8291);
    
    proof[3] = bytes32(0x4ed1b75f279cb1d94517c150b203c9c00633b437462550a3aa8f3fbecd17b601);
    
    proof[4] = bytes32(0x602ea1a3a520819c4f02c388e68dfae8b9590b32a8532da8d01acc3487fb7fb0);
    
    proof[5] = bytes32(0x62835db99b3a73e4627b73609b414714289c1c9f82cf228af5bdf6deda2f985d);
    
    proof[6] = bytes32(0x7cd14aac96870a2af0a742db7dd2052f92a4bd34b8bdf16e9c1aebe42142d7fc);
    
    data["test-sweets-86-whitelisted-founder"].entries.push(MerkleEntry({
      user: 0x8b835e35838448a8A29Be15E926D99E9FB040822,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](7);
    
    proof[0] = bytes32(0xad94b62bd7c5a1a85792b5ca05600ddbba40531c8d04f1e1a4001950b125825d);
    
    proof[1] = bytes32(0x3163ae92a74f23cb3e88b43d89da0c334de3c4165370f9dab7a55d0f4af62c2b);
    
    proof[2] = bytes32(0x6e8c6f8dd30bf3297e9f430ad59b3ee93f8021f9a33a7c591ed98bd5947a8291);
    
    proof[3] = bytes32(0x4ed1b75f279cb1d94517c150b203c9c00633b437462550a3aa8f3fbecd17b601);
    
    proof[4] = bytes32(0x602ea1a3a520819c4f02c388e68dfae8b9590b32a8532da8d01acc3487fb7fb0);
    
    proof[5] = bytes32(0x62835db99b3a73e4627b73609b414714289c1c9f82cf228af5bdf6deda2f985d);
    
    proof[6] = bytes32(0x7cd14aac96870a2af0a742db7dd2052f92a4bd34b8bdf16e9c1aebe42142d7fc);
    
    data["test-sweets-86-whitelisted-founder"].entries.push(MerkleEntry({
      user: 0x8cd32534e41A1aec03626c9680eCe89eeEB9e9b0,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](7);
    
    proof[0] = bytes32(0x2d604707d0d6e6b19d1d5459a8b8f7d9cc61d0eb80b232e4ae02cc60c0328c5a);
    
    proof[1] = bytes32(0x8ab8b951273e2ac0779c7dfa21c4f4a13309f13fb8f3135d1965e6f7b09f4bca);
    
    proof[2] = bytes32(0x6e8c6f8dd30bf3297e9f430ad59b3ee93f8021f9a33a7c591ed98bd5947a8291);
    
    proof[3] = bytes32(0x4ed1b75f279cb1d94517c150b203c9c00633b437462550a3aa8f3fbecd17b601);
    
    proof[4] = bytes32(0x602ea1a3a520819c4f02c388e68dfae8b9590b32a8532da8d01acc3487fb7fb0);
    
    proof[5] = bytes32(0x62835db99b3a73e4627b73609b414714289c1c9f82cf228af5bdf6deda2f985d);
    
    proof[6] = bytes32(0x7cd14aac96870a2af0a742db7dd2052f92a4bd34b8bdf16e9c1aebe42142d7fc);
    
    data["test-sweets-86-whitelisted-founder"].entries.push(MerkleEntry({
      user: 0x914D14e0394a8138C12F8817c063F465d1FDdf61,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](7);
    
    proof[0] = bytes32(0xde62112cf1fda006a245ef8129b6f201aedb9e3f59597a25e20c575b7bc83579);
    
    proof[1] = bytes32(0x8ab8b951273e2ac0779c7dfa21c4f4a13309f13fb8f3135d1965e6f7b09f4bca);
    
    proof[2] = bytes32(0x6e8c6f8dd30bf3297e9f430ad59b3ee93f8021f9a33a7c591ed98bd5947a8291);
    
    proof[3] = bytes32(0x4ed1b75f279cb1d94517c150b203c9c00633b437462550a3aa8f3fbecd17b601);
    
    proof[4] = bytes32(0x602ea1a3a520819c4f02c388e68dfae8b9590b32a8532da8d01acc3487fb7fb0);
    
    proof[5] = bytes32(0x62835db99b3a73e4627b73609b414714289c1c9f82cf228af5bdf6deda2f985d);
    
    proof[6] = bytes32(0x7cd14aac96870a2af0a742db7dd2052f92a4bd34b8bdf16e9c1aebe42142d7fc);
    
    data["test-sweets-86-whitelisted-founder"].entries.push(MerkleEntry({
      user: 0x959919178CEff4a7bf5A1EdC653e2Eb965709d97,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](7);
    
    proof[0] = bytes32(0x61c749bc78df90d76ef4025da114d547b9d95876fca32cb4439ff12295f81987);
    
    proof[1] = bytes32(0x1cfbb2453509aa2ced5d03f8cc2a3e841662ed82b06b282a553ebae35457fb6c);
    
    proof[2] = bytes32(0xffbc0eccfbf44b5a76e44863f0a7703cbaa8123cb11d35cdef02a4975a6b5ec3);
    
    proof[3] = bytes32(0xdb114174e3b0c12591d2e98f20126ca7ff6f7f12c97848ba5564b0299984051d);
    
    proof[4] = bytes32(0x602ea1a3a520819c4f02c388e68dfae8b9590b32a8532da8d01acc3487fb7fb0);
    
    proof[5] = bytes32(0x62835db99b3a73e4627b73609b414714289c1c9f82cf228af5bdf6deda2f985d);
    
    proof[6] = bytes32(0x7cd14aac96870a2af0a742db7dd2052f92a4bd34b8bdf16e9c1aebe42142d7fc);
    
    data["test-sweets-86-whitelisted-founder"].entries.push(MerkleEntry({
      user: 0x9933D503916c1CE8D629667EDc8De3a8149aa0C0,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](7);
    
    proof[0] = bytes32(0xff654d8342cfb0c95e6980a111a4be5e8a7a2e9623a48b98b056cd7e287f00fc);
    
    proof[1] = bytes32(0x1cfbb2453509aa2ced5d03f8cc2a3e841662ed82b06b282a553ebae35457fb6c);
    
    proof[2] = bytes32(0xffbc0eccfbf44b5a76e44863f0a7703cbaa8123cb11d35cdef02a4975a6b5ec3);
    
    proof[3] = bytes32(0xdb114174e3b0c12591d2e98f20126ca7ff6f7f12c97848ba5564b0299984051d);
    
    proof[4] = bytes32(0x602ea1a3a520819c4f02c388e68dfae8b9590b32a8532da8d01acc3487fb7fb0);
    
    proof[5] = bytes32(0x62835db99b3a73e4627b73609b414714289c1c9f82cf228af5bdf6deda2f985d);
    
    proof[6] = bytes32(0x7cd14aac96870a2af0a742db7dd2052f92a4bd34b8bdf16e9c1aebe42142d7fc);
    
    data["test-sweets-86-whitelisted-founder"].entries.push(MerkleEntry({
      user: 0x9aF4F5D600253Bb6DCE0bfeDB41f89e9B380b80B,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](7);
    
    proof[0] = bytes32(0x6bfbfb5e3909037613424ee175cb7424c50aff32e352e1318ebe593fd560c226);
    
    proof[1] = bytes32(0x4e823447bf38e8ec3e4629b88220e1729ef6a9b041490e9c28f36cb5be8bbe2f);
    
    proof[2] = bytes32(0xffbc0eccfbf44b5a76e44863f0a7703cbaa8123cb11d35cdef02a4975a6b5ec3);
    
    proof[3] = bytes32(0xdb114174e3b0c12591d2e98f20126ca7ff6f7f12c97848ba5564b0299984051d);
    
    proof[4] = bytes32(0x602ea1a3a520819c4f02c388e68dfae8b9590b32a8532da8d01acc3487fb7fb0);
    
    proof[5] = bytes32(0x62835db99b3a73e4627b73609b414714289c1c9f82cf228af5bdf6deda2f985d);
    
    proof[6] = bytes32(0x7cd14aac96870a2af0a742db7dd2052f92a4bd34b8bdf16e9c1aebe42142d7fc);
    
    data["test-sweets-86-whitelisted-founder"].entries.push(MerkleEntry({
      user: 0xDd34985900fbc5C2353C8f7Db923503A19918c1d,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](7);
    
    proof[0] = bytes32(0xc315f4b31b8917ec56f900c3694e4bc9ef187186be46eef857bb541bb6883f88);
    
    proof[1] = bytes32(0x4e823447bf38e8ec3e4629b88220e1729ef6a9b041490e9c28f36cb5be8bbe2f);
    
    proof[2] = bytes32(0xffbc0eccfbf44b5a76e44863f0a7703cbaa8123cb11d35cdef02a4975a6b5ec3);
    
    proof[3] = bytes32(0xdb114174e3b0c12591d2e98f20126ca7ff6f7f12c97848ba5564b0299984051d);
    
    proof[4] = bytes32(0x602ea1a3a520819c4f02c388e68dfae8b9590b32a8532da8d01acc3487fb7fb0);
    
    proof[5] = bytes32(0x62835db99b3a73e4627b73609b414714289c1c9f82cf228af5bdf6deda2f985d);
    
    proof[6] = bytes32(0x7cd14aac96870a2af0a742db7dd2052f92a4bd34b8bdf16e9c1aebe42142d7fc);
    
    data["test-sweets-86-whitelisted-founder"].entries.push(MerkleEntry({
      user: 0x06d92B5b6Ae4b53fffdC8654707DFC2821e3897C,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](7);
    
    proof[0] = bytes32(0x63c82737737733be3c57c3869e49746ee052a43700b4e5dc9c3104d51ca5b56c);
    
    proof[1] = bytes32(0x27604d306cb4bef551e880f4ca032c3083eb0ca94c13a6d6c686646394207a47);
    
    proof[2] = bytes32(0x19457aad979cf6a962bf3df155f9241e29897c9443e5c52c64d649ec52aeb74c);
    
    proof[3] = bytes32(0xdb114174e3b0c12591d2e98f20126ca7ff6f7f12c97848ba5564b0299984051d);
    
    proof[4] = bytes32(0x602ea1a3a520819c4f02c388e68dfae8b9590b32a8532da8d01acc3487fb7fb0);
    
    proof[5] = bytes32(0x62835db99b3a73e4627b73609b414714289c1c9f82cf228af5bdf6deda2f985d);
    
    proof[6] = bytes32(0x7cd14aac96870a2af0a742db7dd2052f92a4bd34b8bdf16e9c1aebe42142d7fc);
    
    data["test-sweets-86-whitelisted-founder"].entries.push(MerkleEntry({
      user: 0x0849370812C98EFC94aF4ce2516aeeE2636cEd7c,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](7);
    
    proof[0] = bytes32(0xed648629abad07adb2de7d772df300b9a974b89b1373b6f7359f4b6aa26695b4);
    
    proof[1] = bytes32(0x27604d306cb4bef551e880f4ca032c3083eb0ca94c13a6d6c686646394207a47);
    
    proof[2] = bytes32(0x19457aad979cf6a962bf3df155f9241e29897c9443e5c52c64d649ec52aeb74c);
    
    proof[3] = bytes32(0xdb114174e3b0c12591d2e98f20126ca7ff6f7f12c97848ba5564b0299984051d);
    
    proof[4] = bytes32(0x602ea1a3a520819c4f02c388e68dfae8b9590b32a8532da8d01acc3487fb7fb0);
    
    proof[5] = bytes32(0x62835db99b3a73e4627b73609b414714289c1c9f82cf228af5bdf6deda2f985d);
    
    proof[6] = bytes32(0x7cd14aac96870a2af0a742db7dd2052f92a4bd34b8bdf16e9c1aebe42142d7fc);
    
    data["test-sweets-86-whitelisted-founder"].entries.push(MerkleEntry({
      user: 0x135538daed6657644b7A90958183d760f508BA45,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](7);
    
    proof[0] = bytes32(0x40270ef3c57b4e18298a25bb1dcb73da31124502f74badc3a81675dc725ac1cb);
    
    proof[1] = bytes32(0x53498a6736f5a2d77b6ad23df485c9a05f0cd829d57bea59f62aa785c0016bec);
    
    proof[2] = bytes32(0x19457aad979cf6a962bf3df155f9241e29897c9443e5c52c64d649ec52aeb74c);
    
    proof[3] = bytes32(0xdb114174e3b0c12591d2e98f20126ca7ff6f7f12c97848ba5564b0299984051d);
    
    proof[4] = bytes32(0x602ea1a3a520819c4f02c388e68dfae8b9590b32a8532da8d01acc3487fb7fb0);
    
    proof[5] = bytes32(0x62835db99b3a73e4627b73609b414714289c1c9f82cf228af5bdf6deda2f985d);
    
    proof[6] = bytes32(0x7cd14aac96870a2af0a742db7dd2052f92a4bd34b8bdf16e9c1aebe42142d7fc);
    
    data["test-sweets-86-whitelisted-founder"].entries.push(MerkleEntry({
      user: 0x2aE7AC4D95e1bFe1172FAE1c8efe9097119216cF,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](7);
    
    proof[0] = bytes32(0x9c6b3597a35c24ea6e87715e885a9031ffeebaafed7e0e90299c1c18086669f1);
    
    proof[1] = bytes32(0x53498a6736f5a2d77b6ad23df485c9a05f0cd829d57bea59f62aa785c0016bec);
    
    proof[2] = bytes32(0x19457aad979cf6a962bf3df155f9241e29897c9443e5c52c64d649ec52aeb74c);
    
    proof[3] = bytes32(0xdb114174e3b0c12591d2e98f20126ca7ff6f7f12c97848ba5564b0299984051d);
    
    proof[4] = bytes32(0x602ea1a3a520819c4f02c388e68dfae8b9590b32a8532da8d01acc3487fb7fb0);
    
    proof[5] = bytes32(0x62835db99b3a73e4627b73609b414714289c1c9f82cf228af5bdf6deda2f985d);
    
    proof[6] = bytes32(0x7cd14aac96870a2af0a742db7dd2052f92a4bd34b8bdf16e9c1aebe42142d7fc);
    
    data["test-sweets-86-whitelisted-founder"].entries.push(MerkleEntry({
      user: 0x3188973471200Df1dA427c20D8f1eBD48AC70B3c,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](7);
    
    proof[0] = bytes32(0x32220baee611cdae4f3c22540296c322d7f8468ece8d835d08d537bc3eb1c5ad);
    
    proof[1] = bytes32(0xc78cac4fdb5ba53a937afcddfbf43134e1d900caaddfcecb4bbbd7391470eb22);
    
    proof[2] = bytes32(0x4a607bd9bffb7bb5f08a12b84ec8b2af1578a78c3ce38d09825dc3c744b1b7ce);
    
    proof[3] = bytes32(0x0f64a2bc8a72cfd0c48b00edefba2771045b88c89a753f4c986d0f8bd6a0b5fb);
    
    proof[4] = bytes32(0x0d46c86612dc9c12dc8c97eed77441d09956d7426d2f7d8b4dfbcb3974b065fa);
    
    proof[5] = bytes32(0x62835db99b3a73e4627b73609b414714289c1c9f82cf228af5bdf6deda2f985d);
    
    proof[6] = bytes32(0x7cd14aac96870a2af0a742db7dd2052f92a4bd34b8bdf16e9c1aebe42142d7fc);
    
    data["test-sweets-86-whitelisted-founder"].entries.push(MerkleEntry({
      user: 0x39A416a1184DE3C438E6987eBBd05cb0D5699B44,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](7);
    
    proof[0] = bytes32(0x46afaa4c98945040f897eb5af0160caf4d5b4c95945016a9423000c252c929d8);
    
    proof[1] = bytes32(0xc78cac4fdb5ba53a937afcddfbf43134e1d900caaddfcecb4bbbd7391470eb22);
    
    proof[2] = bytes32(0x4a607bd9bffb7bb5f08a12b84ec8b2af1578a78c3ce38d09825dc3c744b1b7ce);
    
    proof[3] = bytes32(0x0f64a2bc8a72cfd0c48b00edefba2771045b88c89a753f4c986d0f8bd6a0b5fb);
    
    proof[4] = bytes32(0x0d46c86612dc9c12dc8c97eed77441d09956d7426d2f7d8b4dfbcb3974b065fa);
    
    proof[5] = bytes32(0x62835db99b3a73e4627b73609b414714289c1c9f82cf228af5bdf6deda2f985d);
    
    proof[6] = bytes32(0x7cd14aac96870a2af0a742db7dd2052f92a4bd34b8bdf16e9c1aebe42142d7fc);
    
    data["test-sweets-86-whitelisted-founder"].entries.push(MerkleEntry({
      user: 0x47fCc623926d1e0df091e7D16A59abd3C93de08e,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](7);
    
    proof[0] = bytes32(0x4d8d90fcb22fe13b1031b32ccaf26675e90a1b297b9332354ad30c46111ca097);
    
    proof[1] = bytes32(0xdd913cb1cb12678a318c2331fe85d9ff3d5d52d3d826f118d0db73fd41e30054);
    
    proof[2] = bytes32(0x4a607bd9bffb7bb5f08a12b84ec8b2af1578a78c3ce38d09825dc3c744b1b7ce);
    
    proof[3] = bytes32(0x0f64a2bc8a72cfd0c48b00edefba2771045b88c89a753f4c986d0f8bd6a0b5fb);
    
    proof[4] = bytes32(0x0d46c86612dc9c12dc8c97eed77441d09956d7426d2f7d8b4dfbcb3974b065fa);
    
    proof[5] = bytes32(0x62835db99b3a73e4627b73609b414714289c1c9f82cf228af5bdf6deda2f985d);
    
    proof[6] = bytes32(0x7cd14aac96870a2af0a742db7dd2052f92a4bd34b8bdf16e9c1aebe42142d7fc);
    
    data["test-sweets-86-whitelisted-founder"].entries.push(MerkleEntry({
      user: 0x6EAC18bb705C845aCe004ac19a87521bfdCA2dc6,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](7);
    
    proof[0] = bytes32(0xd91f3c014f4a633fbb862827248620d6a0def9e5e0fb35b0dae1a1203ec504fd);
    
    proof[1] = bytes32(0xdd913cb1cb12678a318c2331fe85d9ff3d5d52d3d826f118d0db73fd41e30054);
    
    proof[2] = bytes32(0x4a607bd9bffb7bb5f08a12b84ec8b2af1578a78c3ce38d09825dc3c744b1b7ce);
    
    proof[3] = bytes32(0x0f64a2bc8a72cfd0c48b00edefba2771045b88c89a753f4c986d0f8bd6a0b5fb);
    
    proof[4] = bytes32(0x0d46c86612dc9c12dc8c97eed77441d09956d7426d2f7d8b4dfbcb3974b065fa);
    
    proof[5] = bytes32(0x62835db99b3a73e4627b73609b414714289c1c9f82cf228af5bdf6deda2f985d);
    
    proof[6] = bytes32(0x7cd14aac96870a2af0a742db7dd2052f92a4bd34b8bdf16e9c1aebe42142d7fc);
    
    data["test-sweets-86-whitelisted-founder"].entries.push(MerkleEntry({
      user: 0x7a137E2D8B77709aE76E28f7b19F493FF24eaFd5,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](0);
    
    data["test-sweets-86-whitelisted-founder"].entries.push(MerkleEntry({
      user: 0x7Bfe963C7b6C653889C83e833AD59487147aA9F3,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](7);
    
    proof[0] = bytes32(0x0b65ea81e181d80c8dd726b29af89aab75cdefe5d3eeb34534d31bcb3213c797);
    
    proof[1] = bytes32(0x9d79b8e269726b64c3e40b6a5fa9dc74835a7edcbf5406f1e11e9b0f1b2f7812);
    
    proof[2] = bytes32(0xd8da0ae6a6b3197c3a60e668e6b9aa31c04650116f77589c6808b4e74618bb9a);
    
    proof[3] = bytes32(0x0f64a2bc8a72cfd0c48b00edefba2771045b88c89a753f4c986d0f8bd6a0b5fb);
    
    proof[4] = bytes32(0x0d46c86612dc9c12dc8c97eed77441d09956d7426d2f7d8b4dfbcb3974b065fa);
    
    proof[5] = bytes32(0x62835db99b3a73e4627b73609b414714289c1c9f82cf228af5bdf6deda2f985d);
    
    proof[6] = bytes32(0x7cd14aac96870a2af0a742db7dd2052f92a4bd34b8bdf16e9c1aebe42142d7fc);
    
    data["test-sweets-86-whitelisted-founder"].entries.push(MerkleEntry({
      user: 0x8D0F88CC0f08e6d21B0cf7c3aCc90e8d280fCCCE,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](7);
    
    proof[0] = bytes32(0x70b136e390e1e4bc4e5597bcaaa85f38ca9f91090a4a9f046ddcb5fd3de33bd9);
    
    proof[1] = bytes32(0xb8c61e2ba33735fc0a9f7cbaf26cf90471ebcce7eedebbdc35dafb8099807f55);
    
    proof[2] = bytes32(0xd8da0ae6a6b3197c3a60e668e6b9aa31c04650116f77589c6808b4e74618bb9a);
    
    proof[3] = bytes32(0x0f64a2bc8a72cfd0c48b00edefba2771045b88c89a753f4c986d0f8bd6a0b5fb);
    
    proof[4] = bytes32(0x0d46c86612dc9c12dc8c97eed77441d09956d7426d2f7d8b4dfbcb3974b065fa);
    
    proof[5] = bytes32(0x62835db99b3a73e4627b73609b414714289c1c9f82cf228af5bdf6deda2f985d);
    
    proof[6] = bytes32(0x7cd14aac96870a2af0a742db7dd2052f92a4bd34b8bdf16e9c1aebe42142d7fc);
    
    data["test-sweets-86-whitelisted-founder"].entries.push(MerkleEntry({
      user: 0xa3F9718409aE2E9c54B889BeBC3a6B2d321BFd86,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](7);
    
    proof[0] = bytes32(0xd6109c62cc4a2480a52416294b4c50761ecdc5beda0742477a05bd502a45e7be);
    
    proof[1] = bytes32(0xb8c61e2ba33735fc0a9f7cbaf26cf90471ebcce7eedebbdc35dafb8099807f55);
    
    proof[2] = bytes32(0xd8da0ae6a6b3197c3a60e668e6b9aa31c04650116f77589c6808b4e74618bb9a);
    
    proof[3] = bytes32(0x0f64a2bc8a72cfd0c48b00edefba2771045b88c89a753f4c986d0f8bd6a0b5fb);
    
    proof[4] = bytes32(0x0d46c86612dc9c12dc8c97eed77441d09956d7426d2f7d8b4dfbcb3974b065fa);
    
    proof[5] = bytes32(0x62835db99b3a73e4627b73609b414714289c1c9f82cf228af5bdf6deda2f985d);
    
    proof[6] = bytes32(0x7cd14aac96870a2af0a742db7dd2052f92a4bd34b8bdf16e9c1aebe42142d7fc);
    
    data["test-sweets-86-whitelisted-founder"].entries.push(MerkleEntry({
      user: 0xa88Fe6fA01FCC112BB2164c6e37d63395B923E5F,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](0);
    
    data["test-sweets-86-whitelisted-founder"].entries.push(MerkleEntry({
      user: 0xc3bFBa9c3D4B07ca6B909aE491fDa9CDa7F7D732,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](7);
    
    proof[0] = bytes32(0x083ea2df74e22cb310ff1c9ae9c69e81b797cf1c5b462c0f57e5dcfd2250cc29);
    
    proof[1] = bytes32(0xd6c5c16fe3fcfd379b86d0a196c0a5eb561f24aebabefe7d738e694644aaa934);
    
    proof[2] = bytes32(0xdf1a6cf52c0a0b565f6f25937c06427de441fc28f7ea4b6a51603a0fda3af9c5);
    
    proof[3] = bytes32(0x322d2baf3626333eec19c87ffcc6e452f749ce40f76f313359462f090147b909);
    
    proof[4] = bytes32(0x0d46c86612dc9c12dc8c97eed77441d09956d7426d2f7d8b4dfbcb3974b065fa);
    
    proof[5] = bytes32(0x62835db99b3a73e4627b73609b414714289c1c9f82cf228af5bdf6deda2f985d);
    
    proof[6] = bytes32(0x7cd14aac96870a2af0a742db7dd2052f92a4bd34b8bdf16e9c1aebe42142d7fc);
    
    data["test-sweets-86-whitelisted-founder"].entries.push(MerkleEntry({
      user: 0xc8113bFd005B4c2De35212eA750357002868548f,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](7);
    
    proof[0] = bytes32(0xb3975513452bdf6bc590468cd2d4e1c9fee55e9f3f0ffec99859c9e8ae94af6f);
    
    proof[1] = bytes32(0x1a7ae43bb01675dfbf7216d9a081c2f911c24a88fd859955eb491a2193f874ec);
    
    proof[2] = bytes32(0xdf1a6cf52c0a0b565f6f25937c06427de441fc28f7ea4b6a51603a0fda3af9c5);
    
    proof[3] = bytes32(0x322d2baf3626333eec19c87ffcc6e452f749ce40f76f313359462f090147b909);
    
    proof[4] = bytes32(0x0d46c86612dc9c12dc8c97eed77441d09956d7426d2f7d8b4dfbcb3974b065fa);
    
    proof[5] = bytes32(0x62835db99b3a73e4627b73609b414714289c1c9f82cf228af5bdf6deda2f985d);
    
    proof[6] = bytes32(0x7cd14aac96870a2af0a742db7dd2052f92a4bd34b8bdf16e9c1aebe42142d7fc);
    
    data["test-sweets-86-whitelisted-founder"].entries.push(MerkleEntry({
      user: 0xcd28cc2cafc7449c21D8D94c676A630b7Bbb9522,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](7);
    
    proof[0] = bytes32(0xf89ddd8b1688b3f40f576f25b3e9fcbacbdb99890cec54b1779b17987d139666);
    
    proof[1] = bytes32(0x1a7ae43bb01675dfbf7216d9a081c2f911c24a88fd859955eb491a2193f874ec);
    
    proof[2] = bytes32(0xdf1a6cf52c0a0b565f6f25937c06427de441fc28f7ea4b6a51603a0fda3af9c5);
    
    proof[3] = bytes32(0x322d2baf3626333eec19c87ffcc6e452f749ce40f76f313359462f090147b909);
    
    proof[4] = bytes32(0x0d46c86612dc9c12dc8c97eed77441d09956d7426d2f7d8b4dfbcb3974b065fa);
    
    proof[5] = bytes32(0x62835db99b3a73e4627b73609b414714289c1c9f82cf228af5bdf6deda2f985d);
    
    proof[6] = bytes32(0x7cd14aac96870a2af0a742db7dd2052f92a4bd34b8bdf16e9c1aebe42142d7fc);
    
    data["test-sweets-86-whitelisted-founder"].entries.push(MerkleEntry({
      user: 0xCf3BB7Ec4778eAf6214cd5Ea958A355D2Ec095f1,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](7);
    
    proof[0] = bytes32(0x7c4cff290722b8cf9b10e52e5f2391dd996a3342971829e03f3e6ce1fbd126ba);
    
    proof[1] = bytes32(0xeb2b9eda08214013c2b98ff5c7329d56ce8d4465d236227fd035c8633a9c68e5);
    
    proof[2] = bytes32(0xbb9848e19f447effc36b6425fc4289d1928a96930fef3582d1c7de40b0bfb6e8);
    
    proof[3] = bytes32(0x322d2baf3626333eec19c87ffcc6e452f749ce40f76f313359462f090147b909);
    
    proof[4] = bytes32(0x0d46c86612dc9c12dc8c97eed77441d09956d7426d2f7d8b4dfbcb3974b065fa);
    
    proof[5] = bytes32(0x62835db99b3a73e4627b73609b414714289c1c9f82cf228af5bdf6deda2f985d);
    
    proof[6] = bytes32(0x7cd14aac96870a2af0a742db7dd2052f92a4bd34b8bdf16e9c1aebe42142d7fc);
    
    data["test-sweets-86-whitelisted-founder"].entries.push(MerkleEntry({
      user: 0xEBcCb8027e4cBBeca4147d8C5a29DddEcD62C6A2,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](7);
    
    proof[0] = bytes32(0x1b342913fb20ad19f8b468873f767e361a9629326a47f0fd711d42bdf39f19a7);
    
    proof[1] = bytes32(0xeb2b9eda08214013c2b98ff5c7329d56ce8d4465d236227fd035c8633a9c68e5);
    
    proof[2] = bytes32(0xbb9848e19f447effc36b6425fc4289d1928a96930fef3582d1c7de40b0bfb6e8);
    
    proof[3] = bytes32(0x322d2baf3626333eec19c87ffcc6e452f749ce40f76f313359462f090147b909);
    
    proof[4] = bytes32(0x0d46c86612dc9c12dc8c97eed77441d09956d7426d2f7d8b4dfbcb3974b065fa);
    
    proof[5] = bytes32(0x62835db99b3a73e4627b73609b414714289c1c9f82cf228af5bdf6deda2f985d);
    
    proof[6] = bytes32(0x7cd14aac96870a2af0a742db7dd2052f92a4bd34b8bdf16e9c1aebe42142d7fc);
    
    data["test-sweets-86-whitelisted-founder"].entries.push(MerkleEntry({
      user: 0xecCE1ffa735Ff743DcFa9f0A1E14D6e38D28bed2,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](7);
    
    proof[0] = bytes32(0x7399894a17dc1f16209f2d0c19cd4df11fca67e6466fa34544ed9f98ae62113c);
    
    proof[1] = bytes32(0xd33b6e76e6048fa98b354a821d96ca363263f6fc109831debe4aa07040a64d3f);
    
    proof[2] = bytes32(0xbb9848e19f447effc36b6425fc4289d1928a96930fef3582d1c7de40b0bfb6e8);
    
    proof[3] = bytes32(0x322d2baf3626333eec19c87ffcc6e452f749ce40f76f313359462f090147b909);
    
    proof[4] = bytes32(0x0d46c86612dc9c12dc8c97eed77441d09956d7426d2f7d8b4dfbcb3974b065fa);
    
    proof[5] = bytes32(0x62835db99b3a73e4627b73609b414714289c1c9f82cf228af5bdf6deda2f985d);
    
    proof[6] = bytes32(0x7cd14aac96870a2af0a742db7dd2052f92a4bd34b8bdf16e9c1aebe42142d7fc);
    
    data["test-sweets-86-whitelisted-founder"].entries.push(MerkleEntry({
      user: 0xa9334f7750E398Ed7624D828EC584467D87dc3b0,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](7);
    
    proof[0] = bytes32(0x7ad235e6c3dc486a241e2b9644338b04893af79c0bb0f1c01d036784ad821075);
    
    proof[1] = bytes32(0xd33b6e76e6048fa98b354a821d96ca363263f6fc109831debe4aa07040a64d3f);
    
    proof[2] = bytes32(0xbb9848e19f447effc36b6425fc4289d1928a96930fef3582d1c7de40b0bfb6e8);
    
    proof[3] = bytes32(0x322d2baf3626333eec19c87ffcc6e452f749ce40f76f313359462f090147b909);
    
    proof[4] = bytes32(0x0d46c86612dc9c12dc8c97eed77441d09956d7426d2f7d8b4dfbcb3974b065fa);
    
    proof[5] = bytes32(0x62835db99b3a73e4627b73609b414714289c1c9f82cf228af5bdf6deda2f985d);
    
    proof[6] = bytes32(0x7cd14aac96870a2af0a742db7dd2052f92a4bd34b8bdf16e9c1aebe42142d7fc);
    
    data["test-sweets-86-whitelisted-founder"].entries.push(MerkleEntry({
      user: 0x0BED69761B7F28322D5ec8C7455de22f9Ed5e7E7,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](6);
    
    proof[0] = bytes32(0x0145ab63a974bd4e0b44f5135dcc6a87ada999f96adcf2973f4f64d1861e0b16);
    
    proof[1] = bytes32(0xe80340d793e9d7d9784bb57a9ceb5ac560c18ec53e6042e53a524f6f26a75e55);
    
    proof[2] = bytes32(0xc7b0715253b137d9e420243d517a20f97fe608a901681a560e232cdfac350f15);
    
    proof[3] = bytes32(0xea475fc68abba54dec807f74833fb73c304c48400a3a8947f60fdb52e7112706);
    
    proof[4] = bytes32(0xbdd3df21fb290ffa2d9dac1e0a4fe47b118f78377490d347cc7e43df8f4637b6);
    
    proof[5] = bytes32(0xd3477b360847f396e242886c8c676563dc81c29ba62cc6aa67e57569d066c046);
    
    data["test-sweets-86-whitelisted-founder"].entries.push(MerkleEntry({
      user: 0x1593c5e4183a7628CFa8155F2f3771Fbd74DD249,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](0);
    
    data["test-sweets-86-whitelisted-founder"].entries.push(MerkleEntry({
      user: 0x1f562c3259b5266a1a934a4d20d22b7135D3600d,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](6);
    
    proof[0] = bytes32(0x16a80135c4edc746e0175ba5a39a8f7ea0a6c075754c5e5495ea3d6594440d10);
    
    proof[1] = bytes32(0xb0f76c4a91a130e862b708545c6d45154179e8ce4c04f5dd420c3f1afb4c774e);
    
    proof[2] = bytes32(0xc7b0715253b137d9e420243d517a20f97fe608a901681a560e232cdfac350f15);
    
    proof[3] = bytes32(0xea475fc68abba54dec807f74833fb73c304c48400a3a8947f60fdb52e7112706);
    
    proof[4] = bytes32(0xbdd3df21fb290ffa2d9dac1e0a4fe47b118f78377490d347cc7e43df8f4637b6);
    
    proof[5] = bytes32(0xd3477b360847f396e242886c8c676563dc81c29ba62cc6aa67e57569d066c046);
    
    data["test-sweets-86-whitelisted-founder"].entries.push(MerkleEntry({
      user: 0x24Fc7b0DAFbD998856Cfc35CbEac9aeEb53e72cb,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](6);
    
    proof[0] = bytes32(0xb95e366ef4968873268e3f36f1dfdc88bb45a92d456207cc37b6d30d3a84f958);
    
    proof[1] = bytes32(0xb0f76c4a91a130e862b708545c6d45154179e8ce4c04f5dd420c3f1afb4c774e);
    
    proof[2] = bytes32(0xc7b0715253b137d9e420243d517a20f97fe608a901681a560e232cdfac350f15);
    
    proof[3] = bytes32(0xea475fc68abba54dec807f74833fb73c304c48400a3a8947f60fdb52e7112706);
    
    proof[4] = bytes32(0xbdd3df21fb290ffa2d9dac1e0a4fe47b118f78377490d347cc7e43df8f4637b6);
    
    proof[5] = bytes32(0xd3477b360847f396e242886c8c676563dc81c29ba62cc6aa67e57569d066c046);
    
    data["test-sweets-86-whitelisted-founder"].entries.push(MerkleEntry({
      user: 0x43a66Af60EBf2E445F12D303fE93ff6F2c8cc102,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](6);
    
    proof[0] = bytes32(0x90bbab04c157ffc3cb23526b0e9afb0d0ab1a531241ab02db33eb6076ce15667);
    
    proof[1] = bytes32(0x0f11eb3b3745e059f214ea1d2640847c9b1271ce7adc96d68f0c8f82da07a78f);
    
    proof[2] = bytes32(0x0a12c3a79b3eb2f192515c9694e1c5c32ae9c8788cabb422b6ed8ac5cbfff649);
    
    proof[3] = bytes32(0xea475fc68abba54dec807f74833fb73c304c48400a3a8947f60fdb52e7112706);
    
    proof[4] = bytes32(0xbdd3df21fb290ffa2d9dac1e0a4fe47b118f78377490d347cc7e43df8f4637b6);
    
    proof[5] = bytes32(0xd3477b360847f396e242886c8c676563dc81c29ba62cc6aa67e57569d066c046);
    
    data["test-sweets-86-whitelisted-founder"].entries.push(MerkleEntry({
      user: 0x5A48A0b76693ccAeDdB277bB44E2eb2Dc672BD38,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](6);
    
    proof[0] = bytes32(0xb9c02ab361ea3ccc2c5e48fa5c6d68e61925b62e685b6718e99e93689feeabbd);
    
    proof[1] = bytes32(0x0f11eb3b3745e059f214ea1d2640847c9b1271ce7adc96d68f0c8f82da07a78f);
    
    proof[2] = bytes32(0x0a12c3a79b3eb2f192515c9694e1c5c32ae9c8788cabb422b6ed8ac5cbfff649);
    
    proof[3] = bytes32(0xea475fc68abba54dec807f74833fb73c304c48400a3a8947f60fdb52e7112706);
    
    proof[4] = bytes32(0xbdd3df21fb290ffa2d9dac1e0a4fe47b118f78377490d347cc7e43df8f4637b6);
    
    proof[5] = bytes32(0xd3477b360847f396e242886c8c676563dc81c29ba62cc6aa67e57569d066c046);
    
    data["test-sweets-86-whitelisted-founder"].entries.push(MerkleEntry({
      user: 0x61083772b5B10b6214C91db6AD625eCb24A60834,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](6);
    
    proof[0] = bytes32(0x27817e926aab550c9dc7e58cdda5856c684d160bb4f2ee69808f078e8235111b);
    
    proof[1] = bytes32(0x0761492164ece02f5e8bfc2711cfc05d96de0326e3325f94c22b5f47d747bf21);
    
    proof[2] = bytes32(0x0a12c3a79b3eb2f192515c9694e1c5c32ae9c8788cabb422b6ed8ac5cbfff649);
    
    proof[3] = bytes32(0xea475fc68abba54dec807f74833fb73c304c48400a3a8947f60fdb52e7112706);
    
    proof[4] = bytes32(0xbdd3df21fb290ffa2d9dac1e0a4fe47b118f78377490d347cc7e43df8f4637b6);
    
    proof[5] = bytes32(0xd3477b360847f396e242886c8c676563dc81c29ba62cc6aa67e57569d066c046);
    
    data["test-sweets-86-whitelisted-founder"].entries.push(MerkleEntry({
      user: 0x62cfC308dC5DF36A417427eB0a2e61eE9AbFebbe,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](6);
    
    proof[0] = bytes32(0xf703d3046ccea78b8aa67d564478bdc2c1af5e04b4485439da89d64802aab3e7);
    
    proof[1] = bytes32(0x0761492164ece02f5e8bfc2711cfc05d96de0326e3325f94c22b5f47d747bf21);
    
    proof[2] = bytes32(0x0a12c3a79b3eb2f192515c9694e1c5c32ae9c8788cabb422b6ed8ac5cbfff649);
    
    proof[3] = bytes32(0xea475fc68abba54dec807f74833fb73c304c48400a3a8947f60fdb52e7112706);
    
    proof[4] = bytes32(0xbdd3df21fb290ffa2d9dac1e0a4fe47b118f78377490d347cc7e43df8f4637b6);
    
    proof[5] = bytes32(0xd3477b360847f396e242886c8c676563dc81c29ba62cc6aa67e57569d066c046);
    
    data["test-sweets-86-whitelisted-founder"].entries.push(MerkleEntry({
      user: 0x77DE23D1D24eD19E5bD7f112008f423ec199fd1d,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](6);
    
    proof[0] = bytes32(0xb8f60555182f3cfbaac8a7618f61b02de832deb1703d4462bc3d5bb1445f4d3c);
    
    proof[1] = bytes32(0x8f39791da0d2d7d9f7d4beaffe2fcef5213932190c4aeb77726f5951a7eee5dd);
    
    proof[2] = bytes32(0x330e769b576a539371b1fcce52a571c8ae469e19a3708e49de712c4ffe1a199a);
    
    proof[3] = bytes32(0x3bb32aaeac067bfc6175ca5cfc76c485c5f91fd6ad774e03b0287f30995e48ce);
    
    proof[4] = bytes32(0xbdd3df21fb290ffa2d9dac1e0a4fe47b118f78377490d347cc7e43df8f4637b6);
    
    proof[5] = bytes32(0xd3477b360847f396e242886c8c676563dc81c29ba62cc6aa67e57569d066c046);
    
    data["test-sweets-86-whitelisted-founder"].entries.push(MerkleEntry({
      user: 0x7F9Efc77234dD34328b764d68606De972E24a510,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](6);
    
    proof[0] = bytes32(0xd0bd9fe2001748838e98edd717de870300cd852305c13f9f3c5358fae35d359b);
    
    proof[1] = bytes32(0x8f39791da0d2d7d9f7d4beaffe2fcef5213932190c4aeb77726f5951a7eee5dd);
    
    proof[2] = bytes32(0x330e769b576a539371b1fcce52a571c8ae469e19a3708e49de712c4ffe1a199a);
    
    proof[3] = bytes32(0x3bb32aaeac067bfc6175ca5cfc76c485c5f91fd6ad774e03b0287f30995e48ce);
    
    proof[4] = bytes32(0xbdd3df21fb290ffa2d9dac1e0a4fe47b118f78377490d347cc7e43df8f4637b6);
    
    proof[5] = bytes32(0xd3477b360847f396e242886c8c676563dc81c29ba62cc6aa67e57569d066c046);
    
    data["test-sweets-86-whitelisted-founder"].entries.push(MerkleEntry({
      user: 0x80fB7c29233e824a244c9E7e96feEbc671aB03D7,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](6);
    
    proof[0] = bytes32(0xca14c17c3ea595932f0aece726c16c0eeec2c637d7e4394f42cd5c1b54fe9e1a);
    
    proof[1] = bytes32(0xf8d6af107412c7352de43f6afde6748a6b5582d5419a548f14ae199f9f700d6c);
    
    proof[2] = bytes32(0x330e769b576a539371b1fcce52a571c8ae469e19a3708e49de712c4ffe1a199a);
    
    proof[3] = bytes32(0x3bb32aaeac067bfc6175ca5cfc76c485c5f91fd6ad774e03b0287f30995e48ce);
    
    proof[4] = bytes32(0xbdd3df21fb290ffa2d9dac1e0a4fe47b118f78377490d347cc7e43df8f4637b6);
    
    proof[5] = bytes32(0xd3477b360847f396e242886c8c676563dc81c29ba62cc6aa67e57569d066c046);
    
    data["test-sweets-86-whitelisted-founder"].entries.push(MerkleEntry({
      user: 0x8b7D12B2Aed991eF314CAff9a68228eA6aDf1C65,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](6);
    
    proof[0] = bytes32(0xffa9a616b159e438d50b464e86f663a5c58d7bffb8b0bad0290ed9254e080a55);
    
    proof[1] = bytes32(0xf8d6af107412c7352de43f6afde6748a6b5582d5419a548f14ae199f9f700d6c);
    
    proof[2] = bytes32(0x330e769b576a539371b1fcce52a571c8ae469e19a3708e49de712c4ffe1a199a);
    
    proof[3] = bytes32(0x3bb32aaeac067bfc6175ca5cfc76c485c5f91fd6ad774e03b0287f30995e48ce);
    
    proof[4] = bytes32(0xbdd3df21fb290ffa2d9dac1e0a4fe47b118f78377490d347cc7e43df8f4637b6);
    
    proof[5] = bytes32(0xd3477b360847f396e242886c8c676563dc81c29ba62cc6aa67e57569d066c046);
    
    data["test-sweets-86-whitelisted-founder"].entries.push(MerkleEntry({
      user: 0xA2A983f5ddB82Fd04f6df101043787Fd1a04322F,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](0);
    
    data["test-sweets-86-whitelisted-founder"].entries.push(MerkleEntry({
      user: 0xaA2bA5C877B70BAc69763917d3657CA22D1C1CEA,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](6);
    
    proof[0] = bytes32(0x0afaed35b7c832724a7b100784f85cf7755eece45fd7661657daa86ee7f79235);
    
    proof[1] = bytes32(0x0dab2192ac5ed456f89f99382a8c045202691914d74f6469b7cfb48937beed0f);
    
    proof[2] = bytes32(0xcc40734ebde94e3c7a5c8ea789c063dcf2e0a8f926e306df0eee948f38124f5b);
    
    proof[3] = bytes32(0x3bb32aaeac067bfc6175ca5cfc76c485c5f91fd6ad774e03b0287f30995e48ce);
    
    proof[4] = bytes32(0xbdd3df21fb290ffa2d9dac1e0a4fe47b118f78377490d347cc7e43df8f4637b6);
    
    proof[5] = bytes32(0xd3477b360847f396e242886c8c676563dc81c29ba62cc6aa67e57569d066c046);
    
    data["test-sweets-86-whitelisted-founder"].entries.push(MerkleEntry({
      user: 0xB0af55D6f513048cB554ee7DD3343f71a90b19Cc,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](6);
    
    proof[0] = bytes32(0x30486fffbbd74840161b1d90cb376d0a1bfa96334a191511505d811ce13f91b1);
    
    proof[1] = bytes32(0x9f3323c0ca424497d3a91fbb4130b55364f79ecbd128443f41330a72714a0c38);
    
    proof[2] = bytes32(0xcc40734ebde94e3c7a5c8ea789c063dcf2e0a8f926e306df0eee948f38124f5b);
    
    proof[3] = bytes32(0x3bb32aaeac067bfc6175ca5cfc76c485c5f91fd6ad774e03b0287f30995e48ce);
    
    proof[4] = bytes32(0xbdd3df21fb290ffa2d9dac1e0a4fe47b118f78377490d347cc7e43df8f4637b6);
    
    proof[5] = bytes32(0xd3477b360847f396e242886c8c676563dc81c29ba62cc6aa67e57569d066c046);
    
    data["test-sweets-86-whitelisted-founder"].entries.push(MerkleEntry({
      user: 0xb0b9C8E79651D94b76129760C93A8F91026A9DDd,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](6);
    
    proof[0] = bytes32(0xac32f1ab7baad97f6b065551bb38718f26b6e35a24f7712f36b12ce58201ef78);
    
    proof[1] = bytes32(0x9f3323c0ca424497d3a91fbb4130b55364f79ecbd128443f41330a72714a0c38);
    
    proof[2] = bytes32(0xcc40734ebde94e3c7a5c8ea789c063dcf2e0a8f926e306df0eee948f38124f5b);
    
    proof[3] = bytes32(0x3bb32aaeac067bfc6175ca5cfc76c485c5f91fd6ad774e03b0287f30995e48ce);
    
    proof[4] = bytes32(0xbdd3df21fb290ffa2d9dac1e0a4fe47b118f78377490d347cc7e43df8f4637b6);
    
    proof[5] = bytes32(0xd3477b360847f396e242886c8c676563dc81c29ba62cc6aa67e57569d066c046);
    
    data["test-sweets-86-whitelisted-founder"].entries.push(MerkleEntry({
      user: 0xB37FCa6f0AE248ADB466096d06D15b826D07EBD7,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](5);
    
    proof[0] = bytes32(0x0892c964cd885b1940a602e2bf7849a93444c3cc5a99b8c3bb982db03a5b4527);
    
    proof[1] = bytes32(0xa57ce89930008cc64f1a7b95f2f36fd209653c5340d0bf8ca5c9975bcfd3040b);
    
    proof[2] = bytes32(0x5a0e0c98c364741f6ed6defac25dc91173e952df1c9427c9480068e13cc0b802);
    
    proof[3] = bytes32(0xb4ea9b80989fc18b7657c91cf333dcf6e8ca37ac755216ea63fc99928941cb68);
    
    proof[4] = bytes32(0xd3477b360847f396e242886c8c676563dc81c29ba62cc6aa67e57569d066c046);
    
    data["test-sweets-86-whitelisted-founder"].entries.push(MerkleEntry({
      user: 0xb68f14521e129D469B172064Fd4f3C0fC46A1644,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](0);
    
    data["test-sweets-86-whitelisted-founder"].entries.push(MerkleEntry({
      user: 0xbA781Db2a3Ea4D31d9F75a79722D17262D44Aabd,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](5);
    
    proof[0] = bytes32(0x42a6012d77c217bd446836ff8e3f0fa142ec8ce42613a1df2413046682f40817);
    
    proof[1] = bytes32(0xf38658a36467b41fb9bcabd03a01d1f8727b57caecdeea65d9253cb740f49f78);
    
    proof[2] = bytes32(0x5a0e0c98c364741f6ed6defac25dc91173e952df1c9427c9480068e13cc0b802);
    
    proof[3] = bytes32(0xb4ea9b80989fc18b7657c91cf333dcf6e8ca37ac755216ea63fc99928941cb68);
    
    proof[4] = bytes32(0xd3477b360847f396e242886c8c676563dc81c29ba62cc6aa67e57569d066c046);
    
    data["test-sweets-86-whitelisted-founder"].entries.push(MerkleEntry({
      user: 0xcbd38467F5811d91a053Cbf63853162c66bF57e6,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](5);
    
    proof[0] = bytes32(0xde2ff2d899bd8f494bca7ad549f611f70681290235a86297b1ac151432240a8b);
    
    proof[1] = bytes32(0xf38658a36467b41fb9bcabd03a01d1f8727b57caecdeea65d9253cb740f49f78);
    
    proof[2] = bytes32(0x5a0e0c98c364741f6ed6defac25dc91173e952df1c9427c9480068e13cc0b802);
    
    proof[3] = bytes32(0xb4ea9b80989fc18b7657c91cf333dcf6e8ca37ac755216ea63fc99928941cb68);
    
    proof[4] = bytes32(0xd3477b360847f396e242886c8c676563dc81c29ba62cc6aa67e57569d066c046);
    
    data["test-sweets-86-whitelisted-founder"].entries.push(MerkleEntry({
      user: 0xdAc807E6B8a4B008643aBC8451339d17C5F06f82,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](5);
    
    proof[0] = bytes32(0x0e13c0f81920c13cbf6e1363c8bba69807379cb90dd8c81d6b009aa89defdb10);
    
    proof[1] = bytes32(0x682a2c8f714235bca22860f606d86db94df927cdf058933d3985e78719856209);
    
    proof[2] = bytes32(0xffc57ca69494e5e32727040d1147739ea8bd5afd0693c43b1f2544dc5a63a68e);
    
    proof[3] = bytes32(0xb4ea9b80989fc18b7657c91cf333dcf6e8ca37ac755216ea63fc99928941cb68);
    
    proof[4] = bytes32(0xd3477b360847f396e242886c8c676563dc81c29ba62cc6aa67e57569d066c046);
    
    data["test-sweets-86-whitelisted-founder"].entries.push(MerkleEntry({
      user: 0xdF7e66d0316F43cf45e74ABa199bbf368BB8EB0b,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](0);
    
    data["test-sweets-86-whitelisted-founder"].entries.push(MerkleEntry({
      user: 0xEbaFaCA1aa8D0C93692fE368fFC35Faa977Fd9d9,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    proof = new bytes32[](4);
    
    proof[0] = bytes32(0x68908b2e5bd4751c6db5f8edc0cc912474026f837525d380d5e0fff2ad9cc953);
    
    proof[1] = bytes32(0xffc57ca69494e5e32727040d1147739ea8bd5afd0693c43b1f2544dc5a63a68e);
    
    proof[2] = bytes32(0xb4ea9b80989fc18b7657c91cf333dcf6e8ca37ac755216ea63fc99928941cb68);
    
    proof[3] = bytes32(0xd3477b360847f396e242886c8c676563dc81c29ba62cc6aa67e57569d066c046);
    
    data["test-sweets-86-whitelisted-founder"].entries.push(MerkleEntry({
      user: 0xcfBf34d385EA2d5Eb947063b67eA226dcDA3DC38,
      maxMint: 1,
      mintPrice: 0,
      proof: proof 
    }));
    
    
    data["test-allowlist-minter"].root = 0x24a4a34bb550588f6285e9c174ef4eba4bc3c33d9db74e205164661f62bf3b51;
    
    proof = new bytes32[](2);
    
    proof[0] = bytes32(0x19d7ea1a7e50b32ed7fa8a0e686d91fd8c167520446d80f8369f53bbff563778);
    
    proof[1] = bytes32(0x95194401fca4ae15186d77ef940676709a15e10d74be56dd2504eb011dce0474);
    
    data["test-allowlist-minter"].entries.push(MerkleEntry({
      user: 0x0000000000000000000000000000000000000111,
      maxMint: 8,
      mintPrice: 150000000000000000,
      proof: proof 
    }));
    
    proof = new bytes32[](2);
    
    proof[0] = bytes32(0x1b79d10a7c45f4f5d9bec3aa079f9fa9910c7b6b1f2351fbf6af7bda7592b06e);
    
    proof[1] = bytes32(0x95194401fca4ae15186d77ef940676709a15e10d74be56dd2504eb011dce0474);
    
    data["test-allowlist-minter"].entries.push(MerkleEntry({
      user: 0x0000000000000000000000000000000000000100,
      maxMint: 8,
      mintPrice: 150000000000000000,
      proof: proof 
    }));
    
    proof = new bytes32[](2);
    
    proof[0] = bytes32(0x3a37a4cccaa55f9a3462dd32ae4202323fa7f31fef66a3b27c57928b0ee825f6);
    
    proof[1] = bytes32(0x6bdff456e88b1454e72f42110c39e03d24f9de4ce29200ea339bf47decf29ae2);
    
    data["test-allowlist-minter"].entries.push(MerkleEntry({
      user: 0x0000000000000000000000000000000000000101,
      maxMint: 8,
      mintPrice: 150000000000000000,
      proof: proof 
    }));
    
    proof = new bytes32[](2);
    
    proof[0] = bytes32(0x53ae2743a2b8d783cf5aa6d95eae38c3e7986bca7b03303c0397d21e9980928a);
    
    proof[1] = bytes32(0x6bdff456e88b1454e72f42110c39e03d24f9de4ce29200ea339bf47decf29ae2);
    
    data["test-allowlist-minter"].entries.push(MerkleEntry({
      user: 0x0000000000000000000000000000000000000102,
      maxMint: 8,
      mintPrice: 150000000000000000,
      proof: proof 
    }));
    
    
  }
}
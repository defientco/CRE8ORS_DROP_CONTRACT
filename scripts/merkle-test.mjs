import ejs from "ejs";
import { makeTree } from "./merkle.mjs";
import { zeroPad, hexlify } from "@ethersproject/bytes";
import { parseEther } from "@ethersproject/units";
import { join } from "path";
import { writeFile } from "fs/promises";
import esMain from "es-main";

import { dirname } from "path";
import { fileURLToPath } from "url";

const __dirname = dirname(fileURLToPath(import.meta.url));

async function renderFromPath(path, data) {
  return new Promise((resolve, reject) => {
    ejs.renderFile(path, data, (err, result) => {
      if (err) {
        return reject(err);
      }
      return resolve(result);
    });
  });
}

function makeAddress(partial) {
  return hexlify(zeroPad(partial, 20));
}

const testDataInput = [
  {
    name: "test-3-addresses",
    entries: [
      { minter: makeAddress(0x10), maxCount: 1, price: parseEther("0.01") },
      { minter: makeAddress(0x11), maxCount: 2, price: parseEther("0.01") },
      { minter: makeAddress(0x12), maxCount: 3, price: parseEther("0.01") },
    ],
  },
  {
    name: "test-2-prices",
    entries: [
      { minter: makeAddress(0x10), maxCount: 2, price: parseEther("0.1") },
      { minter: makeAddress(0x10), maxCount: 2, price: parseEther("0.2") },
    ],
  },
  {
    name: "test-max-count",
    entries: [
      { minter: makeAddress(0x10), maxCount: 2, price: parseEther("0.1") },
      { minter: makeAddress(0x10), maxCount: 2, price: parseEther("0.2") },
    ],
  },
  {
    name: "test-88-founders",
    entries: [
      { minter: makeAddress(0x100), maxCount: 1, price: parseEther("0.0") },
      { minter: makeAddress(0x101), maxCount: 1, price: parseEther("0.0") },
      { minter: makeAddress(0x102), maxCount: 1, price: parseEther("0.0") },
      { minter: makeAddress(0x103), maxCount: 1, price: parseEther("0.0") },
      { minter: makeAddress(0x104), maxCount: 1, price: parseEther("0.0") },
      { minter: makeAddress(0x105), maxCount: 1, price: parseEther("0.0") },
      { minter: makeAddress(0x106), maxCount: 1, price: parseEther("0.0") },
      { minter: makeAddress(0x107), maxCount: 1, price: parseEther("0.0") },
      { minter: makeAddress(0x108), maxCount: 1, price: parseEther("0.0") },
      { minter: makeAddress(0x109), maxCount: 1, price: parseEther("0.0") },
      { minter: makeAddress(0x110), maxCount: 1, price: parseEther("0.0") },
      { minter: makeAddress(0x111), maxCount: 1, price: parseEther("0.0") },
      { minter: makeAddress(0x112), maxCount: 1, price: parseEther("0.0") },
      { minter: makeAddress(0x113), maxCount: 1, price: parseEther("0.0") },
      { minter: makeAddress(0x114), maxCount: 1, price: parseEther("0.0") },
      { minter: makeAddress(0x115), maxCount: 1, price: parseEther("0.0") },
      { minter: makeAddress(0x116), maxCount: 1, price: parseEther("0.0") },
      { minter: makeAddress(0x117), maxCount: 1, price: parseEther("0.0") },
      { minter: makeAddress(0x118), maxCount: 1, price: parseEther("0.0") },
      { minter: makeAddress(0x119), maxCount: 1, price: parseEther("0.0") },
      { minter: makeAddress(0x120), maxCount: 1, price: parseEther("0.0") },
      { minter: makeAddress(0x121), maxCount: 1, price: parseEther("0.0") },
      { minter: makeAddress(0x122), maxCount: 1, price: parseEther("0.0") },
      { minter: makeAddress(0x123), maxCount: 1, price: parseEther("0.0") },
      { minter: makeAddress(0x124), maxCount: 1, price: parseEther("0.0") },
      { minter: makeAddress(0x125), maxCount: 1, price: parseEther("0.0") },
      { minter: makeAddress(0x126), maxCount: 1, price: parseEther("0.0") },
      { minter: makeAddress(0x127), maxCount: 1, price: parseEther("0.0") },
      { minter: makeAddress(0x128), maxCount: 1, price: parseEther("0.0") },
      { minter: makeAddress(0x129), maxCount: 1, price: parseEther("0.0") },
      { minter: makeAddress(0x130), maxCount: 1, price: parseEther("0.0") },
      { minter: makeAddress(0x131), maxCount: 1, price: parseEther("0.0") },
      { minter: makeAddress(0x132), maxCount: 1, price: parseEther("0.0") },
      { minter: makeAddress(0x133), maxCount: 1, price: parseEther("0.0") },
      { minter: makeAddress(0x134), maxCount: 1, price: parseEther("0.0") },
      { minter: makeAddress(0x135), maxCount: 1, price: parseEther("0.0") },
      { minter: makeAddress(0x136), maxCount: 1, price: parseEther("0.0") },
      { minter: makeAddress(0x137), maxCount: 1, price: parseEther("0.0") },
      { minter: makeAddress(0x138), maxCount: 1, price: parseEther("0.0") },
      { minter: makeAddress(0x139), maxCount: 1, price: parseEther("0.0") },
      { minter: makeAddress(0x140), maxCount: 1, price: parseEther("0.0") },
      { minter: makeAddress(0x141), maxCount: 1, price: parseEther("0.0") },
      { minter: makeAddress(0x142), maxCount: 1, price: parseEther("0.0") },
      { minter: makeAddress(0x143), maxCount: 1, price: parseEther("0.0") },
      { minter: makeAddress(0x144), maxCount: 1, price: parseEther("0.0") },
      { minter: makeAddress(0x145), maxCount: 1, price: parseEther("0.0") },
      { minter: makeAddress(0x146), maxCount: 1, price: parseEther("0.0") },
      { minter: makeAddress(0x147), maxCount: 1, price: parseEther("0.0") },
      { minter: makeAddress(0x148), maxCount: 1, price: parseEther("0.0") },
      { minter: makeAddress(0x149), maxCount: 1, price: parseEther("0.0") },
      { minter: makeAddress(0x150), maxCount: 1, price: parseEther("0.0") },
      { minter: makeAddress(0x151), maxCount: 1, price: parseEther("0.0") },
      { minter: makeAddress(0x152), maxCount: 1, price: parseEther("0.0") },
      { minter: makeAddress(0x153), maxCount: 1, price: parseEther("0.0") },
      { minter: makeAddress(0x154), maxCount: 1, price: parseEther("0.0") },
      { minter: makeAddress(0x155), maxCount: 1, price: parseEther("0.0") },
      { minter: makeAddress(0x156), maxCount: 1, price: parseEther("0.0") },
      { minter: makeAddress(0x157), maxCount: 1, price: parseEther("0.0") },
      { minter: makeAddress(0x158), maxCount: 1, price: parseEther("0.0") },
      { minter: makeAddress(0x159), maxCount: 1, price: parseEther("0.0") },
      { minter: makeAddress(0x190), maxCount: 1, price: parseEther("0.0") },
      { minter: makeAddress(0x161), maxCount: 1, price: parseEther("0.0") },
      { minter: makeAddress(0x162), maxCount: 1, price: parseEther("0.0") },
      { minter: makeAddress(0x163), maxCount: 1, price: parseEther("0.0") },
      { minter: makeAddress(0x164), maxCount: 1, price: parseEther("0.0") },
      { minter: makeAddress(0x165), maxCount: 1, price: parseEther("0.0") },
      { minter: makeAddress(0x166), maxCount: 1, price: parseEther("0.0") },
      { minter: makeAddress(0x167), maxCount: 1, price: parseEther("0.0") },
      { minter: makeAddress(0x168), maxCount: 1, price: parseEther("0.0") },
      { minter: makeAddress(0x169), maxCount: 1, price: parseEther("0.0") },
      { minter: makeAddress(0x170), maxCount: 1, price: parseEther("0.0") },
      { minter: makeAddress(0x171), maxCount: 1, price: parseEther("0.0") },
      { minter: makeAddress(0x172), maxCount: 1, price: parseEther("0.0") },
      { minter: makeAddress(0x173), maxCount: 1, price: parseEther("0.0") },
      { minter: makeAddress(0x174), maxCount: 1, price: parseEther("0.0") },
      { minter: makeAddress(0x175), maxCount: 1, price: parseEther("0.0") },
      { minter: makeAddress(0x176), maxCount: 1, price: parseEther("0.0") },
      { minter: makeAddress(0x177), maxCount: 1, price: parseEther("0.0") },
      { minter: makeAddress(0x178), maxCount: 1, price: parseEther("0.0") },
      { minter: makeAddress(0x179), maxCount: 1, price: parseEther("0.0") },
      { minter: makeAddress(0x180), maxCount: 1, price: parseEther("0.0") },
      { minter: makeAddress(0x181), maxCount: 1, price: parseEther("0.0") },
      { minter: makeAddress(0x182), maxCount: 1, price: parseEther("0.0") },
      { minter: makeAddress(0x183), maxCount: 1, price: parseEther("0.0") },
      { minter: makeAddress(0x184), maxCount: 1, price: parseEther("0.0") },
      { minter: makeAddress(0x185), maxCount: 1, price: parseEther("0.0") },
      { minter: makeAddress(0x196), maxCount: 1, price: parseEther("0.0") },
      { minter: makeAddress(0x187), maxCount: 1, price: parseEther("0.0") },
    ],
  },
];

async function renderExample() {
  const testData = testDataInput.map((testDataItem) => {
    console.log(testDataItem);
    const treeResult = makeTree(testDataItem.entries);
    testDataItem.entries = treeResult.entries;
    testDataItem.root = treeResult.root;
    return testDataItem;
  });
  const testPath = join(__dirname, "../", "test/merkle", "MerkleData.sol.ejs");
  const resultPath = testPath.substring(0, testPath.length - 4);
  const render = await renderFromPath(testPath, { testData });
  await writeFile(resultPath, render);
  console.log(render);
}

if (esMain(import.meta)) {
  // Run main
  await renderExample();
}

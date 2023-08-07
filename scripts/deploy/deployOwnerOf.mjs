import { deployAndVerify } from "../contract.mjs";
import dotenv from "dotenv";

dotenv.config({
  path: `.env.${process.env.CHAIN}`,
});

export async function deployOwnerOf() {
  console.log("deploying OwnerOfHook");
  const contractLocation = "src/hooks/OwnerOf.sol:OwnerOfHook";
  const args = [];
  const contract = await deployAndVerify(contractLocation, args);
  const contractAddress = contract.deployed.deploy.deployedTo;
  console.log("deployed transfer hook to ", contractAddress);
  console.log("make sure to call cre8ors.setHook(2) for ownerOfHook");
  return contract.deployed;
}

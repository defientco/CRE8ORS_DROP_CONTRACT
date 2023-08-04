import { deployAndVerify } from "../contract.mjs";
import dotenv from "dotenv";

dotenv.config({
  path: `.env.${process.env.CHAIN}`,
});

export async function deployLockup() {
  console.log("deploying Lockup");
  const contractLocation = "src/utils/Lockup.sol:Lockup";
  const args = null;
  const contract = await deployAndVerify(contractLocation, args);
  const contractAddress = contract.deployed.deploy.deployedTo;
  console.log("deployed lockup to ", contractAddress);
  console.log("make sure to call setLockup on cre8ing contract");
  return contract.deployed;
}

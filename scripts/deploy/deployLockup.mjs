import { retryDeploy } from "../contract.mjs";
import dotenv from "dotenv";

dotenv.config({
  path: `.env.${process.env.CHAIN}`,
});

export async function deployLockup() {
  console.log("deploying Lockup");
  const contractLocation = "src/utils/Lockup.sol:Lockup";
  const args = null;
  const contract = await retryDeploy(2, contractLocation, args);
  console.log(`[deployed] ${contractLocation}`);
  const contractAddress = contract.deploy.deployedTo;
  console.log("deployed lockup to ", contractAddress);
  console.log("make sure to call setLockup on cre8ing contract");
  return contract;
}

import { retryDeploy } from "../contract.mjs";
import dotenv from "dotenv";

dotenv.config({
  path: `.env.${process.env.CHAIN}`,
});

export async function deployMinterUtilities(cre8orsAddress) {
  console.log("deploying minter utilities");
  const contractLocation = "src/utils/MinterUtilities.sol:MinterUtilities";
  // 0.05 ETH
  const tier1Price = "50000000000000000";
  // 0.1 ETH
  const tier2Price = "100000000000000000";
  // 0.15 ETH
  const tier3Price = "150000000000000000";
  const args = [cre8orsAddress, tier1Price, tier2Price, tier3Price];
  const contract = await retryDeploy(2, contractLocation, args);
  console.log(`[deployed] ${contractLocation}`);
  const contractAddress = contract.deploy.deployedTo;
  console.log("deployed minter utilities to ", contractAddress);
  return contract;
}

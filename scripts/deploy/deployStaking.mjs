import { retryDeploy } from "../contract.mjs";
import dotenv from "dotenv";

dotenv.config({
  path: `.env.${process.env.CHAIN}`,
});

export async function deployStaking() {
  console.log("deploying Staking");
  const contractLocation = "src/Cre8ing.sol:Cre8ing";
  const args = null;
  const contract = await retryDeploy(2, contractLocation, args);
  console.log(`[deployed] ${contractLocation}`);
  const contractAddress = contract.deploy.deployedTo;
  console.log("deployed staking to ", contractAddress);
  console.log("make sure to call setCre8ing on core cre8or");
  console.log("make sure to call setCre8ingOpen on core cre8ing");
  console.log(
    "make sure to call grantRole of MINTER_ROLE to cre8ing on core cre8ing"
  );
  return contract;
}

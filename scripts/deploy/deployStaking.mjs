import { deployAndVerify } from "../contract.mjs";
import dotenv from "dotenv";

dotenv.config({
  path: `.env.${process.env.CHAIN}`,
});

export async function deployStaking() {
  console.log("deploying Staking");
  const contractLocation = "src/utils/Cre8ingV2.sol:Cre8ingV2";
  const args = null;
  const contract = await deployAndVerify(contractLocation, args);
  const contractAddress = contract.deployed.deploy.deployedTo;
  console.log("deployed staking to ", contractAddress);
  console.log("make sure to call setCre8ing on core cre8or");
  console.log("make sure to call setCre8ingOpen on core cre8ing");
  return contract.deployed;
}

await deployStaking();

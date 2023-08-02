import { retryDeploy } from "../contract.mjs";
import dotenv from "dotenv";

dotenv.config({
  path: `.env.${process.env.CHAIN}`,
});

export async function deployPublicMinter(_cre8orAddress, _minterUtility) {
  console.log("deploying public minter");
  const contractLocation = "src/minter/PublicMinter.sol:PublicMinter";
  const args = [_cre8orAddress, _minterUtility];
  const contract = await retryDeploy(2, contractLocation, args);
  console.log(`[deployed] ${contractLocation}`);
  const contractAddress = contract.deploy.deployedTo;
  console.log("deployed public minter to ", contractAddress);
  console.log(
    "make sure to call grantRole with ADMIN_ROLE on cre8ors contract"
  );
  return contract;
}

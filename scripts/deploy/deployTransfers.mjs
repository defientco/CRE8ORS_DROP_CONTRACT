import { deployAndVerify } from "../contract.mjs";
import dotenv from "dotenv";

dotenv.config({
  path: `.env.${process.env.CHAIN}`,
});

export async function deployTransfers() {
  console.log("deploying Transferv0.2 Hook");
  const contractLocation = "src/hooks/Transfersv0_2.sol:TransferHookv0_2";
  const args = [];
  const contract = await deployAndVerify(contractLocation, args);
  const contractAddress = contract.deployed.deploy.deployedTo;
  console.log("deployed transfer hook to ", contractAddress);
  console.log(
    "make sure to call cre8ors.setHook(0) for beforeTokenTransferHook"
  );
  return contract.deployed;
}

await deployTransfers();

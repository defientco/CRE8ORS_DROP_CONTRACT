import { retryDeploy } from "../contract.mjs";
import dotenv from "dotenv";

dotenv.config({
  path: `.env.${process.env.CHAIN}`,
});

export async function deployTransfers(cre8orsNftAddress) {
  console.log("deploying Transfer Hook");
  const contractLocation = "src/Transfers.sol:TransferHook";
  const args = [cre8orsNftAddress];
  const contract = await retryDeploy(2, contractLocation, args);
  console.log(`[deployed] ${contractLocation}`);
  const contractAddress = contract.deploy.deployedTo;
  console.log("deployed transfer hook to ", contractAddress);
  console.log(
    "make sure to call setHook on cre8ors contract for afterTokenTransferHook"
  );
  return contract;
}

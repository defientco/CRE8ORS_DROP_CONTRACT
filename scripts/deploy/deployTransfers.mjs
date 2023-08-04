import { deployAndVerify } from "../contract.mjs";
import dotenv from "dotenv";

dotenv.config({
  path: `.env.${process.env.CHAIN}`,
});

export async function deployTransfers() {
  console.log("deploying Transfer Hook");
  const contractLocation = "src/Transfers.sol:TransferHook";
  const args = null;
  const contract = await deployAndVerify(contractLocation, args);
  const contractAddress = contract.deployed.deploy.deployedTo;
  console.log("deployed transfer hook to ", contractAddress);
  console.log(
    "make sure to call setHook on cre8ors contract for afterTokenTransferHook"
  );
  return contract.deployed;
}

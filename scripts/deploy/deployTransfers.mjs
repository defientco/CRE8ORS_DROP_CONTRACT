import { deployAndVerify } from "../contract.mjs";
import dotenv from "dotenv";

dotenv.config({
  path: `.env.${process.env.CHAIN}`,
});

export async function deployTransfers(cre8orsNftAddress) {
  console.log("deploying Transferv0.2 Hook");
  const contractLocation = "src/hooks/Transfersv0_2.sol:TransferHookv0_2";
  const args = [cre8orsNftAddress];
  const contract = await deployAndVerify(contractLocation, args);
  const contractAddress = contract.deployed.deploy.deployedTo;
  console.log("deployed transfer hook to ", contractAddress);
  console.log(
    "make sure to call cre8ors.setHook(0) for beforeTokenTransferHook"
  );
  return contract.deployed;
}

const GOERLI_CRE8ORS = "0x68C885f0954094C59847E6FeB252Fe5B4b0451Ba";
const MAINNET_CRE8ORS = "0x8ddef0396d4b61fcbb0e4a821dfac52c011f79da";
await deployTransfers(GOERLI_CRE8ORS);

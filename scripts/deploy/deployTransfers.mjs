import { deployAndVerify } from "../contract.mjs";
import dotenv from "dotenv";

dotenv.config({
  path: `.env.${process.env.CHAIN}`,
});

export async function deployTransfers(cre8orsNftAddress, stakingAddress) {
  console.log("deploying Transferv0.1 Hook");
  const contractLocation = "src/hooks/Transfersv0_1.sol:TransferHookv0_1";
  const args = [cre8orsNftAddress, stakingAddress];
  const contract = await deployAndVerify(contractLocation, args);
  const contractAddress = contract.deployed.deploy.deployedTo;
  console.log("deployed transfer hook to ", contractAddress);
  console.log(
    "make sure to call cre8ors.setHook(0) for beforeTokenTransferHook"
  );
  console.log(
    "make sure to call cre8ors.setHook(1) for afterTokenTransferHook"
  );
  return contract.deployed;
}

const GOERLI_CRE8ORS = "0x68C885f0954094C59847E6FeB252Fe5B4b0451Ba";
const GOERLI_STAKING = "0x0c0a5BE4119A5f121C5928eAE3f61d09Db3c4a7d";
await deployTransfers(GOERLI_CRE8ORS, GOERLI_STAKING);

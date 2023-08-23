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

const MAINNET_CRE8ORS = "0x8ddef0396d4b61fcbb0e4a821dfac52c011f79da";
const MAINNET_STAKING = "0xF7bfF0B8E59143a39271a4cA1B2D8De65FF7E658";
await deployTransfers(MAINNET_CRE8ORS, MAINNET_STAKING);

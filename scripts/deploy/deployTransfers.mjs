import { deployAndVerify } from "../contract.mjs";
import dotenv from "dotenv";

dotenv.config({
  path: `.env.${process.env.CHAIN}`,
});

export async function deployTransfers(cre8orsNftAddress) {
  console.log("deploying Transfer Hook");
  const contractLocation = "src/hooks/Transfers.sol:TransferHook";
  const ERC6551Registry = "0x02101dfB77FDE026414827Fdc604ddAF224F0921";
  const ERC6551Implementation = "0x2D25602551487C3f3354dD80D76D54383A243358";
  const args = [cre8orsNftAddress, ERC6551Registry, ERC6551Implementation];
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

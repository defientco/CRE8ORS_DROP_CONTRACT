import { retryDeploy } from "../contract.mjs";
import dotenv from "dotenv";

dotenv.config({
  path: `.env.${process.env.CHAIN}`,
});

export async function deployPassportMinter(
  _collectionContractAddress,
  _minterUtility,
  _friendsAndFamilyMinter
) {
  console.log("deploying passport minter");
  const contractLocation =
    "src/minter/CollectionHolderMint.sol:CollectionHolderMint";

  const args = [
    _collectionContractAddress,
    _minterUtility,
    _friendsAndFamilyMinter,
  ];
  const contract = await retryDeploy(2, contractLocation, args);
  console.log(`[deployed] ${contractLocation}`);
  const contractAddress = contract.deploy.deployedTo;
  console.log("deployed passport minter to ", contractAddress);
  return contract;
}

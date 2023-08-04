import { deployAndVerify } from "../contract.mjs";
import dotenv from "dotenv";

dotenv.config({
  path: `.env.${process.env.CHAIN}`,
});

export async function deployPassportMinter(
  _cre8orsNFT,
  _passportContractAddress,
  _minterUtility,
  _friendsAndFamilyMinter
) {
  console.log("deploying passport minter");
  const contractLocation =
    "src/minter/CollectionHolderMint.sol:CollectionHolderMint";

  const args = [
    _cre8orsNFT,
    _passportContractAddress,
    _minterUtility,
    _friendsAndFamilyMinter,
  ];
  const contract = await deployAndVerify(contractLocation, args);
  const contractAddress = contract.deployed.deploy.deployedTo;
  console.log("deployed passport minter to ", contractAddress);
  console.log(
    "make sure to call grantRole with MINTER_ROLE on cre8ors contract"
  );
  return contract.deployed;
}

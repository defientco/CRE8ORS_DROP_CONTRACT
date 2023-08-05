import { deployAndVerify } from "../contract.mjs";
import dotenv from "dotenv";

dotenv.config({
  path: `.env.${process.env.CHAIN}`,
});

export async function deployAllowlistMinter(
  _cre8orAddress,
  _minterUtility,
  _collectionHolderMint,
  _friendsAndFamilyMinter
) {
  console.log("deploying allowlist minter");
  const contractLocation = "src/minter/AllowlistMinter.sol:AllowlistMinter";
  const args = [
    _cre8orAddress,
    _minterUtility,
    _collectionHolderMint,
    _friendsAndFamilyMinter,
  ];
  const contract = await deployAndVerify(contractLocation, args);
  const contractAddress = contract.deployed.deploy.deployedTo;
  console.log("deployed allowlist minter to ", contractAddress);
  console.log(
    "make sure to call grantRole with MINTER_ROLE on cre8ors contract"
  );
  return contract.deployed;
}

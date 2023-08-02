import { retryDeploy } from "../contract.mjs";
import dotenv from "dotenv";

dotenv.config({
  path: `.env.${process.env.CHAIN}`,
});

export async function deployFamilyAndFriendsMinter(
  _cre8orsNFT,
  _minterUtilityContractAddress
) {
  console.log("deploying family & friends minter");
  const contractLocation =
    "src/minter/FriendsAndFamilyMinter.sol:FriendsAndFamilyMinter";

  const args = [_cre8orsNFT, _minterUtilityContractAddress];
  const contract = await retryDeploy(2, contractLocation, args);
  console.log(`[deployed] ${contractLocation}`);
  const contractAddress = contract.deploy.deployedTo;
  console.log("deployed family & friends to ", contractAddress);
  console.log(
    "make sure to call grantRole with MINTER_ROLE on cre8ors contract"
  );

  return contract;
}

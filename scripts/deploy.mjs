import { writeFile } from "fs/promises";
import dotenv from "dotenv";
import esMain from "es-main";
import { deployCre8ors } from "./deploy/deployCre8ors.mjs";
import { deployStaking } from "./deploy/deployStaking.mjs";
import { deployLockup } from "./deploy/deployLockup.mjs";
import { deployMinterUtilities } from "./deploy/deployMinterUtilities.mjs";
import { deployFamilyAndFriendsMinter } from "./deploy/deployFriendsAndFamily.mjs";
import { deployPassportMinter } from "./deploy/deployPassportMinter.mjs";
import { deployTransfers } from "./deploy/deployTransfers.mjs";
import { deployPublicMinter } from "./deploy/deployPublicMinter.mjs";
import { deployAllowlistMinter } from "./deploy/deployAllowlistMinter.mjs";

dotenv.config({
  path: `.env.${process.env.CHAIN}`,
});

export async function setupContracts() {
  console.log("deploying...");
  const presaleMerkleRoot =
    "0x36c161febf4b54734baf31a4d6b00da9f4a1cc6eeae64bb328e095b1ab00ec96";
  const cre8ors = await deployCre8ors(presaleMerkleRoot);
  const hooks = await deployTransfers();
  const staking = await deployStaking();
  const lockup = await deployLockup();

  const minterUtilities = await deployMinterUtilities(
    cre8ors.deploy.deployedTo
  );
  const familyFriendsMinter = await deployFamilyAndFriendsMinter(
    cre8ors.deploy.deployedTo,
    minterUtilities.deploy.deployedTo
  );
  const passportMinter = await deployPassportMinter(
    cre8ors.deploy.deployedTo,
    minterUtilities.deploy.deployedTo,
    familyFriendsMinter.deploy.deployedTo
  );
  const allowlistMinter = await deployAllowlistMinter(
    cre8ors.deploy.deployedTo,
    minterUtilities.deploy.deployedTo
  );
  const publicMinter = await deployPublicMinter(
    cre8ors.deploy.deployedTo,
    minterUtilities.deploy.deployedTo
  );
  return {
    allowlistMinter,
    cre8ors,
    familyFriendsMinter,
    hooks,
    lockup,
    minterUtilities,
    passportMinter,
    publicMinter,
    staking,
  };
}

async function main() {
  const output = await setupContracts();
  const date = new Date().toISOString().slice(0, 10);
  writeFile(
    `./deployments/${date}.${process.env.CHAIN}.json`,
    JSON.stringify(output, null, 2)
  );
}

if (esMain(import.meta)) {
  // Run main
  await main();
}

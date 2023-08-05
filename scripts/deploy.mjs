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
import { deploySubscription } from "./deploy/deploySubscription.mjs";
import { deployInitializer } from "./deploy/deployInitializer.mjs";

dotenv.config({
  path: `.env.${process.env.CHAIN}`,
});

export async function setupContracts() {
  console.log("deploying...");
  const presaleMerkleRoot =
    "0x36c161febf4b54734baf31a4d6b00da9f4a1cc6eeae64bb328e095b1ab00ec96";
  const subscription = await deploySubscription(cre8ors.deploy.deployedTo);
  const initializer = await deployInitializer();
  const cre8ors = await deployCre8ors(presaleMerkleRoot);
  const hooks = await deployTransfers(cre8ors.deploy.deployedTo);
  const staking = await deployStaking();
  const lockup = await deployLockup();
  const passportAddress = "0x31E28672F704d6F8204e41Ec0B93EE2b1172558E";

  const minterUtilities = await deployMinterUtilities(
    cre8ors.deploy.deployedTo
  );
  const familyFriendsMinter = await deployFamilyAndFriendsMinter(
    cre8ors.deploy.deployedTo,
    minterUtilities.deploy.deployedTo
  );
  const passportMinter = await deployPassportMinter(
    cre8ors.deploy.deployedTo,
    passportAddress,
    minterUtilities.deploy.deployedTo,
    familyFriendsMinter.deploy.deployedTo
  );
  const allowlistMinter = await deployAllowlistMinter(
    cre8ors.deploy.deployedTo,
    minterUtilities.deploy.deployedTo,
    passportMinter.deploy.deployedTo,
    familyFriendsMinter.deploy.deployedTo
  );
  const publicMinter = await deployPublicMinter(
    cre8ors.deploy.deployedTo,
    minterUtilities.deploy.deployedTo,
    passportMinter.deploy.deployedTo,
    familyFriendsMinter.deploy.deployedTo
  );
  return {
    allowlistMinter,
    cre8ors,
    familyFriendsMinter,
    hooks,
    initializer,
    lockup,
    minterUtilities,
    passportMinter,
    publicMinter,
    staking,
    subscription,
  };
}

async function main() {
  const output = await setupContracts();
  // const date = new Date().toISOString().slice(0, 10);
  // writeFile(
  //   `./deployments/${date}.${process.env.CHAIN}.json`,
  //   JSON.stringify(output, null, 2)
  // );
}

if (esMain(import.meta)) {
  // Run main
  await main();
}

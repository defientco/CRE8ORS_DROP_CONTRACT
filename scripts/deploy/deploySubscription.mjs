import { retryDeploy } from "../contract.mjs";
import dotenv from "dotenv";

dotenv.config({
  path: `.env.${process.env.CHAIN}`,
});

export async function deploySubscription(cre8orAddress) {
  console.log("deploying Subscription");
  const contractLocation = "src/subscription/Subscription.sol:Subscription";
  const minRenewalDuration_ = 86400;
  const pricePerSecond_ = 38580246913;
  const args = [cre8orAddress, minRenewalDuration_, pricePerSecond_];
  const contract = await retryDeploy(2, contractLocation, args);
  console.log(`[deployed] ${contractLocation}`);
  const contractAddress = contract.deploy.deployedTo;
  console.log("deployed subscription to ", contractAddress);
  console.log(
    "make sure to call cre8orsNFT.setSubscription(address(subscription))"
  );
  return contract;
}

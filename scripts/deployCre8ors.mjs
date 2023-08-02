import { retryDeploy } from "./contract.mjs";
import dotenv from "dotenv";

dotenv.config({
  path: `.env.${process.env.CHAIN}`,
});

export async function deployCre8ors() {
  console.log("deploying Cre8ors");
  const contractName = "cre8ors";
  const contractSymbol = "CRE8";
  const _initialOwner = "0x4D977d9aEceC3776DD73F2f9080C9AF3BC31f505"; // cre8ors.eth
  const _fundsRecipient = "0x4D977d9aEceC3776DD73F2f9080C9AF3BC31f505"; // cre8ors.eth
  const _editionSize = "8888";
  const _royaltyBPS = "888";
  const publicSalePrice = "150000000000000000";
  const erc20PaymentToken = "0x0000000000000000000000000000000000000000";
  const maxSalePurchasePerAddress = 18;
  const publicSaleStart = "1691078400"; // Aug 3, 2023 3PM ET
  const publicSaleEnd = "18446744073709551615"; // forever
  const presaleStart = 0; // always
  const presaleEnd = "18446744073709551615"; // forever
  const presaleMerkleRoot =
    "0xce76e30bbd0bc685a5aef45c2c381baaa6bbd02b0a71ec7515f66a590eb6cb3e";

  const _salesConfig = `"(${publicSalePrice},${erc20PaymentToken},${maxSalePurchasePerAddress},${publicSaleStart},${publicSaleEnd},${presaleStart},${presaleEnd},${presaleMerkleRoot})"`;
  const _metadataRenderer = "0x209511E9fe3c526C61B7691B9308830C1d1612bE"; // from Zora
  const contractLocation = "src/Cre8ors.sol:Cre8ors";
  const args = [
    contractName,
    contractSymbol,
    _initialOwner,
    _fundsRecipient,
    _editionSize,
    _royaltyBPS,
    _salesConfig,
    _metadataRenderer,
  ];
  const dropContract = await retryDeploy(2, contractLocation, args);
  console.log(`[deployed] ${contractLocation}`);
  const dropContractAddress = dropContract.deploy.deployedTo;
  console.log("deployed cre8ors to ", dropContractAddress);

  return dropContract;
}

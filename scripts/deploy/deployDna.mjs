import { retryDeploy, retryVerify } from "../contract.mjs";
import dotenv from "dotenv";

dotenv.config({
  path: `.env.${process.env.CHAIN}`,
});

export async function deployDna() {
  console.log("deploying DNA");
  const contractName = "CRE8ORS DNA";
  const contractSymbol = "DNA";
  const _initialOwner = "0x4D977d9aEceC3776DD73F2f9080C9AF3BC31f505"; // cre8ors.eth
  const _fundsRecipient = "0x4D977d9aEceC3776DD73F2f9080C9AF3BC31f505"; // cre8ors.eth
  const _editionSize = "8888";
  const _royaltyBPS = "888";
  const publicSalePrice = "0";
  const erc20PaymentToken = "0x0000000000000000000000000000000000000000";
  const maxSalePurchasePerAddress = 0;
  const presaleStart = "18446744073709551615"; // never
  const presaleEnd = "18446744073709551615"; // forever
  const publicSaleStart = "18446744073709551615"; // never
  const publicSaleEnd = "18446744073709551615"; // forever
  const presaleMerkleRoot =
    "0x0000000000000000000000000000000000000000000000000000000000000000";
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

  const _salesConfig2 = [
    publicSalePrice,
    erc20PaymentToken,
    maxSalePurchasePerAddress,
    publicSaleStart,
    publicSaleEnd,
    presaleStart,
    presaleEnd,
    presaleMerkleRoot,
  ];
  const args2 = [
    contractName,
    contractSymbol,
    _initialOwner,
    _fundsRecipient,
    _editionSize,
    _royaltyBPS,
    _salesConfig2,
    _metadataRenderer,
  ];
  const dropContractAddress = dropContract.deploy.deployedTo;

  await retryVerify(2, dropContractAddress, contractLocation, args2);
  console.log(`[verified] ${contractLocation}`);
  console.log("deployed DNA to ", dropContractAddress);

  return dropContract;
}

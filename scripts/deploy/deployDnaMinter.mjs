import { deployAndVerify } from "../contract.mjs";
import dotenv from "dotenv";

dotenv.config({
  path: `.env.${process.env.CHAIN}`,
});

export async function deployDnaMinter(_cre8orsNft, _dnaNft) {
  console.log("deploying DNA Minter");
  const _registry = "0x02101dfB77FDE026414827Fdc604ddAF224F0921";
  const _implementation = "0x2d25602551487c3f3354dd80d76d54383a243358";
  const contractLocation = "src/minter/DNAMinter.sol:DNAMinter";
  const args = [_cre8orsNft, _dnaNft, _registry, _implementation];
  const contract = await deployAndVerify(contractLocation, args);
  const contractAddress = contract.deployed.deploy.deployedTo;
  console.log("deployed dna minter to ", contractAddress);
  console.log(
    "make sure to grant dna.grantRole(DEFAULT_MINTER_ROLE, initializer)"
  );
  return contract.deployed;
}

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

const GOERLI_CRE8ORS = "0x68C885f0954094C59847E6FeB252Fe5B4b0451Ba";
const GOERLI_DNA = "0x603c50934b157776D8EbA39e628eE59Bf6230915";

deployDnaMinter(GOERLI_CRE8ORS, GOERLI_DNA);

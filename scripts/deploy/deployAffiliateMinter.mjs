import { deployAndVerify } from "../contract.mjs";
import dotenv from "dotenv";

dotenv.config({
  path: `.env.${process.env.CHAIN}`,
});

export async function deployReferralMinter(
  _cre8orAddress,
  _erc6551Registry,
  _erc6551AccountImplementation,
  _referralFee
) {
  console.log("deploying referral minter");
  const contractLocation = "src/minter/ReferralMinter.sol:ReferralMinter";
  const args = [
    _cre8orAddress,
    _erc6551Registry,
    _erc6551AccountImplementation,
    _referralFee,
  ];
  const contract = await deployAndVerify(contractLocation, args);
  const contractAddress = contract.deployed.deploy.deployedTo;
  console.log("deployed referral minter to ", contractAddress);
  console.log(
    "make sure to call grantRole with MINTER_ROLE on cre8ors contract"
  );
  return contract.deployed;
}

const GOERLI_CRE8ORS = "0x68C885f0954094C59847E6FeB252Fe5B4b0451Ba";
const GOERLI_ERC6551_REGISTRY = "0x02101dfB77FDE026414827Fdc604ddAF224F0921";
const GOERLI_ERC6551_IMPLEMENTATION =
  "0x2d25602551487c3f3354dd80d76d54383a243358";
const GOERLI_REFERRAL_FEE = 20;

deployReferralMinter(
  GOERLI_CRE8ORS,
  GOERLI_ERC6551_REGISTRY,
  GOERLI_ERC6551_IMPLEMENTATION,
  GOERLI_REFERRAL_FEE
);

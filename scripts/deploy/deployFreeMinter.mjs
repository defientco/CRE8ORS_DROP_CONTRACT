import { deployAndVerify } from '../contract.mjs';
import dotenv from 'dotenv';

dotenv.config({
  path: `.env.${process.env.CHAIN}`
});

export async function deployFreeMinter(_cre8orAddress, _passportAddress, _passportIDs) {
  console.log('deploying free minter');
  const contractLocation = 'src/minter/FreeMinter.sol:FreeMinter';
  const args = [_cre8orAddress, _passportAddress, _passportIDs];
  const contract = await deployAndVerify(contractLocation, args);
  const contractAddress = contract.deployed.deploy.deployedTo;
  console.log('deployed free minter to ', contractAddress);
  console.log('make sure to call grantRole with MINTER_ROLE on cre8ors contract');
  return contract.deployed;
}

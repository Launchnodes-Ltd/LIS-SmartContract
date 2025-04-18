import { ethers, upgrades } from 'hardhat';
import { verifyContract } from './utils/verify';

async function main() {
  const NgoV2 = await ethers.getContractFactory('NGOLis');
  const ngoV2 = await upgrades.deployImplementation(NgoV2);

  console.log('🚀 NgoV2 address:', ngoV2.toString(), '\n');
  console.log(`https://holesky.etherscan.io/address/${ngoV2.toString()}\n`);

  
  // console.log('Upgrading proxy...');
  await verifyContract(ngoV2.toString());

  // console.log('Old NGO finded');

  // await upgrades.forceImport(
  //   '0x023aaD896E741B9690a41D3B9B01a76e4f77F4C6',
  //   NgoV2,
  //   { kind: 'uups' }
  // );
  // console.log('Proxy upgraded');
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

import { ethers, upgrades } from "hardhat";
import { verifyContract } from "./utils/verify";
import {
  lidoAddress,
  lidoWithdrawAddress,
  wrappedLidoAddress,
} from "../config";

async function main() {
  const lidoSCAddress = lidoAddress;
  const wStEth = wrappedLidoAddress;
  const withdrawLidoSc = lidoWithdrawAddress;

  if (!lidoSCAddress || !withdrawLidoSc) {
    throw new Error("Add lido sc address or withdrawLidoSc");
  }

  // ============ Ngo implementation ============
  console.log('here');
  
  const NGOImpl = await ethers.getContractFactory("NGOLis");
  const ngoImpl = await upgrades.deployImplementation(NGOImpl);
  const ngoImplAddress = ngoImpl.toString();

  console.log("\n");
  console.log(`NGO implementation: ${ngoImplAddress}`);
  console.log(`https://holesky.etherscan.io/address/${ngoImplAddress}\n`);

  // ============ Ngo Factory ============

  const NGOFactory = await ethers.getContractFactory("NGOLisFactory");
  const ngoFactory = await NGOFactory.deploy(
    lidoSCAddress,
    withdrawLidoSc,
    ngoImplAddress,
    wStEth
  );
  const { address: ngoFactoryAddress } = await ngoFactory.deployed();

  console.log(`NGO Factory: ${ngoFactoryAddress}`);
  console.log(`https://holesky.etherscan.io/address/${ngoFactoryAddress}\n`);

  // ============ Verification ============

  await verifyContract(ngoImplAddress.toString());
  await verifyContract(
    ngoFactory.address,
    lidoSCAddress,
    withdrawLidoSc,
    ngoImplAddress,
    wStEth
  );

  process.exit();
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

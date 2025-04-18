import { WStEthImitation } from "./../../typechain-types/contracts/test-contracts/WStEthImitation";
import { ethers } from "hardhat";
import {
  IWithdrawalQueue__factory,
  NGOLis__factory,
} from "../../typechain-types";
import { lidoAddress } from "../../config";

//@ts-ignore
import wStEthABI from "../abi/wStEthAbi.json";

export async function deployNGOFactoryWithNgo() {
  // Contracts are deployed using the first signer/account by default
  const [owner, otherAccount, account3] = await ethers.getSigners();

  const LidoImitation = await ethers.getContractFactory("LidoImitation");
  const lidoSC = await LidoImitation.deploy("Lido", "stETH", 18);

  const wStEthIm = await ethers.getContractFactory("WStEthImitation");
  const wStEth = await wStEthIm.deploy("WStEth", "WStEth", 18);

  const WithdrawalImitation = await ethers.getContractFactory(
    "LidoWithdrawImitation"
  );

  const feeForOneDistribution = 270000000000000;
  const withdrawalSc = await WithdrawalImitation.deploy(lidoSC.address);

  const NGOLisImpl = await ethers.getContractFactory("NGOLis");
  const ngoLisImpl = await NGOLisImpl.deploy();

  const { address } = await ngoLisImpl.deployed();

  const NGOLisFactory = await ethers.getContractFactory("NGOLisFactory");
  const lock = await NGOLisFactory.deploy(
    lidoSC.address,
    withdrawalSc.address,
    address,
    wStEth.address
  );

  const ngoFactory = await lock.deployed();

  const data = await ngoFactory.createNGO(
    "asd",
    "asd",
    "asd",
    "asd",
    "asd",
    otherAccount.address,
    owner.address,
    owner.address
  );

  const info = await data.wait();

  const ngoDeployedAddress: string = info?.events?.[3]?.args?.["_ngoAddress"];

  const ngo = NGOLis__factory.connect(ngoDeployedAddress, owner);

  return {
    ngoFactory,
    owner,
    otherAccount,
    account3,
    lidoSC,
    withdrawalSc,
    ngo,
    wStEth,
    feeForOneDistribution,
  };
}

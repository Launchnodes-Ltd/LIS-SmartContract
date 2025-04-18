import { setStorageAt } from '@nomicfoundation/hardhat-network-helpers';
import { defaultAbiCoder, keccak256, parseEther } from 'ethers/lib/utils';
import { ethers } from 'hardhat';
import { IERC20, IERC20__factory } from '../../typechain-types';
import { BigNumber } from 'ethers';

export async function setTokenBalance(
  holder: string,
  token: string,
  desiredBalance: BigNumber | number,
  slotNumber: number = 4
): Promise<boolean> {
  try {
    const contract: IERC20 = IERC20__factory.connect(
      token.toString(),
      ethers.provider
    );
    const storageSlot = keccak256(
      defaultAbiCoder.encode(['uint256', 'uint256'], [holder, slotNumber])
    );
    await setStorageAt(contract.address, storageSlot, desiredBalance);
    const value = await contract.balanceOf(holder);
    return value === desiredBalance;
  } catch (e: any) {
    console.error(e);
  }
  return false;
}

export const getUserTotalAfterRewards = (
  days: number,
  amount: number,
  ngoPercent: number
) => {
  const amountInBI = parseEther(amount.toString()).toBigInt();
  const percentOfIncreasing = 10n;

  let total = amountInBI;
  let reward;

  for (let i = 0; i < days; i++) {
    reward = (total * percentOfIncreasing) / 100n;
    total += reward - (reward * BigInt(ngoPercent)) / 100n;
  }

  return total;
};

export const getAt = async (address: string, slot: number) => {
  return await ethers.provider.getStorageAt(address, slot);
};

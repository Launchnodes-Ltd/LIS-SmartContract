import { time } from "@nomicfoundation/hardhat-network-helpers";
import { ethers } from "hardhat";

export const increaseTimestamp = async (seconds: number | bigint) => {
  const signer = (await ethers.getSigners())[5];
  const timestamp = await time.latest();

  let timestampTo;
  if (typeof seconds === "bigint") {
    timestampTo = BigInt(timestamp) + seconds;
  } else {
    timestampTo = BigInt(timestamp) + BigInt(Math.floor(seconds));
  }

  await time.increaseTo(timestampTo);
  await signer.call({ value: ethers.utils.parseEther("0.01") });

  return timestampTo;
};

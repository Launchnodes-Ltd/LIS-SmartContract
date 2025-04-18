import { expect } from "chai";
import { loadFixture } from "@nomicfoundation/hardhat-network-helpers";
import { deployNGOFactoryWithNgo } from "./utils/deploy";
import { getAt } from "./utils/utils";
import { PERCENT_MULTIPLIER, ST_ETH_ADDRESS } from "./utils/constants";
import { ethers } from "hardhat";
import { parseEther } from "ethers/lib/utils";

export const factoryTestFlow = function () {
  /*-------------------------------------- Positive cases ---------------------------------------- */

  describe("Positive cases", () => {
    it("should CHANGE implementation", async () => {
      const { ngoFactory } = await loadFixture(deployNGOFactoryWithNgo);

      const tx = await ngoFactory.setImplementation(ST_ETH_ADDRESS);
      await tx.wait();

      const implementation = ethers.utils.hexDataSlice(
        await getAt(ngoFactory.address, 2),
        12
      );

      expect(implementation).to.eq(ST_ETH_ADDRESS.toLowerCase());
    });

    it("should CLAIM withdrawal fee", async () => {
      const {
        ngoFactory,
        ngo,
        feeForOneDistribution,
        owner,
        wStEth,
        otherAccount,
      } = await loadFixture(deployNGOFactoryWithNgo);

      const tx = await ngo.connect(otherAccount).stake(3 * PERCENT_MULTIPLIER, {
        value: parseEther("2"),
      });
      await tx.wait();

      await wStEth.simulateRewards(10);

      await ngo.handleNGOShareDistribution();
      const tx1 = ngoFactory.withdrawFeeStEth();

      await expect(tx1).to.changeTokenBalances(
        wStEth,
        [ngoFactory, owner],
        [-0, feeForOneDistribution]
      );
    });
  });

  /*-------------------------------------- Negative cases ---------------------------------------- */
  describe("Negative cases", () => {
    it("withdrawFeeStEth should REVERT if not owner", async () => {
      const { ngoFactory, otherAccount } = await loadFixture(
        deployNGOFactoryWithNgo
      );

      await expect(ngoFactory.connect(otherAccount).withdrawFeeStEth()).to.be
        .reverted;
    });

    it("createNGO should REVERT if not owner", async () => {
      const { ngoFactory, otherAccount } = await loadFixture(
        deployNGOFactoryWithNgo
      );

      await expect(
        ngoFactory
          .connect(otherAccount)
          .createNGO(
            "asd",
            "asd",
            "asd",
            "asd",
            "asd",
            otherAccount.address,
            otherAccount.address,
            otherAccount.address
          )
      ).to.be.reverted;
    });

    it("createNGO should REVERT if not null Adress", async () => {
      const { ngoFactory, otherAccount, ngo } = await loadFixture(
        deployNGOFactoryWithNgo
      );

      await expect(
        ngoFactory.createNGO(
          "asd",
          "asd",
          "asd",
          "asd",
          "asd",
          "0x0000000000000000000000000000000000000000",
          otherAccount.address,
          otherAccount.address
        )
      ).to.be.revertedWithCustomError(ngo, "NullAddress");
    });
  });
};

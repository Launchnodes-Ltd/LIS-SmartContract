import { expect } from "chai";
import { loadFixture } from "@nomicfoundation/hardhat-network-helpers";
import { ETH_AMOUNT, NGO_PERCENT, PERCENT_MULTIPLIER } from "./utils/constants";
import { parseEther } from "ethers/lib/utils";
import { deployNGOFactoryWithNgo } from "./utils/deploy";

export const handleNgoShareTest = function () {
  /*-------------------------------------- Positive cases ---------------------------------------- */

  describe("Positive cases", () => {
    it("should EMIT event rewards updated", async () => {
      const { ngo, wStEth, otherAccount } = await loadFixture(
        deployNGOFactoryWithNgo
      );

      const tx = await ngo.connect(otherAccount).stake(3 * PERCENT_MULTIPLIER, {
        value: parseEther("2"),
      });
      await tx.wait();

      await wStEth.simulateRewards(10);

      await expect(ngo.handleNGOShareDistribution()).to.be.emit(
        ngo,
        "RewardsUpdated"
      );
    });
  });

  /*-------------------------------------- Negative cases ---------------------------------------- */

  describe("Negative cases", () => {
    it("should REVERT if not oracle", async () => {
      const { ngo, otherAccount } = await loadFixture(deployNGOFactoryWithNgo);

      await expect(
        ngo.connect(otherAccount).handleNGOShareDistribution()
      ).to.be.revertedWithCustomError(ngo, "OnlyOracle");
    });
  });
};

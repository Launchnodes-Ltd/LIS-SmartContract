import { loadFixture } from "@nomicfoundation/hardhat-network-helpers";
import { deployNGOFactoryWithNgo } from "./utils/deploy";
import { parseEther } from "ethers/lib/utils";
import { ETH_AMOUNT, NGO_PERCENT, PERCENT_MULTIPLIER } from "./utils/constants";
import { expect } from "chai";

const amountInETH = parseEther(ETH_AMOUNT.toString());
const ngoPercentMultiplier = NGO_PERCENT * PERCENT_MULTIPLIER;

export const requestWithdrawalsTest = function () {
  /*-------------------------------------- Positive cases ---------------------------------------- */

  describe("Positive cases", () => {
    it("should be POSSIBLE to request all funds", async () => {
      const { ngo, lidoSC, withdrawalSc, owner, otherAccount } =
        await loadFixture(deployNGOFactoryWithNgo);
      const stakeTx = await ngo.stake(ngoPercentMultiplier, {
        value: amountInETH,
      });
      await stakeTx.wait();
      const userBalance = await ngo.getUserBalance(owner.address, 1);
      await ngo.requestWithdrawals(userBalance, 1);
      await lidoSC.imitateRewards(10, ngo.address);
      const status = await withdrawalSc.getWithdrawalStatus([0]);
      expect(status[0].amountOfStETH).to.eq(userBalance);
    });

    it("should be POSSIBLE to get 2 request", async () => {
      const { ngo, lidoSC, withdrawalSc, owner, wStEth } = await loadFixture(
        deployNGOFactoryWithNgo
      );

      const stakeTx = await ngo.stake(ngoPercentMultiplier, {
        value: amountInETH,
      });
      await stakeTx.wait();

      const userBalance = await wStEth.getUserBalance(owner.address, 1);
      await ngo.requestWithdrawals(userBalance.div(2), 1);
      await ngo.requestWithdrawals(userBalance.div(2), 1);

      const status = await withdrawalSc.getWithdrawalStatus([0]);
      const status2 = await withdrawalSc.getWithdrawalStatus([1]);
      expect(status[0].amountOfStETH).to.eq(userBalance.div(2));
      expect(status2[0].amountOfStETH).to.eq(userBalance.div(2));
    });
  });

  /*-------------------------------------- Negative case ---------------------------------------- */

  describe("Negative cases", () => {
    it("should REVERT if amount more than staked", async () => {
      const { ngo } = await loadFixture(deployNGOFactoryWithNgo);

      const stakeTx = await ngo.stake(ngoPercentMultiplier, {
        value: amountInETH,
      });
      await stakeTx.wait();

      await expect(
        ngo.requestWithdrawals(amountInETH.add(1), 1)
      ).to.revertedWithCustomError(ngo, "RequestAmountTooLarge");
    });
  });
};

import { loadFixture } from "@nomicfoundation/hardhat-network-helpers";
import { expect } from "chai";
import { parseEther } from "ethers/lib/utils";
import {
  ANOTHER_ETH_AMOUNT,
  ANOTHER_NGO_PERCENT,
  ETH_AMOUNT,
  NGO_PERCENT,
  ONE_ETH,
  PERCENT_MULTIPLIER,
} from "./utils/constants";
import { deployNGOFactoryWithNgo } from "./utils/deploy";

const amountInETH = parseEther(ETH_AMOUNT.toString());
const ngoPercentMultiplier = NGO_PERCENT * PERCENT_MULTIPLIER;

export const stakeFlowTest = function () {
  /*-------------------------------------- Positive cases ---------------------------------------- */

  describe("Positive cases", () => {
    it("should set new reward owner", async () => {
      const { ngo, owner, otherAccount, lidoSC, wStEth } = await loadFixture(
        deployNGOFactoryWithNgo
      );
      await ngo.setRewardsOwner(otherAccount.address);
    });

    it("should set new oracle ", async () => {
      const { ngo, owner, otherAccount } = await loadFixture(
        deployNGOFactoryWithNgo
      );
      await ngo.setOracle(otherAccount.address, true);
    });

    it("should return correct user balance", async () => {
      const { ngo, owner, otherAccount, lidoSC, wStEth } = await loadFixture(
        deployNGOFactoryWithNgo
      );

      const stakeTx = await ngo.stake(ngoPercentMultiplier, {
        value: amountInETH,
      });
      await stakeTx.wait();

      const stake2Tx = await ngo
        .connect(otherAccount)
        .stake(ngoPercentMultiplier, {
          value: amountInETH,
        });
      await stake2Tx.wait();

      const balanceBefore = await wStEth.getUserBalance(owner.address, 1);

      const wsEthPriceBefore = await wStEth.getWstEthPrice();
      const priceinWstEthBefore = amountInETH.mul(wsEthPriceBefore).div(100);

      expect(balanceBefore).to.closeTo(priceinWstEthBefore, 100);

      await wStEth.simulateRewards(10);

      const balanceAfter = await wStEth.getUserBalance(owner.address, 1);

      const wsEthPriceAfter = await wStEth.getWstEthPrice();
      const priceinWstEthAfter = amountInETH.mul(wsEthPriceAfter).div(100);

      expect(balanceAfter).to.closeTo(priceinWstEthAfter, 100);
    });

    it("should not change 1 user rewards after 2 user stake", async () => {
      const { ngo, owner, otherAccount, wStEth } = await loadFixture(
        deployNGOFactoryWithNgo
      );

      const stakeTx = await ngo.stake(ngoPercentMultiplier, {
        value: amountInETH,
      });
      await stakeTx.wait();

      await wStEth.simulateRewards(10);

      const balanceUserBeforeStake = await wStEth.getUserBalance(
        owner.address,
        1
      );

      const stake2Tx = await ngo
        .connect(otherAccount)
        .stake(ngoPercentMultiplier, { value: amountInETH });
      await stake2Tx.wait();

      const balanceUserAfterStake = await wStEth.getUserBalance(
        owner.address,
        1
      );
      expect(balanceUserBeforeStake).to.equal(balanceUserAfterStake);
    });

    it("should be correct balance after 1 more day of rewards", async () => {
      const anotherAmountOfEth = parseEther(ANOTHER_ETH_AMOUNT.toString());
      const { ngo, owner, otherAccount, wStEth } = await loadFixture(
        deployNGOFactoryWithNgo
      );

      const stakeTx = await ngo.stake(NGO_PERCENT * PERCENT_MULTIPLIER, {
        value: amountInETH,
      });
      await stakeTx.wait();

      await wStEth.simulateRewards(10);

      const stake2Tx = await ngo
        .connect(otherAccount)
        .stake(ANOTHER_NGO_PERCENT * PERCENT_MULTIPLIER, {
          value: anotherAmountOfEth,
        });
      await stake2Tx.wait();

      await wStEth.simulateRewards(10);

      const balance1 = await wStEth.getUserBalance(owner.address, 1);

      const userWsEthPriceAfter = await wStEth.getWstEthPrice();
      const userPriceinWstEthAfter = amountInETH
        .mul(userWsEthPriceAfter)
        .div(100);

      const anotherUserWsEthPriceAfter = await wStEth.getWstEthPrice();
      const anotherUserPriceinWstEthAfter = anotherAmountOfEth
        .mul(anotherUserWsEthPriceAfter)
        .div(100);
      const balance2 = await wStEth.getUserBalance(otherAccount.address, 2);

      expect(balance1).to.closeTo(userPriceinWstEthAfter, 100);
      expect(balance2).to.closeTo(anotherUserPriceinWstEthAfter, 1000);
    });

    it("should SENDS  WSEth", async function () {
      const { ngo, wStEth } = await loadFixture(deployNGOFactoryWithNgo);

      const balanceOnLidoBeforeStake = await wStEth.balanceOf(ngo.address);

      const stakeTx = await ngo.stake(ngoPercentMultiplier, {
        value: amountInETH,
      });

      await stakeTx.wait();

      const balanceOnLidoAfterStake = await wStEth.balanceOf(ngo.address);

      expect(balanceOnLidoBeforeStake).eq(0);
      expect(balanceOnLidoAfterStake).greaterThan(balanceOnLidoBeforeStake);
    });

    it("should SAVE information about user stake", async function () {
      const { ngo, owner } = await loadFixture(deployNGOFactoryWithNgo);

      const stakeTx = await ngo.stake(ngoPercentMultiplier, {
        value: amountInETH,
      });

      await stakeTx.wait();

      const { amount, percent } = await ngo.getUserStakeInfo(owner.address, 1);

      expect(amount).to.eq(amountInETH);
      expect(percent).to.eq(ngoPercentMultiplier);
    });

    it("should UPDATED common staking information", async function () {
      const { ngo, wStEth } = await loadFixture(deployNGOFactoryWithNgo);

      const stakeTx = await ngo.stake(ngoPercentMultiplier, {
        value: amountInETH,
      });

      await stakeTx.wait();

      const stakedBalance = await wStEth.balanceOf(ngo.address);
      expect(stakedBalance).to.eq(amountInETH);
    });

    it("should EMIT event Staked", async function () {
      const { ngo } = await loadFixture(deployNGOFactoryWithNgo);

      await expect(
        ngo.stake(ngoPercentMultiplier, {
          value: amountInETH,
        })
      ).to.emit(ngo, "Staked");
    });

    it("should Emit rename event", async () => {
      const { ngo } = await loadFixture(deployNGOFactoryWithNgo);

      await expect(
        ngo.emitEvent("_name", "string", "string", "string", "string")
      ).to.emit(ngo, "GraphEvent");
    });

    /*-------------------------------------- Negative case ---------------------------------------- */

    describe("Negative cases", () => {
      it("should REVERT if percent less then 1% or greater then 100%", async () => {
        const { ngo } = await loadFixture(deployNGOFactoryWithNgo);

        const minStakingPercent = 0.5 * 100;
        const maxStakingPercent = 101 * 100;

        await expect(
          ngo.stake(minStakingPercent, { value: amountInETH })
        ).to.revertedWithCustomError(ngo, "InvalidPercent");
        await expect(
          ngo.stake(maxStakingPercent, { value: amountInETH })
        ).to.revertedWithCustomError(ngo, "InvalidPercent");
      });

      it("should Revert if user banned", async () => {
        const { ngo, owner, otherAccount } = await loadFixture(
          deployNGOFactoryWithNgo
        );
        await ngo.setUserBan(otherAccount.address, true);

        await expect(
          ngo.connect(otherAccount).stake(ngoPercentMultiplier, {
            value: amountInETH,
          })
        ).to.revertedWithCustomError(ngo, "UserBanned");
      });

      it("should REVERT if NGO was finished", async () => {
        const { ngo } = await loadFixture(deployNGOFactoryWithNgo);

        const finishNgoTx = await ngo.endNGO();
        await finishNgoTx.wait();

        await expect(
          ngo.stake(ngoPercentMultiplier, { value: amountInETH })
        ).to.revertedWithCustomError(ngo, "NgoFinished");
      });

      it("should REVERT if user Not staked", async () => {
        const { ngo, otherAccount } = await loadFixture(
          deployNGOFactoryWithNgo
        );

        const stakeTx = await ngo.stake(ngoPercentMultiplier, {
          value: amountInETH,
        });
        await stakeTx.wait();

        await expect(
          ngo.connect(otherAccount).requestWithdrawals(1, 1)
        ).to.revertedWithCustomError(ngo, "RequestAmountTooLarge");
      });
    });
  });
};

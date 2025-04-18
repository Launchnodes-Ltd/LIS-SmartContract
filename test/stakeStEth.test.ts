import { loadFixture } from "@nomicfoundation/hardhat-network-helpers";
import { setTokenBalance } from "./utils/utils";
import { expect } from "chai";
import {
  ANOTHER_ETH_AMOUNT,
  ETH_AMOUNT,
  NGO_PERCENT,
  PERCENT_MULTIPLIER,
} from "./utils/constants";
import { parseEther } from "ethers/lib/utils";
import { deployNGOFactoryWithNgo } from "./utils/deploy";

export const stakeStEthFlowTest = function () {
  const amountInETH = parseEther(ETH_AMOUNT.toString());
  const anotherAmountInETH = parseEther(ANOTHER_ETH_AMOUNT.toString());
  const ngoPercentMultiplier = NGO_PERCENT * PERCENT_MULTIPLIER;

  /*-------------------------------------- Positive cases ---------------------------------------- */

  describe("Positive cases", () => {
    it("should CHANGE current balance from Lido", async function () {
      const { ngo, owner, otherAccount, lidoSC, wStEth } = await loadFixture(
        deployNGOFactoryWithNgo
      );

      await setTokenBalance(
        owner.address,
        lidoSC.address,
        parseEther("100"),
        4
      );
      await setTokenBalance(
        otherAccount.address,
        lidoSC.address,
        parseEther("100"),
        4
      );

      await lidoSC.approve(ngo.address, parseEther("10000"));
      const stakeTx1 = await ngo.stakeStEth(amountInETH, ngoPercentMultiplier);
      await stakeTx1.wait();

      await lidoSC
        .connect(otherAccount)
        .approve(ngo.address, parseEther("10000"));

      const stakeTx2 = await ngo
        .connect(otherAccount)
        .stakeStEth(anotherAmountInETH, ngoPercentMultiplier);
      await stakeTx2.wait();

      const lidoBalance = await wStEth.balanceOf(ngo.address);
      console.log("lidoBalance -> ", lidoBalance);

      expect(lidoBalance).to.closeTo(
        parseEther(`${ANOTHER_ETH_AMOUNT + ETH_AMOUNT}`),
        1000
      );
    });

    it("should CHANGE current balance from Lido (2 case)", async function () {
      const { ngo, owner, lidoSC } = await loadFixture(deployNGOFactoryWithNgo);

      await setTokenBalance(owner.address, lidoSC.address, parseEther("100"));

      await lidoSC.approve(ngo.address, amountInETH);
      const stakeTx = await ngo.stakeStEth(amountInETH, ngoPercentMultiplier);
      await stakeTx.wait();

      const lidoBalance = await lidoSC.balanceOf(ngo.address);

      await setTokenBalance(owner.address, lidoSC.address, parseEther("100"));

      expect(lidoBalance).to.closeTo(amountInETH, 1000);
    });

    it("should EMIT staked event", async function () {
      const { ngo, owner, lidoSC } = await loadFixture(deployNGOFactoryWithNgo);

      await setTokenBalance(owner.address, lidoSC.address, parseEther("100"));

      await lidoSC.approve(ngo.address, amountInETH);
      const stakeTx = ngo.stakeStEth(amountInETH, ngoPercentMultiplier);

      await expect(stakeTx).to.be.emit(ngo, "Staked");
    });
  });

  /*-------------------------------------- Negative cases ---------------------------------------- */

  describe("Negative cases", () => {
    it("should REVERT if NGO was finished", async () => {
      const { ngo } = await loadFixture(deployNGOFactoryWithNgo);

      const finishNgoTx = await ngo.endNGO();
      await finishNgoTx.wait();

      await expect(
        ngo.stakeStEth(amountInETH, ngoPercentMultiplier)
      ).to.revertedWithCustomError(ngo, "NgoFinished");
    });
    it("should REVERT user banned", async () => {
      const { ngo, otherAccount } = await loadFixture(deployNGOFactoryWithNgo);
      await ngo.setUserBan(otherAccount.address, true);

      await expect(
        ngo.connect(otherAccount).stakeStEth(amountInETH, ngoPercentMultiplier)
      ).to.revertedWithCustomError(ngo, "UserBanned");
    });
  });
};

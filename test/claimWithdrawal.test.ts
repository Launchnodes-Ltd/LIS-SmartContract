import { loadFixture } from "@nomicfoundation/hardhat-network-helpers";
import { deployNGOFactoryWithNgo } from "./utils/deploy";
import {
  ETH_AMOUNT,
  NGO_PERCENT,
  PERCENT_MULTIPLIER,
  ONE_ETH,
} from "./utils/constants";
import { parseEther } from "ethers/lib/utils";
import { network } from "hardhat";
import { expect } from "chai";
import { setTokenBalance } from "./utils/utils";

const amountInETH = parseEther(ETH_AMOUNT.toString());
const oneEth = parseEther(ONE_ETH.toString());
const ngoPercentMultiplier = NGO_PERCENT * PERCENT_MULTIPLIER;

export const claimWithdrawalTest = function () {
  /*-------------------------------------- Positive cases ---------------------------------------- */

  describe("Positive cases", () => {
    it("should POSSIBLE to claim withdrawal", async () => {
      const { ngo, withdrawalSc, wStEth } = await loadFixture(
        deployNGOFactoryWithNgo
      );

      await network.provider.send("hardhat_setBalance", [
        withdrawalSc.address,
        "0x100000000000000000000000000000",
      ]);

      const stakeTx = await ngo.stake(ngoPercentMultiplier, {
        value: amountInETH,
      });
      await stakeTx.wait();

      await wStEth.simulateRewards(10);
      await ngo.handleNGOShareDistribution();

      await ngo.requestWithdrawals(oneEth, 1);

      await withdrawalSc.approveRequest(0);

      await expect(ngo.claimWithdrawal(0)).to.be.emit(ngo, "WithdrawClaimed");
    });

    it("should POSSIBLE to claim in St eth", async () => {
      const { ngo, withdrawalSc, wStEth, owner, lidoSC, otherAccount } =
        await loadFixture(deployNGOFactoryWithNgo);

      await network.provider.send("hardhat_setBalance", [
        withdrawalSc.address,
        "0x100000000000000000000000000000",
      ]);

      await setTokenBalance(
        owner.address,
        lidoSC.address,
        parseEther("100"),
        4
      );

      const stakeTx = await ngo.stake(ngoPercentMultiplier, {
        value: amountInETH,
      });
      await stakeTx.wait();
      const userBalanceBefore = await wStEth.balanceOf(ngo.address);
      await ngo.claimWithdrawInStEth(oneEth, 1);

      const userBalanceAfter = await wStEth.balanceOf(ngo.address);
      expect(userBalanceBefore).to.greaterThan(userBalanceAfter);
    });

    it("should EMIT event in withdraw Steth", async () => {
      const { ngo, withdrawalSc, wStEth, owner, lidoSC, otherAccount } =
        await loadFixture(deployNGOFactoryWithNgo);

      await network.provider.send("hardhat_setBalance", [
        withdrawalSc.address,
        "0x100000000000000000000000000000",
      ]);

      await setTokenBalance(
        owner.address,
        lidoSC.address,
        parseEther("100"),
        4
      );

      const stakeTx = await ngo.stake(ngoPercentMultiplier, {
        value: amountInETH,
      });
      await stakeTx.wait();

      await expect(ngo.claimWithdrawInStEth(oneEth, 1)).to.be.emit(
        ngo,
        "WithdrawERC20Claimed"
      );
    });

    it("should EMIT event in withdraw WstETh", async () => {
      const { ngo, withdrawalSc, wStEth, owner, lidoSC, otherAccount } =
        await loadFixture(deployNGOFactoryWithNgo);

      await network.provider.send("hardhat_setBalance", [
        withdrawalSc.address,
        "0x100000000000000000000000000000",
      ]);

      await setTokenBalance(
        owner.address,
        lidoSC.address,
        parseEther("100"),
        4
      );

      const stakeTx = await ngo.stake(ngoPercentMultiplier, {
        value: amountInETH,
      });
      await stakeTx.wait();

      await expect(ngo.claimWithdrawInWStEth(oneEth, 1)).to.be.emit(
        ngo,
        "WithdrawERC20Claimed"
      );
    });
  });

  /*-------------------------------------- Negative case ---------------------------------------- */

  describe("Negative cases", () => {
    it("should REVERT if invalid request id", async () => {
      const { ngo, wStEth, otherAccount } = await loadFixture(
        deployNGOFactoryWithNgo
      );
      const stakeTx = await ngo.stake(ngoPercentMultiplier, {
        value: amountInETH,
      });
      await stakeTx.wait();

      await wStEth.simulateRewards(10);

      await ngo.requestWithdrawals(oneEth, 1);

      await expect(
        ngo.connect(otherAccount).claimWithdrawal(0)
      ).to.revertedWithCustomError(ngo, "InvalidRequestIdForUser");
    });

    it("should REVERT if status not finilized", async () => {
      const { ngo } = await loadFixture(deployNGOFactoryWithNgo);

      const stakeTx = await ngo.stake(ngoPercentMultiplier, {
        value: amountInETH,
      });
      await stakeTx.wait();

      await ngo.requestWithdrawals(oneEth, 1);

      await expect(ngo.claimWithdrawal(0)).to.revertedWithCustomError(
        ngo,
        "NotFinalizedStatus"
      );
    });

    it("should REVERT if amount > userBalance in withdraw WstETh", async () => {
      const { ngo, withdrawalSc, wStEth, owner, lidoSC, otherAccount } =
        await loadFixture(deployNGOFactoryWithNgo);

      await network.provider.send("hardhat_setBalance", [
        withdrawalSc.address,
        "0x100000000000000000000000000000",
      ]);

      await setTokenBalance(
        owner.address,
        lidoSC.address,
        parseEther("100"),
        4
      );

      const stakeTx = await ngo.stake(ngoPercentMultiplier, {
        value: amountInETH,
      });
      await stakeTx.wait();

      await expect(
        ngo.claimWithdrawInWStEth(amountInETH.add(oneEth), 1)
      ).to.revertedWithCustomError(ngo, "RequestAmountTooLarge");
    });
  });

  it("should REVERT if amount > userBalance in withdraw stEth", async () => {
    const { ngo, withdrawalSc, wStEth, owner, lidoSC, otherAccount } =
      await loadFixture(deployNGOFactoryWithNgo);

    await network.provider.send("hardhat_setBalance", [
      withdrawalSc.address,
      "0x100000000000000000000000000000",
    ]);

    await setTokenBalance(owner.address, lidoSC.address, parseEther("100"), 4);

    const stakeTx = await ngo.stake(ngoPercentMultiplier, {
      value: amountInETH,
    });
    await stakeTx.wait();

    await expect(
      ngo.claimWithdrawInStEth(amountInETH.add(oneEth), 1)
    ).to.revertedWithCustomError(ngo, "RequestAmountTooLarge");
  });

  it("should REVERT to claim wsEth if zero amount", async () => {
    const { ngo, withdrawalSc, owner, lidoSC } = await loadFixture(
      deployNGOFactoryWithNgo
    );

    await network.provider.send("hardhat_setBalance", [
      withdrawalSc.address,
      "0x100000000000000000000000000000",
    ]);

    await setTokenBalance(owner.address, lidoSC.address, parseEther("100"), 4);

    const stakeTx = await ngo.stake(ngoPercentMultiplier, {
      value: amountInETH,
    });
    await stakeTx.wait();

    await expect(ngo.claimWithdrawInStEth(0, 1)).to.revertedWithCustomError(
      ngo,
      "ZeroAmount"
    );
  });

  it("should REVERT to claim stEth if zero amount", async () => {
    const { ngo, withdrawalSc, wStEth, owner, lidoSC, otherAccount } =
      await loadFixture(deployNGOFactoryWithNgo);

    await network.provider.send("hardhat_setBalance", [
      withdrawalSc.address,
      "0x100000000000000000000000000000",
    ]);

    await setTokenBalance(owner.address, lidoSC.address, parseEther("100"), 4);

    const stakeTx = await ngo.stake(ngoPercentMultiplier, {
      value: amountInETH,
    });
    await stakeTx.wait();

    await expect(ngo.claimWithdrawInWStEth(0, 1)).to.revertedWithCustomError(
      ngo,
      "ZeroAmount"
    );
  });
};

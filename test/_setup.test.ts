import { claimWithdrawalTest } from "./claimWithdrawal.test";
import { handleNgoShareTest } from "./handleNgoShare.test";
import { factoryTestFlow } from "./ngoFactory.test";
import { requestWithdrawalsTest } from "./requestWithdrawals.test";
import { stakeFlowTest } from "./stake.test";
import { stakeStEthFlowTest } from "./stakeStEth.test";
import { stakeWStEthFlowTest } from "./stakeWstEth.test";
import { upgradeFlowTest } from "./upgrade.test";

describe("NGO Tests", function () {
  describe("Staking", stakeFlowTest);
  describe("Staking wStEth", stakeWStEthFlowTest);
  describe("Stake stEth", stakeStEthFlowTest);

  describe("Handle NGO share distribution", handleNgoShareTest);
  describe("Upgrade", upgradeFlowTest);
  describe("Factory", factoryTestFlow);
  describe("Request withdrawals", requestWithdrawalsTest);
  describe("Claim withdrawal", claimWithdrawalTest);
});

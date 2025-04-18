// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "../interfaces/ILido.sol";
import "../interfaces/IWithdrawalQueue.sol";

import "@openzeppelin/contracts/utils/math/Math.sol";

import "@openzeppelin/contracts-upgradeable/token/ERC721/utils/ERC721HolderUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/ReentrancyGuardUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

import "hardhat/console.sol";
/**
 * @title NGOLis
 * @dev The NGOLis contract manages staking and withdrawal functionalities for a Non-Governmental Organization (NGO). It interacts with the Lido Finance protocol for staking and withdrawal queue for managing withdrawals.
 */
contract NGOLisV2 is
    Initializable,
    ERC721HolderUpgradeable,
    ReentrancyGuardUpgradeable,
    UUPSUpgradeable,
    OwnableUpgradeable
{
    using Math for uint256;
    /**
     * @dev Struct representing stake information for a user.
     */
    struct StakeInfo {
        uint16 percent;
        uint amount;
        uint startDate;
    }

    /**
     * @dev Emitted when a user stakes funds in the NGO.
     * @param _staker The address of the user staking funds.
     * @param _amountStaked The amount of funds staked.
     * @param _percentShare The percentage share of the NGO.
     * @param _ngo The address of the NGO contract.
     * @param _startDate The timestamp when the staking started.
     * @param _timestamp The block timestamp of the staking started.
     * @param _blockNumber The block number of the staking started.
     */
    event Staked(
        uint _id,
        address _staker,
        uint256 _amountStaked,
        uint16 _percentShare,
        address _ngo,
        uint _startDate,
        uint _timestamp,
        uint _blockNumber
    );

    /**
     * @dev Emitted when the rewards for the NGO are updated.
     * @param _rewardsPool The total rewards in the pool.
     * @param stakedBalance The total staked balance in the NGO.
     * @param totalShare The total share of the NGO.
     * @param _dateRecountRewards The timestamp when the rewards were last updated.
     * @param _timestamp The block timestamp when rewards was updated.
     * @param _blockNumber The block number when rewards was updated.
     */
    event RewardsUpdated(
        uint _rewardsPool,
        uint stakedBalance,
        uint totalShare,
        uint _dateRecountRewards,
        uint _timestamp,
        uint _blockNumber
    );

    /**
     * @dev Emitted when a user requests a withdrawal.
     * @param _staker The address of the user requesting withdrawal.
     * @param _ngo The address of the NGO contract.
     * @param _requestId The ID of the withdrawal request.
     * @param _timestamp The block timestamp when withdraw was requested.
     * @param _blockNumber The block number when withdraw was requested.
     */
    event WithdrawRequested(
        address _staker,
        address _ngo,
        uint _requestId,
        uint _timestamp,
        uint _blockNumber,
        uint _stakeId
    );

    /**
     * @dev Emitted when a user claims a withdrawal.
     * @param _claimer The address of the user claiming withdrawal.
     * @param _ngo The address of the NGO contract.
     * @param _amount The amount of ETH claimed.
     * @param _requestId The ID of the withdrawal request.
     * @param _timestamp The block timestamp when withdraw was claimed.
     * @param _blockNumber The block number when withdraw was claimed.
     */
    event WithdrawClaimed(
        address _claimer,
        address _ngo,
        uint _amount,
        uint _requestId,
        uint _timestamp,
        uint _blockNumber
    );

    /**
     * @dev Emitted when the NGO is finished.
     * @param _ngo The address of the NGO contract.
     * @param _timestamp The timestamp when the NGO was finished.
     * @param _blockNumber The block number when the NGO was finished.
     */
    event NGOFinished(address _ngo, uint256 _timestamp, uint _blockNumber);

    /**
     * @dev Error indicating an invalid percentage value.
     */
    error InvalidPercent();

    /**
     * @dev Error indicating that the sender is not the owner of the NGO.
     */
    error NotNgoOwner();

    /**
     * @dev Error indicating that the required time has not passed.
     *  @param _currentTime The current block timestamp.
     *  @param _needTime The staking duration.
     *  @param _startDate The start staking date.
     */
    error TimeNotPassed(uint _currentTime, uint _needTime, uint _startDate);

    /**
     * @dev Error indicating that the user has not staked funds.
     */
    error NotStaked();

    /**
     * @dev Error indicating that the user has not owned this request.
     */
    error InvalidRequestIdForUser(address _claimer, uint256 _requestId);

    /**
     * @dev Error indicating insufficient staked funds for a withdrawal.
     */
    error InsufficientStakedFunds();

    /**
     * @dev Error indicating that only the owner or oracle can perform the operation.
     */
    error OnlyOracle(address _sender);

    /**
     * @dev Error indicating that the NGO has already finished.
     */
    error NgoFinished();

    /**
     * @dev Error indicating an issue with the withdrawal process.
     */
    error WithdrawError();

    /**
     * @dev Modifier to restrict access to only the owner or oracle.
     */
    modifier onlyOracle() {
        if (!_oracles[msg.sender]) {
            revert OnlyOracle(msg.sender);
        }
        _;
    }

    /**
     * @dev Modifier to check if the NGO has finished.
     */
    modifier notFinished() {
        if (isFinish) {
            revert NgoFinished();
        }
        _;
    }

    /**
     * @dev Modifier to check valid stake info.
     */
    modifier validStake(uint16 _ngoPercent) {
        if (
            _ngoPercent < MIN_SHARE_PERCENT || _ngoPercent > MAX_SHARE_PERCENT
        ) {
            revert InvalidPercent();
        }

        _;
    }

    /**
     * @dev Constant representing the minimum share percentage.
     */
    uint16 constant MIN_SHARE_PERCENT = 100;

    /**
     * @dev Constant representing the maximum share percentage.
     */
    uint16 constant MAX_SHARE_PERCENT = 10000;

    /**
     * @dev Constant representing the percentage divider.
     */
    uint constant PERCENT_DIVIDER = 10000;

    /**
     * @dev Constant representing the LIS fee percentage.
     */
    uint constant LIS_FEE = 500;

    /**
     * @dev Storage variable for the total staked balance.
     */
    uint public stakedBalance;

    /**
     * @dev Storage variable for the previous rewards.
     */
    uint private _prevRewards = 0;

    /**
     * @dev Storage variable for the total share of funds today.
     */
    uint private totalShareToday;

    /**
     * @dev Storage variable for the timestamp when rewards were last counted.
     */
    uint private lastCountRewardsTimestamp;

    /**
     * @dev Storage variable for the previous rewards.
     */
    uint private prevRewards = 0;

    /**
     * @dev Total shares for all staked users.
     */
    uint private totalShares;

    /**
     * @dev Storage variable for converting assets to shares.
     */
    uint private totalAssets;

    /**
     * @dev Storage variable for id of stake.
     */
    uint private id;

    /**
     * @dev Storage variable for the address of the LIS token contract.
     */
    address private _lis;

    /**
     * @dev Storage variable for the Lido Smart Contract interface.
     */
    ILido public lidoSC;

    /**
     * @dev Storage variable for the Withdrawal Queue Smart Contract interface.
     */
    IWithdrawalQueue public withdrawalSC;

    /**
     * @dev Storage variable for the address of the rewards owner.
     */
    address public rewardsOwner;

    /**
     * @dev Storage variable indicating whether the NGO has finished.
     */
    bool public isFinish;

    /**
     * @dev Mapping to store stake information for each user.
     */
    mapping(address => mapping(uint => StakeInfo)) private _userToStakeInfo;

    /**
     * @dev Mapping to store information for each oracles.
     */
    mapping(address => bool) private _oracles;

    /**
     * @dev Mapping to store historical rewards data.
     */
    mapping(uint => uint) private _historyRewards;

    /**
     * @dev Mapping to store historical total share data.
     */
    mapping(uint => uint) private _historyStakedBalance;

    /**
     * @dev Mapping to store historical balance data.
     */
    mapping(uint => uint) private _historyBalance;

    /**
     * @dev Mapping to store lido request id for users.
     */
    mapping(uint => address) private _requestIdToUser;

    /**
     * @dev Mapping to shares for specific user.
     */
    mapping(address => mapping(uint => uint)) shares;

    /**
     * @dev Initializes the NGO contract with required parameters.
     * @param lidoSCAddress The address of the Lido Smart Contract.
     * @param _rewardOwnerAddress The address of the rewards owner.
     * @param withdrawalSCAddress The address of the Withdrawal Queue Smart Contract.
     */
    function initialize(
        address lidoSCAddress,
        address _rewardOwnerAddress,
        address withdrawalSCAddress,
        address owner,
        address oracle
    ) public initializer {
        __ERC721Holder_init();
        __UUPSUpgradeable_init();
        __Ownable_init(owner);
        _oracles[oracle] = true;
        _lis = msg.sender;
        lidoSC = ILido(lidoSCAddress);
        withdrawalSC = IWithdrawalQueue(withdrawalSCAddress);
        rewardsOwner = _rewardOwnerAddress;
        lastCountRewardsTimestamp = getRoundDate(block.timestamp);

        id = 1;
    }

    /**
     * @dev Upgrades version of NGO contract.
     * @param newImplementation The address of the new implementation.
     */

    function _authorizeUpgrade(
        address newImplementation
    ) internal override onlyOwner {}

    /**
     * @dev Converts user amount to shares.
     * @param assets The amount of assets.
     * @return The amount of shares.
     */
    function convertAssetsToShares(
        uint256 assets
    ) private view returns (uint256) {
        if (totalShares == 0) {
            return assets;
        }
        return (assets * totalShares) / totalAssets;
    }

    /**
     * @dev Stakes funds in the NGO.
     * @notice Emit [Staked()](#staked) event
     * @param _ngoPercent The percentage share of the NGO.
     */
    function stake(
        uint16 _ngoPercent
    ) public payable notFinished validStake(_ngoPercent) {
        totalAssets = getCurrentBalanceFromLido();

        lidoSC.submit{value: msg.value}(address(this));

        uint256 balanceAfterStaked = getCurrentBalanceFromLido();

        uint256 assets = balanceAfterStaked - totalAssets;

        _userToStakeInfo[msg.sender][id] = StakeInfo({
            percent: _ngoPercent,
            amount: assets,
            startDate: block.timestamp
        });

        uint256 share = convertAssetsToShares(assets);

        if (totalShares == 0) {
            totalShares += 1000;
            shares[address(0)][id] += 1000;
            share -= 1000;
        }
        shares[msg.sender][id] += share;
        totalShares += share;
        stakedBalance += assets;
        totalShareToday += (assets * (_ngoPercent)) / PERCENT_DIVIDER;

        emit Staked(
            id,
            msg.sender,
            assets,
            _ngoPercent,
            address(this),
            lastCountRewardsTimestamp,
            block.timestamp,
            block.number
        );

        id++;
    }

    /**
     * @dev Stakes stETH in the NGO.
     * @notice Emit [Staked()](#staked) event
     * @param amount The amount of stETH to transfer
     * @param _ngoPercent The percentage share of the NGO.
     */
    function stakeStEth(
        uint256 amount,
        uint16 _ngoPercent
    ) public notFinished validStake(_ngoPercent) {
        totalAssets = getCurrentBalanceFromLido();

        lidoSC.transferFrom(msg.sender, address(this), amount);
        uint256 balanceAfterStaked = getCurrentBalanceFromLido();

        uint256 assets = balanceAfterStaked - totalAssets;

        _userToStakeInfo[msg.sender][id] = StakeInfo({
            percent: _ngoPercent,
            amount: amount,
            startDate: block.timestamp
        });

        uint256 share = convertAssetsToShares(assets);

        if (totalShares == 0) {
            totalShares += 1000;
            shares[address(0)][id] += 1000;
            share -= 1000;
        }
        shares[msg.sender][id] += share;
        totalShares += share;
        stakedBalance += assets;

        totalShareToday += (amount * (_ngoPercent)) / PERCENT_DIVIDER;

        emit Staked(
            id,
            msg.sender,
            amount,
            _ngoPercent,
            address(this),
            lastCountRewardsTimestamp,
            block.timestamp,
            block.number
        );

        id++;
    }

    /**
     * @dev Handles the distribution of NGO share based on staking.
     * @notice Emit [RewardsUpdated()](#rewardsupdated) event
     */
    function handleNGOShareDistribution() public onlyOracle {
        // if (block.timestamp < lastCountRewardsTimestamp)
        //     revert TimeNotPassed(block.timestamp, lastCountRewardsTimestamp, 0);

        uint currentBalance = getCurrentBalanceFromLido();

        uint256 _rewardsForToday = currentBalance - stakedBalance - prevRewards;

        uint256 shareToNgo = (totalShareToday * PERCENT_DIVIDER) /
            stakedBalance;

        uint256 _lisFee = (shareToNgo * LIS_FEE) / PERCENT_DIVIDER;

        lidoSC.transfer(_lis, _lisFee);

        lidoSC.transfer(rewardsOwner, shareToNgo - _lisFee);

        _historyRewards[lastCountRewardsTimestamp] = _rewardsForToday;
        _historyStakedBalance[lastCountRewardsTimestamp] = stakedBalance;
        _historyBalance[lastCountRewardsTimestamp] = currentBalance;

        emit RewardsUpdated(
            _rewardsForToday,
            stakedBalance,
            totalShareToday,
            lastCountRewardsTimestamp,
            block.timestamp,
            block.number
        );

        lastCountRewardsTimestamp += 1 hours;

        prevRewards = _rewardsForToday;
    }

    /**
     * @dev Requests withdrawal of funds from the NGO.
     * @param _amount The amount of funds to be withdrawn.
     * @param _id The id of stake.
     * @notice Emit [WithdrawRequested()](#withdrawrequested) event
     */
    function requestWithdrawals(uint256 _amount, uint _id) public {
        StakeInfo storage stakeInfo = _userToStakeInfo[msg.sender][_id];
        uint currentBalance = getCurrentBalanceFromLido();
        uint256 userBalance = getUserBalance(msg.sender, _id);

        if (stakeInfo.amount == 0) {
            revert NotStaked();
        }
        if (userBalance < _amount) {
            revert InsufficientStakedFunds();
        }

        uint rewards = userBalance - stakeInfo.amount;

        uint256 amountInShares = _amount.mulDiv(
            totalShares + 1,
            currentBalance
        );

        if (_amount == userBalance) {
            shares[msg.sender][_id] = 0;
        } else {
            shares[msg.sender][_id] -= amountInShares;
        }

        if (_amount > rewards) {
            stakeInfo.amount -= (_amount - rewards);
            stakedBalance -= (_amount - rewards);
        }

        uint256[] memory _amounts = new uint256[](1);

        _amounts[0] = _amount;

        lidoSC.approve(address(withdrawalSC), _amount);

        uint256[] memory _requestsIds = withdrawalSC.requestWithdrawals(
            _amounts,
            address(this)
        );

        totalShares -= amountInShares;

        _requestIdToUser[_requestsIds[0]] = msg.sender;

        totalShareToday -= (_amount * stakeInfo.percent) / PERCENT_DIVIDER;

        emit WithdrawRequested(
            msg.sender,
            address(this),
            _requestsIds[0],
            block.timestamp,
            block.number,
            _id
        );
    }

    /**
     * @dev Claims the withdrawal of funds from the NGO.
     * @param _requestId The ID of the withdrawal request.
     * @notice Emit [WithdrawClaimed()](#withdrawclaimed) event
     */
    function claimWithdrawal(uint256 _requestId) public nonReentrant {
        if (_requestIdToUser[_requestId] != msg.sender) {
            revert InvalidRequestIdForUser(msg.sender, _requestId);
        }

        uint256[] memory _requestsIds = new uint256[](1);
        _requestsIds[0] = _requestId;

        IWithdrawalQueue.WithdrawalRequestStatus memory status = withdrawalSC
            .getWithdrawalStatus(_requestsIds)[0];

        require(status.isFinalized, "The request is not available for claim");

        withdrawalSC.claimWithdrawal(_requestId);

        payable(msg.sender).transfer(status.amountOfStETH);

        emit WithdrawClaimed(
            msg.sender,
            address(this),
            status.amountOfStETH,
            _requestId,
            block.timestamp,
            block.number
        );
    }

    /**
     * @dev Ends the NGO and marks it as finished.
     * @notice Emit [NGOFinished()](#ngofinished) event
     */
    function endNGO() public notFinished onlyOwner {
        isFinish = true;

        emit NGOFinished(address(this), block.timestamp, block.number);
    }

    /**
     * @dev Gets the user's share of funds in the NGO.
     * @param _user The address of the user.
     * @param _id The id of stake.
     * @return userTotal The user's share rewards.
     */
    function getUserBalance(
        address _user,
        uint _id
    ) public view returns (uint256 userTotal) {
        StakeInfo memory stakedInfo = _userToStakeInfo[_user][_id];
        uint currentBalance = getCurrentBalanceFromLido();
        uint rewardToNgo;

        if (shares[_user][_id] == 0) {
            return stakedInfo.amount;
        }

        if (currentBalance == 0) {
            return 0;
        }

        uint256 userTotalShareWithNgoReward = shares[_user][_id].mulDiv(
            currentBalance,
            totalShares
        );

        if (userTotalShareWithNgoReward < stakedInfo.amount) {
            return stakedInfo.amount;
        }

        rewardToNgo =
            ((((shares[_user][_id] * currentBalance) / totalShares) -
                stakedInfo.amount) * stakedInfo.percent) /
            PERCENT_DIVIDER;

        userTotal = userTotalShareWithNgoReward - rewardToNgo;

        return (userTotal);
    }

    /**
     * @dev Retrieves the rounded date for a given timestamp.
     * @param _timestamp The timestamp for which the rounded date is needed.
     * @return Rounded timestamp representing the start of the day.
     */
    function getRoundDate(uint _timestamp) private pure returns (uint) {
        return (_timestamp / 1 days) * 1 days;
    }

    /**
     * @dev Retrieves stake information for a specific user.
     * @param _user The address of the user for whom stake information is requested.
     * @param _id The id of stake.
     * @return _userStakeInfo The stake information for the specified user.
     * @notice This function allows querying stake information for a specific stake.
     */
    function getUserStakeInfo(
        address _user,
        uint _id
    ) public view returns (StakeInfo memory _userStakeInfo) {
        return _userToStakeInfo[_user][_id];
    }

    /**
     * @dev Retrieves historical data for a specific timestamp.
     * @param _timestamp The timestamp for which historical data is requested.
     * @return _reward The historical rewards at the specified timestamp.
     * @return _totalShares The historical total shares at the specified timestamp.
     * @return _balance The historical balance at the specified timestamp.
     * @notice This function allows querying historical data, including rewards, total shares, and balance,
     * for a specific timestamp. The timestamp is rounded to the start of the day for accurate retrieval.
     */
    function getHistoryData(
        uint256 _timestamp
    ) public view returns (uint _reward, uint _totalShares, uint _balance) {
        uint _roundedTimestamp = getRoundDate(_timestamp);

        return (
            _historyRewards[_roundedTimestamp],
            _historyStakedBalance[_roundedTimestamp],
            _historyBalance[_roundedTimestamp]
        );
    }

    function setOracle(address _newOracle, bool _state) public onlyOwner {
        _oracles[_newOracle] = _state;
    }

    /**
     * @dev Retrieves the current balance of the contract from the Lido contract.
     * @return Current balance of the contract in stETH.
     */
    function getCurrentBalanceFromLido() public view returns (uint256) {
        return lidoSC.balanceOf(address(this));
    }

    function getNGOLisV2() public pure returns (string memory) {
        return "This is NGOLIs V2";
    }

    function anotherNGOLisV2Fn() public pure returns (string memory) {
        return "This is another NGOLIs V2 function";
    }

    receive() external payable {}
}

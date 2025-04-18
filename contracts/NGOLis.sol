// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "./interfaces/ILido.sol";
import "./interfaces/IWstEth.sol";
import "./interfaces/IWithdrawalQueue.sol";

import "@openzeppelin/contracts/utils/math/Math.sol";

import "@openzeppelin/contracts-upgradeable/token/ERC721/utils/ERC721HolderUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/ReentrancyGuardUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

/**
 * @title NGOLis
 * @dev The NGOLis contract manages staking and withdrawal functionalities for a Non-Governmental Organization (NGO). It interacts with the Lido Finance protocol for staking and withdrawal queue for managing withdrawals.
 */
contract NGOLis is
    Initializable,
    ERC721HolderUpgradeable,
    ReentrancyGuardUpgradeable,
    UUPSUpgradeable,
    OwnableUpgradeable
{
    using Math for uint256;
    /**
     * @dev Struct representing initial stake information for a user.
     */
    struct StakeInfo {
        uint16 percent;
        uint256 amount;
        uint256 startDate;
    }

    /*------------------------------------------------ Events -------------------------------------------------------------*/

    /**
     * @dev Emitted when a user stakes funds in the NGO.
     * @param _id The id of the user's stake.
     * @param _staker The address of the user staking funds.
     * @param _amountStaked The amount of funds staked.
     * @param _percentShare The percentage share of the NGO.
     * @param _ngo The address of the NGO contract.
     * @param _timestamp The block timestamp of the staking started.
     * @param _blockNumber The block number of the staking started.
     * @param _ethType Type of eth.
     * @notice _amountStaked  might be in Eth or stEth or WStEth depending on _ethType.
     * @notice if _ethType = 0 then amount of Eth is passed.
     * @notice if _ethType = 1 then amount of stEth is passed.
     * @notice if _ethType = 2 then amount of WStEth is passed.
     */
    event Staked(
        uint256 _id,
        address _staker,
        uint256 _amountStaked,
        uint16 _percentShare,
        address _ngo,
        uint256 _timestamp,
        uint256 _blockNumber,
        EthType _ethType
    );

    /**
     * @dev Emitted when the rewards for the NGO are updated.
     * @param _totalNGOAssets Amount of tokens in the NGO pool.
     * @param _timestamp The block timestamp when rewards was updated.
     * @param _blockNumber The block number when rewards was updated.
     * @notice rewards which are produced in the NGO pool are being transfered to social impact
     */
    event RewardsUpdated(
        uint256 _totalNGOAssets,
        uint256 _timestamp,
        uint256 _blockNumber
    );

    /**
     * @dev Emitted when a user requests a withdrawal.
     * @param _staker The address of the user requesting withdrawal.
     * @param _ngo The address of the NGO contract.
     * @param _requestId The ID of the withdrawal request.
     * @param _timestamp The block timestamp when withdraw was requested.
     * @param _blockNumber The block number when withdraw was requested.
     * @param _stakeId The id of the stake.
     */
    event WithdrawRequested(
        address _staker,
        address _ngo,
        uint256 _requestId,
        uint256 _timestamp,
        uint256 _blockNumber,
        uint256 _stakeId
    );

    /**
     * @dev Emitted when a user claims a withdrawal.
     * @param _claimer The address of the user claiming withdrawal.
     * @param _ngo The address of the NGO contract.
     * @param _amount The amount requested for withdrawal.
     * @param _requestId The ID of the withdrawal request.
     * @param _timestamp The block timestamp when withdraw was claimed.
     * @param _blockNumber The block number when withdraw was claimed.
     */
    event WithdrawClaimed(
        address _claimer,
        address _ngo,
        uint256 _amount,
        uint256 _requestId,
        uint256 _timestamp,
        uint256 _blockNumber
    );

    /**
     * @dev Emitted when a user claims a withdrawal in stEth.
     * @param _claimer The address of the user claiming withdrawal.
     * @param _ngo The address of the NGO contract.
     * @param _amount The amount of stEth or WStEth claimed.
     * @param _timestamp The block timestamp when withdraw was claimed.
     * @param _blockNumber The block number when withdraw was claimed.
     * @param _stakeId The id of the stake.
     * @param _ethType Type of eth.
     * @notice _amount to withdraw might be in stEth or WStEth depending on _ethType.
     * @notice if _ethType = 1 then amount of stEth is passed.
     * @notice if _ethType = 2 then amount of WStEth is passed.
     */
    event WithdrawERC20Claimed(
        address _claimer,
        address _ngo,
        uint256 _amount,
        uint256 _timestamp,
        uint256 _blockNumber,
        uint256 _stakeId,
        EthType _ethType
    );

    /**
     * @dev Event for graph.
     * @param _name The name of the NGO.
     * @param _imageLink The link to the image associated with the NGO.
     * @param _description A description of the NGO.
     * @param _link A link associated with the NGO.
     * @param _location A location of the NGO.
     * @param _ngo The address of the NGO contract.
     * @param _timestamp The block timestamp when withdraw was claimed.
     */
    event GraphEvent(
        string _name,
        string _imageLink,
        string _description,
        string _link,
        string _location,
        address _ngo,
        uint256 _timestamp
    );

    /**
     * @dev Emitted when the NGO is finished.
     * @param _ngo The address of the NGO contract.
     * @param _timestamp The timestamp when the NGO was finished.
     * @param _blockNumber The block number when the NGO was finished.
     */
    event NGOFinished(address _ngo, uint256 _timestamp, uint256 _blockNumber);

    /**
     * @dev Emitted when the oracle was added or status was changed.
     * @param _newOracle New oracle address.
     * @param _state Current oracle state.
     * @notice If state = true - current address active.
     * @notice If state = false - current address deactive.
     */
    event OracleChanged(address _newOracle, bool _state);

    /**
     * @dev Emitted when the rewards owner was changed.
     * @param _newRewOwner New reward owner address.
     */
    event RewardsOwnerChanged(address _newRewOwner);

    /**
     * @dev Emitted when the state of user was changed.
     * @param _userAddress User address.
     * @param _isBan Current user state.
     * @notice If _isBan = true - current user banned.
     * @notice If _isBan = false - current user not banned.
     */
    event BannedUser(address _userAddress, bool _isBan);

    /*------------------------------------------------ Errors -------------------------------------------------------------*/

    /**
     * @dev Error indicating an invalid percentage value.
     */
    error InvalidPercent();

    /**
     * @dev Error indicating an invalid amount value passed (Eth, StEth).
     */
    error InvalidStakeAmount();

    /**
     * @dev Error indicating an invalid withdrawal amount.
     */
    error InvalidWithdrawalAmount();

    /**
     * @dev Error indicating an invalid withdraw amount.
     */
    error InvalidWithdrawAmount();

    /**
     * @dev Error when requested amount too small.
     */
    error RequestAmountTooSmall(uint256 _amount);

    /**
     * @dev Error when requested amount too big.
     */
    error RequestAmountTooLarge(uint256 _amount);

    /**
     * @dev Error indicating that the user has not owned this request.
     */
    error InvalidRequestIdForUser(address _claimer, uint256 _requestId);

    /**
     * @dev Error indicating that the request status is not finilized.
     */
    error NotFinalizedStatus();

    /**
     * @dev Error indicating if address is equal null address.
     */
    error NullAddress();

    /**
     * @dev Error indicating that only oracle can perform the operation.
     */
    error OnlyOracle(address _sender);

    /**
     * @dev Error indicating that the NGO has already been finished.
     */
    error NgoFinished();

    /**
     * @dev Error when user enter amount that equals zero.
     */
    error ZeroAmount();

    /**
     * @dev Error indicating an issue that there are no rewards.
     */
    error RewardError();

    /**
     * @dev Error indicating an issue when amount of WstEth to stake is lower than minimum.
     */
    error MinimumWstEthStakeError();

    /**
     * @dev Error indicating an issue when amount of WstEth to withdraw is lower than minimum.
     */
    error MinimumWstEthWithdrawError();

    /**
     * @dev Error indicating that user is banned.
     */
    error UserBanned();

    /*------------------------------------------------ Modifiers -------------------------------------------------------------*/

    /**
     * @dev Modifier to restrict access to only oracle.
     */
    modifier onlyOracle() {
        if (!_oracles[msg.sender]) {
            revert OnlyOracle(msg.sender);
        }
        _;
    }

    /**
     * @dev Modifier to check if the NGO has been finished.
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
     * @dev Modifier to check is user is banned.
     */
    modifier notBanned() {
        if (_isBanned[msg.sender]) {
            revert UserBanned();
        }
        _;
    }

    /**
     * @dev Modifier to check valid minimum amount for Eth and stEth.
     */
    modifier validAmount(uint256 _amount) {
        if (_amount < MIN_AMOUNT) {
            revert InvalidStakeAmount();
        }
        _;
    }

    /**
     * @dev Modifier to minimum withdrawal amount for StEth.
     */
    modifier validWithdrawalAmount(uint256 _amount) {
        if (_amount < MIN_WITHDRAWAL_AMOUNT) {
            revert InvalidWithdrawalAmount();
        }
        _;
    }

    /*------------------------------------------------ Storage -------------------------------------------------------------*/

    /**
     * @dev Type of eth in function for event
     */
    enum EthType {
        Native,
        StEth,
        WStEth
    }

    /**
     * @dev Constant representing the minimum share percentage.
     */
    uint8 constant MIN_SHARE_PERCENT = 100;

    /**
     * @dev Constant representing the minimum amount to stake.
     */
    uint16 constant MIN_AMOUNT = 1000;

    /**
     * @dev Constant representing the maximum share percentage.
     */
    uint16 constant MAX_SHARE_PERCENT = 10000;

    /**
     * @dev Constant representing the percentage divider.
     */
    uint16 constant PERCENT_DIVIDER = 10000;

    /**
     * @dev Constant representing the percentage divider.
     */
    uint256 constant DIVIDER = 10 * 10 ** 17;

    /**
     * @dev Constant representing the LIS fee percentage.
     */
    uint16 constant LIS_FEE = 500;

    /**
     * @dev Constant representing the minimum withdrawal amount.
     */
    uint8 constant MIN_WITHDRAWAL_AMOUNT = 100;

    /**
     * @dev Constant representing the minimum amount stored for user(wei).
     * @dev If during withdrawal user's balance < WITHDRAW_GAP
     * @dev Remainder amount is transfered with withdrawal amount.
     */
    uint8 constant WITHDRAW_GAP = 100;

    /**
     * @dev Storage variable for id of stake.
     */
    uint256 private _stakeId;

    /**
     * @dev Storage variable for pending rewards to NGO.
     */
    uint256 private _pendingNGORewards;

    /**
     * @dev Storage variable for the address of the LIS smart contract.
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
     * @dev Mapping to store initial stake information for each user.
     */
    mapping(address => mapping(uint256 => StakeInfo)) private _userToStakeInfo;

    /**
     * @dev Mapping to store information for each oracles.
     */
    mapping(address => bool) private _oracles;

    /**
     * @dev Mapping to store lido request id for users.
     */
    mapping(uint256 => address) private _requestIdToUser;

    /**
     * @dev Mapping to shares for specific user.
     */
    mapping(address => mapping(uint256 => uint256)) private _ngoShares;

    /**
     * @dev Mapping to store ban indication of user.
     */
    mapping(address => bool) private _isBanned;

    /**
     * @dev Mapping stores the user's wstETH tokens, which are not used for NGO donations.
     */
    mapping(address => mapping(uint256 => uint256)) private _assets;

    /**
     * @dev Defines the total amount of wstETH tokens that generate rewards for the NGO.
     */
    uint256 private _totalNGOAssets;

    /**
     * @dev Defines the total number of NGO shares.
     */
    uint256 private _totalNGOShares;

    /**
     * @dev Variable holds the stETH balance at the time of the last NGO reward distribution.
     */
    uint256 private _lastNGOBalance;

    /**
     * @dev Storage variable for the wrapped stEth Smart Contract interface.
     */
    IWstEth public wstETHSC;

    /*------------------------------------------------ Functions -------------------------------------------------------------*/
    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    receive() external payable {}

    /**
     * @dev Initializes the NGO contract with required parameters.
     * @param _lidoSCAddress The address of the Lido Smart Contract.
     * @param _rewardOwnerAddress The address of the rewards owner.
     * @param _withdrawalSCAddress The address of the Withdrawal Queue Smart Contract.
     * @param _owner The owner/admin of NGO.
     * @param _oracle Oracle address which initiate handleNGOdistribution function on a daily basis.
     * @param _wstETHSC Address of wstETH contract.
     */
    function initialize(
        address _lidoSCAddress,
        address _rewardOwnerAddress,
        address _withdrawalSCAddress,
        address _owner,
        address _oracle,
        address _wstETHSC
    ) public initializer {
        if (_oracle == address(0)) revert NullAddress();
        if (_lidoSCAddress == address(0)) revert NullAddress();
        if (_rewardOwnerAddress == address(0)) revert NullAddress();
        if (_withdrawalSCAddress == address(0)) revert NullAddress();
        if (_wstETHSC == address(0)) revert NullAddress();
        if (_owner == address(0)) revert NullAddress();

        __ERC721Holder_init();
        __UUPSUpgradeable_init();
        __Ownable_init(_owner);
        __ReentrancyGuard_init();
        _oracles[_oracle] = true;
        _lis = msg.sender;
        lidoSC = ILido(_lidoSCAddress);
        wstETHSC = IWstEth(_wstETHSC);
        withdrawalSC = IWithdrawalQueue(_withdrawalSCAddress);
        rewardsOwner = _rewardOwnerAddress;
        _stakeId = 1;
    }

    /**
     * @dev Stakes funds to the NGO.
     * @notice Emit [Staked()](#staked) event
     * @param _ngoPercent The percentage share of the NGO.
     * @notice expected number for _ngoPercent: 100 = 1% (min), 10000 = 100% (max)
     * @notice Minimal amount to stake: 1000 wei
     */
    function stake(
        uint16 _ngoPercent
    )
        public
        payable
        notFinished
        validStake(_ngoPercent)
        validAmount(msg.value)
        notBanned
    {
        uint256 userAmountBefore = wstETHSC.balanceOf(address(this));

        (bool sent, ) = address(wstETHSC).call{value: msg.value}("");
        require(sent, "Failed to send Ether");

        uint256 userAmountAfter = wstETHSC.balanceOf(address(this));

        uint256 userAmount = userAmountAfter - userAmountBefore;

        assetsCalculation(userAmount, _ngoPercent);

        emit Staked(
            _stakeId,
            msg.sender,
            msg.value,
            _ngoPercent,
            address(this),
            block.timestamp,
            block.number,
            EthType.Native
        );

        _stakeId++;
    }

    /**
     * @dev Stakes stETH to the NGO.
     * @notice Emit [Staked()](#staked) event
     * @param _amount The amount of stETH to transfer
     * @param _ngoPercent The percentage share of the NGO.
     * @notice expected number for _ngoPercent: 100 = 1% (min), 10000 = 100% (max)
     * @notice Minimal amount to stake: 1000 wei
     */
    function stakeStEth(
        uint256 _amount,
        uint16 _ngoPercent
    )
        public
        notFinished
        validStake(_ngoPercent)
        validAmount(_amount)
        notBanned
    {
        lidoSC.transferFrom(msg.sender, address(this), _amount);

        lidoSC.approve(address(wstETHSC), _amount);

        uint256 _amountWstETH = wstETHSC.wrap(_amount);

        assetsCalculation(_amountWstETH, _ngoPercent);

        emit Staked(
            _stakeId,
            msg.sender,
            _amount,
            _ngoPercent,
            address(this),
            block.timestamp,
            block.number,
            EthType.StEth
        );

        _stakeId++;
    }

    /**
     * @dev Stakes WStETH to the NGO.
     * @param _amount The amount of WStETH to transfer
     * @param _ngoPercent The percentage share of the NGO.
     * @notice expected number for _ngoPercent: 100 = 1% (min), 10000 = 100% (max)
     * @notice Minimal amount to stake: 1000 wei
     * @notice Emit [Staked()](#staked) event
     */
    function stakeWStEth(
        uint256 _amount,
        uint16 _ngoPercent
    ) public notFinished validStake(_ngoPercent) notBanned {
        if (wstETHSC.getStETHByWstETH(_amount) < MIN_AMOUNT) {
            revert MinimumWstEthStakeError();
        }
        wstETHSC.transferFrom(msg.sender, address(this), _amount);

        assetsCalculation(_amount, _ngoPercent);

        emit Staked(
            _stakeId,
            msg.sender,
            _amount,
            _ngoPercent,
            address(this),
            block.timestamp,
            block.number,
            EthType.WStEth
        );

        _stakeId++;
    }

    /**
     * @dev Handles the distribution of NGO share based on rewards of NGOAssets.
     * @notice Emit [RewardsUpdated()](#rewardsupdated) event
     */
    function handleNGOShareDistribution() public onlyOracle {
        pendingRewardsCalculation();

        if (_pendingNGORewards == 0) {
            revert RewardError();
        }

        uint256 _fee = _pendingNGORewards.mulDiv(LIS_FEE, PERCENT_DIVIDER);

        if (_fee != 0) {
            wstETHSC.transfer(_lis, _fee);
        }

        wstETHSC.transfer(rewardsOwner, _pendingNGORewards - _fee);

        _lastNGOBalance = wstETHSC.getStETHByWstETH(_totalNGOAssets);

        _pendingNGORewards = 0;
        emit RewardsUpdated(_totalNGOAssets, block.timestamp, block.number);
    }

    /**
     * @dev Requests withdrawal of funds from the NGO.
     * @param _amount The amount of funds to be withdrawn.
     * @notice Emit [WithdrawRequested()](#withdrawrequested) event
     * @notice expected amount to withdraw: min - 100 wei , max - 1000 eth.
     */
    function requestWithdrawals(uint256 _amount, uint256 _id) public {
        if (_amount > withdrawalSC.MAX_STETH_WITHDRAWAL_AMOUNT()) {
            revert RequestAmountTooLarge(_amount);
        }

        if (_amount < withdrawalSC.MIN_STETH_WITHDRAWAL_AMOUNT()) {
            revert RequestAmountTooSmall(_amount);
        }

        uint256 _userBalanceInStEth = getUserBalance(msg.sender, _id);
        if (_amount > _userBalanceInStEth) {
            revert RequestAmountTooLarge(_amount);
        }
        uint256 _amountWstETH = withdrawCalculation(
            _amount,
            _id,
            _userBalanceInStEth
        );

        uint256[] memory _amounts = new uint256[](1);
        _amounts[0] = _amountWstETH;
        wstETHSC.approve(address(withdrawalSC), _amountWstETH);
        uint256[] memory _requestIds = withdrawalSC.requestWithdrawalsWstETH(
            _amounts,
            address(this)
        );

        _requestIdToUser[_requestIds[0]] = msg.sender;

        emit WithdrawRequested(
            msg.sender,
            address(this),
            _requestIds[0],
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

        if (!status.isFinalized) {
            revert NotFinalizedStatus();
        }
        uint256[] memory hints = withdrawalSC.findCheckpointHints(
            _requestsIds,
            1,
            withdrawalSC.getLastCheckpointIndex()
        );
        withdrawalSC.claimWithdrawalsTo(_requestsIds, hints, msg.sender);

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
     * @dev Claims the `_amount` of funds in stETH from the NGO.
     * @param _amount Amount of stEth for claiming.
     * @param _id The id of stake.
     * @notice expected amount to withdraw: min - 100 wei.
     * @notice Emit [WithdrawERC20Claimed()](#withdrawerc20claimed) event
     */
    function claimWithdrawInStEth(
        uint256 _amount,
        uint256 _id
    ) public validWithdrawalAmount(_amount) {
        if (_amount == 0) {
            revert ZeroAmount();
        }
        uint256 _userBalanceInStEth = getUserBalance(msg.sender, _id);
        if (_amount > _userBalanceInStEth) {
            revert RequestAmountTooLarge(_amount);
        }
        uint256 _amountWstETH = withdrawCalculation(
            _amount,
            _id,
            _userBalanceInStEth
        );

        uint256 _amountStETHUnwrapped = wstETHSC.unwrap(_amountWstETH);

        lidoSC.transfer(msg.sender, _amountStETHUnwrapped);

        emit WithdrawERC20Claimed(
            msg.sender,
            address(this),
            _amount,
            block.timestamp,
            block.number,
            _id,
            EthType.StEth
        );
    }

    /**
     * @dev Claims the `_amount` of funds in WStETH from the NGO.
     * @param _amount Amount of WStEth for claiming.
     * @param _id The id of stake.
     * @notice expected amount to withdraw: min - 100 wei.
     * @notice Emit [WithdrawERC20Claimed()](#withdrawerc20claimed) event
     */
    function claimWithdrawInWStEth(uint256 _amount, uint256 _id) public {
        uint256 _stEthAmount = wstETHSC.getStETHByWstETH(_amount);

        if (_stEthAmount < MIN_WITHDRAWAL_AMOUNT) {
            revert MinimumWstEthWithdrawError();
        }

        uint256 _userBalanceInStEth = getUserBalance(msg.sender, _id);

        if (_stEthAmount > _userBalanceInStEth) {
            revert RequestAmountTooLarge(_amount);
        }
        uint256 _amountWstETH = withdrawCalculation(
            _stEthAmount,
            _id,
            _userBalanceInStEth
        );

        wstETHSC.transfer(msg.sender, _amountWstETH);

        emit WithdrawERC20Claimed(
            msg.sender,
            address(this),
            _amount,
            block.timestamp,
            block.number,
            _id,
            EthType.WStEth
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
     * @dev Sets new oracle.
     * @param _newOracle Address of new oracle.
     * @param _state Indicator of allowing to be oracle.
     * @notice Emit [OracleChanged()](#oraclechanged) event
     */
    function setOracle(address _newOracle, bool _state) public onlyOwner {
        if (_newOracle == address(0)) revert NullAddress();
        _oracles[_newOracle] = _state;

        emit OracleChanged(_newOracle, _state);
    }

    /**
     * @dev Sets new rewards owner.
     * @param _newRewOwner Address of new rewards owner.
     * @notice Emit [RewardsOwnerChanged()](#rewardsownerchanged) event
     */
    function setRewardsOwner(address _newRewOwner) public onlyOwner {
        if (_newRewOwner == address(0)) revert NullAddress();
        rewardsOwner = _newRewOwner;

        emit RewardsOwnerChanged(_newRewOwner);
    }

    /**
     * @dev Function for banning user.
     * @param _userAddress Adress of user to ban
     * @param _isBan Flag of ban or unban
     * @notice Emit [BannedUser()](#banneduser) event
     */
    function setUserBan(address _userAddress, bool _isBan) public onlyOwner {
        if (_userAddress == address(0)) revert NullAddress();
        _isBanned[_userAddress] = _isBan;

        emit BannedUser(_userAddress, _isBan);
    }

    /**
     * @dev Emits event with data of ngo for graph.
     * @param _name The name of the NGO.
     * @param _imageLink The link to the image associated with the NGO.
     * @param _description A description of the NGO.
     * @param _link A link associated with the NGO.
     * @param _location A location of the NGO.
     * @dev Used for offchain logic.
     */
    function emitEvent(
        string memory _name,
        string calldata _imageLink,
        string calldata _description,
        string calldata _link,
        string calldata _location
    ) public onlyOwner {
        emit GraphEvent(
            _name,
            _imageLink,
            _description,
            _link,
            _location,
            address(this),
            block.timestamp
        );
    }

    /**
     * @dev Retrieves initial stake information for a specific user and stakeID.
     * @param _user The address of the user for whom stake information is requested.
     * @param _id The id of stake.
     * @return _userStakeInfo The initial stake information for the specified user by id.
     * @notice This function allows querying initial stake information for a specific stake.
     * @notice Used for offchain logic.
     */
    function getUserStakeInfo(
        address _user,
        uint256 _id
    ) public view returns (StakeInfo memory _userStakeInfo) {
        return _userToStakeInfo[_user][_id];
    }

    /**
     * @dev Retrieves balance for a specific user.
     * @param _user The address of the user.
     * @param _id The id of stake.
     * @return _userBalance Returns user balance in stETH.
     */
    function getUserBalance(
        address _user,
        uint256 _id
    ) public view returns (uint256 _userBalance) {
        uint256 _ngoShare = _ngoShares[_user][_id];
        uint256 _lastNGOBalanceToWsEth = wstETHSC.getWstETHByStETH(
            _lastNGOBalance
        );
        uint256 _ngoAssets = _ngoShare.mulDiv(
            _lastNGOBalanceToWsEth,
            _totalNGOShares
        );

        _userBalance = _assets[_user][_id] + _ngoAssets;

        _userBalance = wstETHSC.getStETHByWstETH(_userBalance);

        return _userBalance;
    }

    /**
     * @dev Upgrades version of NGO contract.
     * @param newImplementation The address of the new implementation.
     */
    function _authorizeUpgrade(
        address newImplementation
    ) internal override onlyOwner {}

    /**
     * @dev Calculates assets and shares
     * @param _amount amount user wants to stake in WStETH
     * @param _percent The percentage share of the NGO.
     * @notice Used in `stake()` , `stakeStEth()` , `stakeWStEth()`
     */
    function assetsCalculation(uint256 _amount, uint16 _percent) private {
        uint256 _ngoAssets = _amount.mulDiv(_percent, PERCENT_DIVIDER);

        _assets[msg.sender][_stakeId] = _amount - _ngoAssets;

        _userToStakeInfo[msg.sender][_stakeId] = StakeInfo({
            percent: _percent,
            amount: _amount,
            startDate: block.timestamp
        });

        uint256 _ngoShare;

        pendingRewardsCalculation();

        if (_totalNGOAssets == 0) {
            _ngoShare = _ngoAssets;
        } else {
            _ngoShare = _ngoAssets.mulDiv(_totalNGOShares, _totalNGOAssets);
        }

        _totalNGOAssets += _ngoAssets;
        _totalNGOShares += _ngoShare;
        _ngoShares[msg.sender][_stakeId] = _ngoShare;

        _lastNGOBalance = wstETHSC.getStETHByWstETH(_totalNGOAssets);
    }

    /**
     * @dev Private function for calculation and changing state
     * @dev while withdrawing
     * @param _amount The amount of funds to be withdrawn.
     * @param _id The id of stake.
     * @notice Used in `requestWithdrawals()` , `claimWithdrawInStEth()` , `claimWithdrawInWStEth()`
     */
    function withdrawCalculation(
        uint256 _amount,
        uint256 _id,
        uint256 _userBalanceInStEth
    ) private returns (uint256 _amountWstETH) {
        uint256 _ngoShare = _ngoShares[msg.sender][_id];
        pendingRewardsCalculation();
        uint256 _ngoAssets = _ngoShare.mulDiv(_totalNGOAssets, _totalNGOShares);
        uint256 _totalUserWstETH = _assets[msg.sender][_id] + _ngoAssets;

        if (_userBalanceInStEth - _amount < WITHDRAW_GAP) {
            _amountWstETH = wstETHSC.getWstETHByStETH(_userBalanceInStEth);
        } else {
            _amountWstETH = wstETHSC.getWstETHByStETH(_amount);
        }

        uint256 _ratio = _amountWstETH.mulDiv(DIVIDER, _totalUserWstETH);
        if (_ratio == 0) {
            revert InvalidWithdrawAmount();
        }

        _assets[msg.sender][_id] -= _ratio.mulDiv(
            _assets[msg.sender][_id],
            DIVIDER
        );

        uint256 withdrawnNgoAssets = _ngoAssets.mulDiv(_ratio, DIVIDER);

        _totalNGOAssets -= withdrawnNgoAssets;

        _totalNGOShares -= _ngoShare.mulDiv(_ratio, DIVIDER);
        _ngoShares[msg.sender][_id] -= _ngoShare.mulDiv(_ratio, DIVIDER);
        _lastNGOBalance = wstETHSC.getStETHByWstETH(_totalNGOAssets);

        return (_amountWstETH);
    }

    /**
     * @dev Calculates pending rewards to NGO and updates NGO assets.
     * @notice Uses in `handleNGOShareDistribution` , `AssetsCalculation()`, `WithdrawCalculation()`.
     */
    function pendingRewardsCalculation() private {
        uint256 _currentNGOBalance = wstETHSC.getStETHByWstETH(_totalNGOAssets);
        if (_lastNGOBalance < _currentNGOBalance) {
            uint256 _reward = wstETHSC.getWstETHByStETH(
                _currentNGOBalance - _lastNGOBalance
            );
            _pendingNGORewards += _reward;
            _totalNGOAssets -= _reward;
        }
    }
}

# NGOLis



> NGOLis



*The NGOLis contract manages staking and withdrawal functionalities for a Non-Governmental Organization (NGO). It interacts with the Lido Finance protocol for staking and withdrawal queue for managing withdrawals.*

## Methods

### UPGRADE_INTERFACE_VERSION

```solidity
function UPGRADE_INTERFACE_VERSION() external view returns (string)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | string | undefined |

### claimWithdrawInStEth

```solidity
function claimWithdrawInStEth(uint256 _amount, uint256 _id) external nonpayable
```

expected amount to withdraw: min - 100 wei.Emit [WithdrawERC20Claimed()](#withdrawerc20claimed) event

*Claims the `_amount` of funds in stETH from the NGO.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| _amount | uint256 | Amount of stEth for claiming. |
| _id | uint256 | The id of stake. |

### claimWithdrawInWStEth

```solidity
function claimWithdrawInWStEth(uint256 _amount, uint256 _id) external nonpayable
```

expected amount to withdraw: min - 100 wei.Emit [WithdrawERC20Claimed()](#withdrawerc20claimed) event

*Claims the `_amount` of funds in WStETH from the NGO.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| _amount | uint256 | Amount of WStEth for claiming. |
| _id | uint256 | The id of stake. |

### claimWithdrawal

```solidity
function claimWithdrawal(uint256 _requestId) external nonpayable
```

Emit [WithdrawClaimed()](#withdrawclaimed) event

*Claims the withdrawal of funds from the NGO.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| _requestId | uint256 | The ID of the withdrawal request. |

### emitEvent

```solidity
function emitEvent(string _name, string _imageLink, string _description, string _link, string _location) external nonpayable
```



*Emits event with data of ngo for graph.Used for offchain logic.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| _name | string | The name of the NGO. |
| _imageLink | string | The link to the image associated with the NGO. |
| _description | string | A description of the NGO. |
| _link | string | A link associated with the NGO. |
| _location | string | A location of the NGO. |

### endNGO

```solidity
function endNGO() external nonpayable
```

Emit [NGOFinished()](#ngofinished) event

*Ends the NGO and marks it as finished.*


### getUserBalance

```solidity
function getUserBalance(address _user, uint256 _id) external view returns (uint256 _userBalance)
```



*Retrieves balance for a specific user.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| _user | address | The address of the user. |
| _id | uint256 | The id of stake. |

#### Returns

| Name | Type | Description |
|---|---|---|
| _userBalance | uint256 | Returns user balance in stETH. |

### getUserStakeInfo

```solidity
function getUserStakeInfo(address _user, uint256 _id) external view returns (struct NGOLis.StakeInfo _userStakeInfo)
```

This function allows querying initial stake information for a specific stake.Used for offchain logic.

*Retrieves initial stake information for a specific user and stakeID.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| _user | address | The address of the user for whom stake information is requested. |
| _id | uint256 | The id of stake. |

#### Returns

| Name | Type | Description |
|---|---|---|
| _userStakeInfo | NGOLis.StakeInfo | The initial stake information for the specified user by id. |

### handleNGOShareDistribution

```solidity
function handleNGOShareDistribution() external nonpayable
```

Emit [RewardsUpdated()](#rewardsupdated) event

*Handles the distribution of NGO share based on rewards of NGOAssets.*


### initialize

```solidity
function initialize(address _lidoSCAddress, address _rewardOwnerAddress, address _withdrawalSCAddress, address _owner, address _oracle, address _wstETHSC) external nonpayable
```



*Initializes the NGO contract with required parameters.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| _lidoSCAddress | address | The address of the Lido Smart Contract. |
| _rewardOwnerAddress | address | The address of the rewards owner. |
| _withdrawalSCAddress | address | The address of the Withdrawal Queue Smart Contract. |
| _owner | address | The owner/admin of NGO. |
| _oracle | address | Oracle address which initiate handleNGOdistribution function on a daily basis. |
| _wstETHSC | address | Address of wstETH contract. |

### isFinish

```solidity
function isFinish() external view returns (bool)
```



*Storage variable indicating whether the NGO has finished.*


#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bool | undefined |

### lidoSC

```solidity
function lidoSC() external view returns (contract ILido)
```



*Storage variable for the Lido Smart Contract interface.*


#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | contract ILido | undefined |

### onERC721Received

```solidity
function onERC721Received(address, address, uint256, bytes) external nonpayable returns (bytes4)
```



*See {IERC721Receiver-onERC721Received}. Always returns `IERC721Receiver.onERC721Received.selector`.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| _0 | address | undefined |
| _1 | address | undefined |
| _2 | uint256 | undefined |
| _3 | bytes | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bytes4 | undefined |

### owner

```solidity
function owner() external view returns (address)
```



*Returns the address of the current owner.*


#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | address | undefined |

### proxiableUUID

```solidity
function proxiableUUID() external view returns (bytes32)
```



*Implementation of the ERC1822 {proxiableUUID} function. This returns the storage slot used by the implementation. It is used to validate the implementation&#39;s compatibility when performing an upgrade. IMPORTANT: A proxy pointing at a proxiable contract should not be considered proxiable itself, because this risks bricking a proxy that upgrades to it, by delegating to itself until out of gas. Thus it is critical that this function revert if invoked through a proxy. This is guaranteed by the `notDelegated` modifier.*


#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bytes32 | undefined |

### renounceOwnership

```solidity
function renounceOwnership() external nonpayable
```



*Leaves the contract without owner. It will not be possible to call `onlyOwner` functions. Can only be called by the current owner. NOTE: Renouncing ownership will leave the contract without an owner, thereby disabling any functionality that is only available to the owner.*


### requestWithdrawals

```solidity
function requestWithdrawals(uint256 _amount, uint256 _id) external nonpayable
```

Emit [WithdrawRequested()](#withdrawrequested) eventexpected amount to withdraw: min - 100 wei , max - 1000 eth.

*Requests withdrawal of funds from the NGO.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| _amount | uint256 | The amount of funds to be withdrawn. |
| _id | uint256 | undefined |

### rewardsOwner

```solidity
function rewardsOwner() external view returns (address)
```



*Storage variable for the address of the rewards owner.*


#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | address | undefined |

### setOracle

```solidity
function setOracle(address _newOracle, bool _state) external nonpayable
```

Emit [OracleChanged()](#oraclechanged) event

*Sets new oracle.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| _newOracle | address | Address of new oracle. |
| _state | bool | Indicator of allowing to be oracle. |

### setRewardsOwner

```solidity
function setRewardsOwner(address _newRewOwner) external nonpayable
```

Emit [RewardsOwnerChanged()](#rewardsownerchanged) event

*Sets new rewards owner.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| _newRewOwner | address | Address of new rewards owner. |

### setUserBan

```solidity
function setUserBan(address _userAddress, bool _isBan) external nonpayable
```

Emit [BannedUser()](#banneduser) event

*Function for banning user.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| _userAddress | address | Adress of user to ban |
| _isBan | bool | Flag of ban or unban |

### stake

```solidity
function stake(uint16 _ngoPercent) external payable
```

Emit [Staked()](#staked) eventexpected number for _ngoPercent: 100 = 1% (min), 10000 = 100% (max)Minimal amount to stake: 1000 wei

*Stakes funds to the NGO.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| _ngoPercent | uint16 | The percentage share of the NGO. |

### stakeStEth

```solidity
function stakeStEth(uint256 _amount, uint16 _ngoPercent) external nonpayable
```

Emit [Staked()](#staked) eventexpected number for _ngoPercent: 100 = 1% (min), 10000 = 100% (max)Minimal amount to stake: 1000 wei

*Stakes stETH to the NGO.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| _amount | uint256 | The amount of stETH to transfer |
| _ngoPercent | uint16 | The percentage share of the NGO. |

### stakeWStEth

```solidity
function stakeWStEth(uint256 _amount, uint16 _ngoPercent) external nonpayable
```

expected number for _ngoPercent: 100 = 1% (min), 10000 = 100% (max)Minimal amount to stake: 1000 weiEmit [Staked()](#staked) event

*Stakes WStETH to the NGO.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| _amount | uint256 | The amount of WStETH to transfer |
| _ngoPercent | uint16 | The percentage share of the NGO. |

### transferOwnership

```solidity
function transferOwnership(address newOwner) external nonpayable
```



*Transfers ownership of the contract to a new account (`newOwner`). Can only be called by the current owner.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| newOwner | address | undefined |

### upgradeToAndCall

```solidity
function upgradeToAndCall(address newImplementation, bytes data) external payable
```



*Upgrade the implementation of the proxy to `newImplementation`, and subsequently execute the function call encoded in `data`. Calls {_authorizeUpgrade}. Emits an {Upgraded} event.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| newImplementation | address | undefined |
| data | bytes | undefined |

### withdrawalSC

```solidity
function withdrawalSC() external view returns (contract IWithdrawalQueue)
```



*Storage variable for the Withdrawal Queue Smart Contract interface.*


#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | contract IWithdrawalQueue | undefined |

### wstETHSC

```solidity
function wstETHSC() external view returns (contract IWstEth)
```



*Storage variable for the wrapped stEth Smart Contract interface.*


#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | contract IWstEth | undefined |



## Events

### BannedUser

```solidity
event BannedUser(address _userAddress, bool _isBan)
```

If _isBan = true - current user banned.If _isBan = false - current user not banned.

*Emitted when the state of user was changed.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| _userAddress  | address | User address. |
| _isBan  | bool | Current user state. |

### GraphEvent

```solidity
event GraphEvent(string _name, string _imageLink, string _description, string _link, string _location, address _ngo, uint256 _timestamp)
```



*Event for graph.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| _name  | string | The name of the NGO. |
| _imageLink  | string | The link to the image associated with the NGO. |
| _description  | string | A description of the NGO. |
| _link  | string | A link associated with the NGO. |
| _location  | string | A location of the NGO. |
| _ngo  | address | The address of the NGO contract. |
| _timestamp  | uint256 | The block timestamp when withdraw was claimed. |

### Initialized

```solidity
event Initialized(uint64 version)
```



*Triggered when the contract has been initialized or reinitialized.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| version  | uint64 | undefined |

### NGOFinished

```solidity
event NGOFinished(address _ngo, uint256 _timestamp, uint256 _blockNumber)
```



*Emitted when the NGO is finished.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| _ngo  | address | The address of the NGO contract. |
| _timestamp  | uint256 | The timestamp when the NGO was finished. |
| _blockNumber  | uint256 | The block number when the NGO was finished. |

### OracleChanged

```solidity
event OracleChanged(address _newOracle, bool _state)
```

If state = true - current address active.If state = false - current address deactive.

*Emitted when the oracle was added or status was changed.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| _newOracle  | address | New oracle address. |
| _state  | bool | Current oracle state. |

### OwnershipTransferred

```solidity
event OwnershipTransferred(address indexed previousOwner, address indexed newOwner)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| previousOwner `indexed` | address | undefined |
| newOwner `indexed` | address | undefined |

### RewardsOwnerChanged

```solidity
event RewardsOwnerChanged(address _newRewOwner)
```



*Emitted when the rewards owner was changed.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| _newRewOwner  | address | New reward owner address. |

### RewardsUpdated

```solidity
event RewardsUpdated(uint256 _totalNGOAssets, uint256 _timestamp, uint256 _blockNumber)
```

rewards which are produced in the NGO pool are being transfered to social impact

*Emitted when the rewards for the NGO are updated.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| _totalNGOAssets  | uint256 | Amount of tokens in the NGO pool. |
| _timestamp  | uint256 | The block timestamp when rewards was updated. |
| _blockNumber  | uint256 | The block number when rewards was updated. |

### Staked

```solidity
event Staked(uint256 _id, address _staker, uint256 _amountStaked, uint16 _percentShare, address _ngo, uint256 _timestamp, uint256 _blockNumber, enum NGOLis.EthType _ethType)
```

_amountStaked  might be in Eth or stEth or WStEth depending on _ethType.if _ethType = 0 then amount of Eth is passed.if _ethType = 1 then amount of stEth is passed.if _ethType = 2 then amount of WStEth is passed.

*Emitted when a user stakes funds in the NGO.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| _id  | uint256 | The id of the user&#39;s stake. |
| _staker  | address | The address of the user staking funds. |
| _amountStaked  | uint256 | The amount of funds staked. |
| _percentShare  | uint16 | The percentage share of the NGO. |
| _ngo  | address | The address of the NGO contract. |
| _timestamp  | uint256 | The block timestamp of the staking started. |
| _blockNumber  | uint256 | The block number of the staking started. |
| _ethType  | enum NGOLis.EthType | Type of eth. |

### Upgraded

```solidity
event Upgraded(address indexed implementation)
```



*Emitted when the implementation is upgraded.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| implementation `indexed` | address | undefined |

### WithdrawClaimed

```solidity
event WithdrawClaimed(address _claimer, address _ngo, uint256 _amount, uint256 _requestId, uint256 _timestamp, uint256 _blockNumber)
```



*Emitted when a user claims a withdrawal.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| _claimer  | address | The address of the user claiming withdrawal. |
| _ngo  | address | The address of the NGO contract. |
| _amount  | uint256 | The amount requested for withdrawal. |
| _requestId  | uint256 | The ID of the withdrawal request. |
| _timestamp  | uint256 | The block timestamp when withdraw was claimed. |
| _blockNumber  | uint256 | The block number when withdraw was claimed. |

### WithdrawERC20Claimed

```solidity
event WithdrawERC20Claimed(address _claimer, address _ngo, uint256 _amount, uint256 _timestamp, uint256 _blockNumber, uint256 _stakeId, enum NGOLis.EthType _ethType)
```

_amount to withdraw might be in stEth or WStEth depending on _ethType.if _ethType = 1 then amount of stEth is passed.if _ethType = 2 then amount of WStEth is passed.

*Emitted when a user claims a withdrawal in stEth.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| _claimer  | address | The address of the user claiming withdrawal. |
| _ngo  | address | The address of the NGO contract. |
| _amount  | uint256 | The amount of stEth or WStEth claimed. |
| _timestamp  | uint256 | The block timestamp when withdraw was claimed. |
| _blockNumber  | uint256 | The block number when withdraw was claimed. |
| _stakeId  | uint256 | The id of the stake. |
| _ethType  | enum NGOLis.EthType | Type of eth. |

### WithdrawRequested

```solidity
event WithdrawRequested(address _staker, address _ngo, uint256 _requestId, uint256 _timestamp, uint256 _blockNumber, uint256 _stakeId)
```



*Emitted when a user requests a withdrawal.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| _staker  | address | The address of the user requesting withdrawal. |
| _ngo  | address | The address of the NGO contract. |
| _requestId  | uint256 | The ID of the withdrawal request. |
| _timestamp  | uint256 | The block timestamp when withdraw was requested. |
| _blockNumber  | uint256 | The block number when withdraw was requested. |
| _stakeId  | uint256 | The id of the stake. |



## Errors

### AddressEmptyCode

```solidity
error AddressEmptyCode(address target)
```



*There&#39;s no code at `target` (it is not a contract).*

#### Parameters

| Name | Type | Description |
|---|---|---|
| target | address | undefined |

### ERC1967InvalidImplementation

```solidity
error ERC1967InvalidImplementation(address implementation)
```



*The `implementation` of the proxy is invalid.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| implementation | address | undefined |

### ERC1967NonPayable

```solidity
error ERC1967NonPayable()
```



*An upgrade function sees `msg.value &gt; 0` that may be lost.*


### FailedInnerCall

```solidity
error FailedInnerCall()
```



*A call to an address target failed. The target may have reverted.*


### InvalidInitialization

```solidity
error InvalidInitialization()
```



*The contract is already initialized.*


### InvalidPercent

```solidity
error InvalidPercent()
```



*Error indicating an invalid percentage value.*


### InvalidRequestIdForUser

```solidity
error InvalidRequestIdForUser(address _claimer, uint256 _requestId)
```



*Error indicating that the user has not owned this request.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| _claimer | address | undefined |
| _requestId | uint256 | undefined |

### InvalidStakeAmount

```solidity
error InvalidStakeAmount()
```



*Error indicating an invalid amount value passed (Eth, StEth).*


### InvalidWithdrawAmount

```solidity
error InvalidWithdrawAmount()
```



*Error indicating an invalid withdraw amount.*


### InvalidWithdrawalAmount

```solidity
error InvalidWithdrawalAmount()
```



*Error indicating an invalid withdrawal amount.*


### MathOverflowedMulDiv

```solidity
error MathOverflowedMulDiv()
```



*Muldiv operation overflow.*


### MinimumWstEthStakeError

```solidity
error MinimumWstEthStakeError()
```



*Error indicating an issue when amount of WstEth to stake is lower than minimum.*


### MinimumWstEthWithdrawError

```solidity
error MinimumWstEthWithdrawError()
```



*Error indicating an issue when amount of WstEth to withdraw is lower than minimum.*


### NgoFinished

```solidity
error NgoFinished()
```



*Error indicating that the NGO has already been finished.*


### NotFinalizedStatus

```solidity
error NotFinalizedStatus()
```



*Error indicating that the request status is not finilized.*


### NotInitializing

```solidity
error NotInitializing()
```



*The contract is not initializing.*


### NullAddress

```solidity
error NullAddress()
```



*Error indicating if address is equal null address.*


### OnlyOracle

```solidity
error OnlyOracle(address _sender)
```



*Error indicating that only oracle can perform the operation.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| _sender | address | undefined |

### OwnableInvalidOwner

```solidity
error OwnableInvalidOwner(address owner)
```



*The owner is not a valid owner account. (eg. `address(0)`)*

#### Parameters

| Name | Type | Description |
|---|---|---|
| owner | address | undefined |

### OwnableUnauthorizedAccount

```solidity
error OwnableUnauthorizedAccount(address account)
```



*The caller account is not authorized to perform an operation.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| account | address | undefined |

### ReentrancyGuardReentrantCall

```solidity
error ReentrancyGuardReentrantCall()
```



*Unauthorized reentrant call.*


### RequestAmountTooLarge

```solidity
error RequestAmountTooLarge(uint256 _amount)
```



*Error when requested amount too big.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| _amount | uint256 | undefined |

### RequestAmountTooSmall

```solidity
error RequestAmountTooSmall(uint256 _amount)
```



*Error when requested amount too small.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| _amount | uint256 | undefined |

### RewardError

```solidity
error RewardError()
```



*Error indicating an issue that there are no rewards.*


### UUPSUnauthorizedCallContext

```solidity
error UUPSUnauthorizedCallContext()
```



*The call is from an unauthorized context.*


### UUPSUnsupportedProxiableUUID

```solidity
error UUPSUnsupportedProxiableUUID(bytes32 slot)
```



*The storage `slot` is unsupported as a UUID.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| slot | bytes32 | undefined |

### UserBanned

```solidity
error UserBanned()
```



*Error indicating that user is banned.*


### ZeroAmount

```solidity
error ZeroAmount()
```



*Error when user enter amount that equals zero.*




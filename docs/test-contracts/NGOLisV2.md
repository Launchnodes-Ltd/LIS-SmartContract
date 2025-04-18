# NGOLisV2



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

### anotherNGOLisV2Fn

```solidity
function anotherNGOLisV2Fn() external pure returns (string)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | string | undefined |

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

### endNGO

```solidity
function endNGO() external nonpayable
```

Emit [NGOFinished()](#ngofinished) event

*Ends the NGO and marks it as finished.*


### getCurrentBalanceFromLido

```solidity
function getCurrentBalanceFromLido() external view returns (uint256)
```



*Retrieves the current balance of the contract from the Lido contract.*


#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | Current balance of the contract in stETH. |

### getHistoryData

```solidity
function getHistoryData(uint256 _timestamp) external view returns (uint256 _reward, uint256 _totalShares, uint256 _balance)
```

This function allows querying historical data, including rewards, total shares, and balance, for a specific timestamp. The timestamp is rounded to the start of the day for accurate retrieval.

*Retrieves historical data for a specific timestamp.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| _timestamp | uint256 | The timestamp for which historical data is requested. |

#### Returns

| Name | Type | Description |
|---|---|---|
| _reward | uint256 | The historical rewards at the specified timestamp. |
| _totalShares | uint256 | The historical total shares at the specified timestamp. |
| _balance | uint256 | The historical balance at the specified timestamp. |

### getNGOLisV2

```solidity
function getNGOLisV2() external pure returns (string)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | string | undefined |

### getUserBalance

```solidity
function getUserBalance(address _user, uint256 _id) external view returns (uint256 userTotal)
```



*Gets the user&#39;s share of funds in the NGO.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| _user | address | The address of the user. |
| _id | uint256 | The id of stake. |

#### Returns

| Name | Type | Description |
|---|---|---|
| userTotal | uint256 | The user&#39;s share rewards. |

### getUserStakeInfo

```solidity
function getUserStakeInfo(address _user, uint256 _id) external view returns (struct NGOLisV2.StakeInfo _userStakeInfo)
```

This function allows querying stake information for a specific stake.

*Retrieves stake information for a specific user.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| _user | address | The address of the user for whom stake information is requested. |
| _id | uint256 | The id of stake. |

#### Returns

| Name | Type | Description |
|---|---|---|
| _userStakeInfo | NGOLisV2.StakeInfo | The stake information for the specified user. |

### handleNGOShareDistribution

```solidity
function handleNGOShareDistribution() external nonpayable
```

Emit [RewardsUpdated()](#rewardsupdated) event

*Handles the distribution of NGO share based on staking.*


### initialize

```solidity
function initialize(address lidoSCAddress, address _rewardOwnerAddress, address withdrawalSCAddress, address owner, address oracle) external nonpayable
```



*Initializes the NGO contract with required parameters.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| lidoSCAddress | address | The address of the Lido Smart Contract. |
| _rewardOwnerAddress | address | The address of the rewards owner. |
| withdrawalSCAddress | address | The address of the Withdrawal Queue Smart Contract. |
| owner | address | undefined |
| oracle | address | undefined |

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

Emit [WithdrawRequested()](#withdrawrequested) event

*Requests withdrawal of funds from the NGO.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| _amount | uint256 | The amount of funds to be withdrawn. |
| _id | uint256 | The id of stake. |

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





#### Parameters

| Name | Type | Description |
|---|---|---|
| _newOracle | address | undefined |
| _state | bool | undefined |

### stake

```solidity
function stake(uint16 _ngoPercent) external payable
```

Emit [Staked()](#staked) event

*Stakes funds in the NGO.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| _ngoPercent | uint16 | The percentage share of the NGO. |

### stakeStEth

```solidity
function stakeStEth(uint256 amount, uint16 _ngoPercent) external nonpayable
```

Emit [Staked()](#staked) event

*Stakes stETH in the NGO.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| amount | uint256 | The amount of stETH to transfer |
| _ngoPercent | uint16 | The percentage share of the NGO. |

### stakedBalance

```solidity
function stakedBalance() external view returns (uint256)
```



*Storage variable for the total staked balance.*


#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

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



## Events

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

### OwnershipTransferred

```solidity
event OwnershipTransferred(address indexed previousOwner, address indexed newOwner)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| previousOwner `indexed` | address | undefined |
| newOwner `indexed` | address | undefined |

### RewardsUpdated

```solidity
event RewardsUpdated(uint256 _rewardsPool, uint256 stakedBalance, uint256 totalShare, uint256 _dateRecountRewards, uint256 _timestamp, uint256 _blockNumber)
```



*Emitted when the rewards for the NGO are updated.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| _rewardsPool  | uint256 | The total rewards in the pool. |
| stakedBalance  | uint256 | The total staked balance in the NGO. |
| totalShare  | uint256 | The total share of the NGO. |
| _dateRecountRewards  | uint256 | The timestamp when the rewards were last updated. |
| _timestamp  | uint256 | The block timestamp when rewards was updated. |
| _blockNumber  | uint256 | The block number when rewards was updated. |

### Staked

```solidity
event Staked(uint256 _id, address _staker, uint256 _amountStaked, uint16 _percentShare, address _ngo, uint256 _startDate, uint256 _timestamp, uint256 _blockNumber)
```



*Emitted when a user stakes funds in the NGO.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| _id  | uint256 | undefined |
| _staker  | address | The address of the user staking funds. |
| _amountStaked  | uint256 | The amount of funds staked. |
| _percentShare  | uint16 | The percentage share of the NGO. |
| _ngo  | address | The address of the NGO contract. |
| _startDate  | uint256 | The timestamp when the staking started. |
| _timestamp  | uint256 | The block timestamp of the staking started. |
| _blockNumber  | uint256 | The block number of the staking started. |

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
| _amount  | uint256 | The amount of ETH claimed. |
| _requestId  | uint256 | The ID of the withdrawal request. |
| _timestamp  | uint256 | The block timestamp when withdraw was claimed. |
| _blockNumber  | uint256 | The block number when withdraw was claimed. |

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
| _stakeId  | uint256 | undefined |



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


### InsufficientStakedFunds

```solidity
error InsufficientStakedFunds()
```



*Error indicating insufficient staked funds for a withdrawal.*


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

### MathOverflowedMulDiv

```solidity
error MathOverflowedMulDiv()
```



*Muldiv operation overflow.*


### NgoFinished

```solidity
error NgoFinished()
```



*Error indicating that the NGO has already finished.*


### NotInitializing

```solidity
error NotInitializing()
```



*The contract is not initializing.*


### NotNgoOwner

```solidity
error NotNgoOwner()
```



*Error indicating that the sender is not the owner of the NGO.*


### NotStaked

```solidity
error NotStaked()
```



*Error indicating that the user has not staked funds.*


### OnlyOracle

```solidity
error OnlyOracle(address _sender)
```



*Error indicating that only the owner or oracle can perform the operation.*

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


### TimeNotPassed

```solidity
error TimeNotPassed(uint256 _currentTime, uint256 _needTime, uint256 _startDate)
```



*Error indicating that the required time has not passed.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| _currentTime | uint256 | The current block timestamp. |
| _needTime | uint256 | The staking duration. |
| _startDate | uint256 | The start staking date. |

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

### WithdrawError

```solidity
error WithdrawError()
```



*Error indicating an issue with the withdrawal process.*




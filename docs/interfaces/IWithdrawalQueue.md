# IWithdrawalQueue









## Methods

### MAX_STETH_WITHDRAWAL_AMOUNT

```solidity
function MAX_STETH_WITHDRAWAL_AMOUNT() external view returns (uint256)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

### MIN_STETH_WITHDRAWAL_AMOUNT

```solidity
function MIN_STETH_WITHDRAWAL_AMOUNT() external view returns (uint256)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

### balanceOf

```solidity
function balanceOf(address _owner) external view returns (uint256 balance)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| _owner | address | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| balance | uint256 | undefined |

### claimWithdrawal

```solidity
function claimWithdrawal(uint256 _requestId) external nonpayable
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| _requestId | uint256 | undefined |

### claimWithdrawalsTo

```solidity
function claimWithdrawalsTo(uint256[] _requestIds, uint256[] _hints, address _recipient) external nonpayable
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| _requestIds | uint256[] | undefined |
| _hints | uint256[] | undefined |
| _recipient | address | undefined |

### findCheckpointHints

```solidity
function findCheckpointHints(uint256[] _requestIds, uint256 _firstIndex, uint256 _lastIndex) external view returns (uint256[] hintIds)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| _requestIds | uint256[] | undefined |
| _firstIndex | uint256 | undefined |
| _lastIndex | uint256 | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| hintIds | uint256[] | undefined |

### getLastCheckpointIndex

```solidity
function getLastCheckpointIndex() external view returns (uint256)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

### getLastRequestId

```solidity
function getLastRequestId() external view returns (uint256)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

### getRoleAdmin

```solidity
function getRoleAdmin(bytes32 role) external view returns (bytes32)
```



*Returns the admin role that controls `role`. See {grantRole} and {revokeRole}. To change a role&#39;s admin, use {AccessControl-_setRoleAdmin}.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| role | bytes32 | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bytes32 | undefined |

### getWithdrawalStatus

```solidity
function getWithdrawalStatus(uint256[] _requestIds) external view returns (struct IWithdrawalQueue.WithdrawalRequestStatus[] statuses)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| _requestIds | uint256[] | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| statuses | IWithdrawalQueue.WithdrawalRequestStatus[] | undefined |

### grantRole

```solidity
function grantRole(bytes32 role, address account) external nonpayable
```



*Grants `role` to `account`. If `account` had not been already granted `role`, emits a {RoleGranted} event. Requirements: - the caller must have ``role``&#39;s admin role.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| role | bytes32 | undefined |
| account | address | undefined |

### hasRole

```solidity
function hasRole(bytes32 role, address account) external view returns (bool)
```



*Returns `true` if `account` has been granted `role`.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| role | bytes32 | undefined |
| account | address | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bool | undefined |

### onOracleReport

```solidity
function onOracleReport(bool _isBunkerModeNow, uint256 _bunkerStartTimestamp, uint256 _currentReportTimestamp) external nonpayable
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| _isBunkerModeNow | bool | undefined |
| _bunkerStartTimestamp | uint256 | undefined |
| _currentReportTimestamp | uint256 | undefined |

### renounceRole

```solidity
function renounceRole(bytes32 role, address callerConfirmation) external nonpayable
```



*Revokes `role` from the calling account. Roles are often managed via {grantRole} and {revokeRole}: this function&#39;s purpose is to provide a mechanism for accounts to lose their privileges if they are compromised (such as when a trusted device is misplaced). If the calling account had been granted `role`, emits a {RoleRevoked} event. Requirements: - the caller must be `callerConfirmation`.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| role | bytes32 | undefined |
| callerConfirmation | address | undefined |

### requestWithdrawals

```solidity
function requestWithdrawals(uint256[] _amounts, address _owner) external nonpayable returns (uint256[] requestIds)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| _amounts | uint256[] | undefined |
| _owner | address | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| requestIds | uint256[] | undefined |

### requestWithdrawalsWstETH

```solidity
function requestWithdrawalsWstETH(uint256[] _amounts, address _owner) external nonpayable returns (uint256[] requestIds)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| _amounts | uint256[] | undefined |
| _owner | address | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| requestIds | uint256[] | undefined |

### revokeRole

```solidity
function revokeRole(bytes32 role, address account) external nonpayable
```



*Revokes `role` from `account`. If `account` had been granted `role`, emits a {RoleRevoked} event. Requirements: - the caller must have ``role``&#39;s admin role.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| role | bytes32 | undefined |
| account | address | undefined |



## Events

### RoleAdminChanged

```solidity
event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole)
```



*Emitted when `newAdminRole` is set as ``role``&#39;s admin role, replacing `previousAdminRole` `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite {RoleAdminChanged} not being emitted signaling this.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| role `indexed` | bytes32 | undefined |
| previousAdminRole `indexed` | bytes32 | undefined |
| newAdminRole `indexed` | bytes32 | undefined |

### RoleGranted

```solidity
event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender)
```



*Emitted when `account` is granted `role`. `sender` is the account that originated the contract call, an admin role bearer except when using {AccessControl-_setupRole}.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| role `indexed` | bytes32 | undefined |
| account `indexed` | address | undefined |
| sender `indexed` | address | undefined |

### RoleRevoked

```solidity
event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender)
```



*Emitted when `account` is revoked `role`. `sender` is the account that originated the contract call:   - if using `revokeRole`, it is the admin role bearer   - if using `renounceRole`, it is the role bearer (i.e. `account`)*

#### Parameters

| Name | Type | Description |
|---|---|---|
| role `indexed` | bytes32 | undefined |
| account `indexed` | address | undefined |
| sender `indexed` | address | undefined |



## Errors

### AccessControlBadConfirmation

```solidity
error AccessControlBadConfirmation()
```



*The caller of a function is not the expected one. NOTE: Don&#39;t confuse with {AccessControlUnauthorizedAccount}.*


### AccessControlUnauthorizedAccount

```solidity
error AccessControlUnauthorizedAccount(address account, bytes32 neededRole)
```



*The `account` is missing a role.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| account | address | undefined |
| neededRole | bytes32 | undefined |



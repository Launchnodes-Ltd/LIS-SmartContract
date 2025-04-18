# WStEthImitation









## Methods

### allowance

```solidity
function allowance(address, address) external view returns (uint256)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| _0 | address | undefined |
| _1 | address | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

### amount

```solidity
function amount() external view returns (uint256)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

### approve

```solidity
function approve(address _spender, uint256 _amount) external pure returns (bool)
```



*Approve tokens for transfer*

#### Parameters

| Name | Type | Description |
|---|---|---|
| _spender | address | undefined |
| _amount | uint256 | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bool | undefined |

### balanceOf

```solidity
function balanceOf(address _account) external view returns (uint256)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| _account | address | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

### decimals

```solidity
function decimals() external view returns (uint8)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint8 | undefined |

### depositEther

```solidity
function depositEther() external payable
```






### etherBalances

```solidity
function etherBalances(address) external view returns (uint256)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| _0 | address | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

### getEtherBalance

```solidity
function getEtherBalance(address _user) external view returns (uint256)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| _user | address | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

### getStETHByWstETH

```solidity
function getStETHByWstETH(uint256 _wstETHAmount) external view returns (uint256)
```



*Get amount of stETH for a given amount of wstETH*

#### Parameters

| Name | Type | Description |
|---|---|---|
| _wstETHAmount | uint256 | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

### getUserBalance

```solidity
function getUserBalance(address _user, uint256 _id) external view returns (uint256)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| _user | address | undefined |
| _id | uint256 | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

### getWstETHByStETH

```solidity
function getWstETHByStETH(uint256 _stETHAmount) external pure returns (uint256)
```



*Get amount of wstETH for a given amount of stETH*

#### Parameters

| Name | Type | Description |
|---|---|---|
| _stETHAmount | uint256 | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

### getWstEthPrice

```solidity
function getWstEthPrice() external view returns (uint256)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

### id

```solidity
function id() external view returns (uint256)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

### name

```solidity
function name() external view returns (string)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | string | undefined |

### price

```solidity
function price() external view returns (uint256)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

### simulateRewards

```solidity
function simulateRewards(uint256 percent) external nonpayable
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| percent | uint256 | undefined |

### stEthPerToken

```solidity
function stEthPerToken() external view returns (uint256)
```



*Get amount of stETH for a one wstETH*


#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

### symbol

```solidity
function symbol() external view returns (string)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | string | undefined |

### tokensPerStEth

```solidity
function tokensPerStEth() external view returns (uint256)
```



*Get amount of wstETH for a one stETH*


#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

### transfer

```solidity
function transfer(address _recipient, uint256 _amount) external nonpayable returns (bool)
```



*Transfer tokens to destinatination address*

#### Parameters

| Name | Type | Description |
|---|---|---|
| _recipient | address | undefined |
| _amount | uint256 | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bool | undefined |

### transferFrom

```solidity
function transferFrom(address _sender, address _recipient, uint256 _amount) external nonpayable returns (bool)
```



*Transfer tokens to from address to destinatination address*

#### Parameters

| Name | Type | Description |
|---|---|---|
| _sender | address | undefined |
| _recipient | address | undefined |
| _amount | uint256 | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bool | undefined |

### unwrap

```solidity
function unwrap(uint256 _wstETHAmount) external nonpayable returns (uint256)
```



*Exchanges wstETH to stETH*

#### Parameters

| Name | Type | Description |
|---|---|---|
| _wstETHAmount | uint256 | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

### withdrawEther

```solidity
function withdrawEther(uint256 _amount) external nonpayable
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| _amount | uint256 | undefined |

### wrap

```solidity
function wrap(uint256 _stETHAmount) external nonpayable returns (uint256)
```



*Exchanges stETH to wstETH*

#### Parameters

| Name | Type | Description |
|---|---|---|
| _stETHAmount | uint256 | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |





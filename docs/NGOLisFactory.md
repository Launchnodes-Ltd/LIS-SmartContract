# NGOLisFactory









## Methods

### createNGO

```solidity
function createNGO(string _name, string _imageLink, string _description, string _link, string _location, address _rewardsOwner, address _owner, address _oracle) external nonpayable
```

Emit [NGOCreated](#ngocreated) event

*Creates a new NGO contract with the specified parameters.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| _name | string | The name of the NGO. |
| _imageLink | string | The link to the image associated with the NGO. |
| _description | string | A description of the NGO. |
| _link | string | A link associated with the NGO. |
| _location | string | The location of NGO. |
| _rewardsOwner | address | The address of the rewards owner for the NGO. |
| _owner | address | The owner/admin of NGO. |
| _oracle | address | Oracle address which initiate handleNGOdistribution function on a daily basis. |

### owner

```solidity
function owner() external view returns (address)
```



*Returns the address of the current owner.*


#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | address | undefined |

### renounceOwnership

```solidity
function renounceOwnership() external nonpayable
```



*Leaves the contract without owner. It will not be possible to call `onlyOwner` functions. Can only be called by the current owner. NOTE: Renouncing ownership will leave the contract without an owner, thereby disabling any functionality that is only available to the owner.*


### setImplementation

```solidity
function setImplementation(address _newImplementation) external nonpayable
```



*Set new implementation to NGOLis. When some function need to be updated in smart contract NGOLis You can deploy new contract version, use this function and after that next NGO will be used new smart contract*

#### Parameters

| Name | Type | Description |
|---|---|---|
| _newImplementation | address | undefined |

### transferOwnership

```solidity
function transferOwnership(address newOwner) external nonpayable
```



*Transfers ownership of the contract to a new account (`newOwner`). Can only be called by the current owner.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| newOwner | address | undefined |

### withdrawFeeStEth

```solidity
function withdrawFeeStEth() external nonpayable
```

Emit [LisFeeClaimed](#lisfeeclaimed) event

*Withdraw lis fee.*




## Events

### ImplementationChanged

```solidity
event ImplementationChanged(address _newImplementation)
```



*Emitted when an implementation was changed.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| _newImplementation  | address | Address of new implementation. |

### LisFeeClaimed

```solidity
event LisFeeClaimed(uint256 _value)
```



*Emitted when a lis fee was claimed.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| _value  | uint256 | The name of the NGO. |

### NGOCreated

```solidity
event NGOCreated(string _name, string _imageLink, string _description, string _link, address _rewardsOwner, address _ngoAddress, string _location, address _oracle)
```



*Emitted when a new NGO is created.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| _name  | string | The name of the NGO. |
| _imageLink  | string | The link to the image associated with the NGO. |
| _description  | string | A description of the NGO. |
| _link  | string | A link associated with the NGO. |
| _rewardsOwner  | address | The address of the rewards owner for the NGO. |
| _ngoAddress  | address | The address of the newly created NGO contract. |
| _location  | string | undefined |
| _oracle  | address | Oracle address which initiate handleNGOdistribution function on a daily basis. |

### OwnershipTransferred

```solidity
event OwnershipTransferred(address indexed previousOwner, address indexed newOwner)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| previousOwner `indexed` | address | undefined |
| newOwner `indexed` | address | undefined |



## Errors

### NullAddress

```solidity
error NullAddress()
```



*Error indicating if address is equal null address.*


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



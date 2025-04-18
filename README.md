# LIS Smart contracts

### LIS Smart contracts have two main functions

1.  For Users
2.  For Organisations

### For Users

1. Users can stake ETH/stETH/wstETH

2. Users can check their current balance with rewards

3. User can withdraw ETH/stETH/wstETH

### For Organisations

1. Social Impact organisations can be added in order to attain donations.

2. They can be removed.

3. They can withdraw

---

# NGOLisFactory

The contract includes functionality for creating new NGO instances, associating them with owners, and emitting events to log these actions. Additionally, it provides a method for the contract owner to withdraw fees in the form of staked Ether (stETH), ensuring proper fund management and transparency. The contract leverages interfaces and events to interact with other smart contracts and to notify external systems of significant actions. It utilizes the ERC1967 proxy pattern to create upgradeable NGO instances, manages ownership associations, and handles platform fee collection.

---

# NGOLis

The NGOLis contract manages staking and withdrawal functionalities for Non-Governmental Organizations (NGOs). It enables users to stake ETH, stETH, or wstETH while allocating a portion to NGO operations. The contract interacts with the Lido Finance protocol for staking and the withdrawal queue for managing withdrawals. It incorporates percentage-based sharing mechanisms, reward distributions, and comprehensive security controls. It includes various functions and modifiers to manage NGO operations, such as creating and updating NGO details, handling donations, and ensuring compliance with specific rules. The notBanned modifier is used to restrict access to stake, ensuring that only non-banned entities can stake while everyone can withdraw their staked funds. Supports staking and withdrawal support for ETH, stETH, wstETH tokens.

### Notice

During withdrawal of assets from smart contract, ratio variable is being calculated.
There might be cases with huge amounts which were staked and attempts to withdraw small amounts from the Stake. Taking into account math calculations in Solidity, such cases won't let users to withdraw such small amount to prevent attacks on the smart contract. The minimum amount that could be withdrawn is automatically raised via rules which were written.

- Example

---

1.  User staked 1000 ETH
2.  User tries to withdraw 999 wei

Ratio calculation will lead to 0, and function won't let user withdraw such tiny amount
Minimum amount to withdraw for 1000 ETH stake is 1000 wei

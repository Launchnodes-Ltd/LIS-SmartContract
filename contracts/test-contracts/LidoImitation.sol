// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "../interfaces/ILido.sol";
import "../interfaces/IERC20.sol";
import "hardhat/console.sol";
contract LidoImitation is IERC20, ILido {
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );

    string public name;
    string public symbol;
    uint8 public decimals;

    mapping(address => mapping(address => uint256)) public allowance;
    mapping(address => uint) balances;

    constructor(string memory _name, string memory _symbol, uint8 _decimals) {
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
    }

    function balanceOf(
        address _tokenHolder
    ) external view override(IERC20, ILido) returns (uint) {
        return balances[_tokenHolder];
    }

    function transfer(
        address recipient,
        uint256 amount
    ) external returns (bool) {
        balances[msg.sender] -= amount;
        balances[recipient] += amount;
        return true;
    }

    function setWStEthBalance(
        address recipient,
        uint256 amount
    ) external returns (bool) {
        balances[recipient] += amount;
        return true;
    }

    function submit(address _referral) external payable returns (uint256) {
        balances[_referral] += msg.value;
        return 1;
    }

    function approve(address spender, uint256 amount) external returns (bool) {
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool) {
        allowance[sender][recipient] -= amount;
        balances[sender] -= amount;
        balances[recipient] += amount;
        emit Transfer(sender, recipient, amount);
        return true;
    }

    function imitateRewards(uint percent, address _to) public {
        balances[_to] += (balances[_to] / 100) * percent;
    }

    function minusBalance(uint amount, address sender) public {
        balances[sender] -= amount;
    }
}

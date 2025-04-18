// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "../interfaces/IWstEth.sol";
import "../interfaces/IERC20.sol";
import "hardhat/console.sol";
contract WStEthImitation is IWstEth, IERC20 {
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public price;
    uint256 public amount;
    uint256 public id;

    mapping(address => mapping(address => uint256)) public allowance;
    mapping(address => mapping(uint256 => uint256)) balances;
    mapping(address => uint256) scBalance;
    mapping(address => uint256) public etherBalances;

    constructor(string memory _name, string memory _symbol, uint8 _decimals) {
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
        price = 98;
        id = 1;
    }

    function balanceOf(
        address _account
    ) external view override(IERC20, IWstEth) returns (uint256) {
        return scBalance[_account];
    }

    function getUserBalance(
        address _user,
        uint256 _id
    ) public view returns (uint256) {
        return (balances[_user][_id] * price) / 100;
    }

    function getWstEthPrice() public view returns (uint256) {
        return price;
    }

    function simulateRewards(uint percent) public {
        price += (price * percent) / 100;
    }
    /**
     * @dev Exchanges stETH to wstETH
     */
    function wrap(uint256 _stETHAmount) external returns (uint256) {
        balances[msg.sender][id] += _stETHAmount;
        scBalance[msg.sender] += _stETHAmount;
        return _stETHAmount;
    }

    /**
     * @dev Exchanges wstETH to stETH
     */
    function unwrap(uint256 _wstETHAmount) external returns (uint256) {
        scBalance[msg.sender] -= _wstETHAmount;
        return scBalance[msg.sender];
    }

    /**
     * @dev Get amount of wstETH for a given amount of stETH
     */
    function getWstETHByStETH(
        uint256 _stETHAmount
    ) external pure returns (uint256) {
        return _stETHAmount;
    }

    /**
     * @dev Get amount of stETH for a given amount of wstETH
     */
    function getStETHByWstETH(
        uint256 _wstETHAmount
    ) external view returns (uint256) {
        return (_wstETHAmount * price) / 100;
    }

    /**
     * @dev Get amount of stETH for a one wstETH
     */
    function stEthPerToken() external view returns (uint256) {}

    /**
     * @dev Get amount of wstETH for a one stETH
     */
    function tokensPerStEth() external view returns (uint256) {}

    /**
     * @dev Approve tokens for transfer
     */
    function approve(
        address _spender,
        uint256 _amount
    ) external pure returns (bool) {
        if (_spender != address(0) && _amount != 0) {
            return true;
        } else {
            return false;
        }
    }

    function transfer(
        address _recipient,
        uint256 _amount
    ) external override returns (bool) {
        scBalance[_recipient] += _amount;
        return true;
    }

    function transferFrom(
        address _sender,
        address _recipient,
        uint256 _amount
    ) external override returns (bool) {
        balances[_recipient][id] += _amount;
        balances[_sender][id] += _amount;
        scBalance[_recipient] += _amount;
        id++;
        return true;
    }

    function depositEther() external payable {
        require(msg.value > 0, "Must send Ether");
        etherBalances[msg.sender] += msg.value;
    }

    function withdrawEther(uint256 _amount) external {
        require(
            etherBalances[msg.sender] >= _amount,
            "Insufficient Ether balance"
        );
        etherBalances[msg.sender] -= _amount;
        (bool success, ) = msg.sender.call{value: _amount}("");
        require(success, "Failed to withdraw Ether");
    }

    function getEtherBalance(address _user) external view returns (uint256) {
        return etherBalances[_user];
    }

    receive() external payable {
        // etherBalances[msg.sender] += msg.value;
        // balances[msg.sender] += msg.value;
        // console.log("Received", msg.value, "ether from", msg.sender);
    }

    fallback() external payable {
        etherBalances[msg.sender] += msg.value;
        scBalance[msg.sender] += msg.value;
    }
}

//SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

/**
 * @dev Interface of the WstEth that implement function on smart contract.
 */
interface IWstEth {
    /**
     * @dev Exchanges stETH to wstETH
     */
    function wrap(uint256 _stETHAmount) external returns (uint256);

    /**
     * @dev Exchanges wstETH to stETH
     */
    function unwrap(uint256 _wstETHAmount) external returns (uint256);

    /**
     * @dev Get amount of wstETH for a given amount of stETH
     */
    function getWstETHByStETH(
        uint256 _stETHAmount
    ) external view returns (uint256);

    /**
     * @dev Get amount of stETH for a given amount of wstETH
     */
    function getStETHByWstETH(
        uint256 _wstETHAmount
    ) external view returns (uint256);

    /**
     * @dev Get amount of stETH for a one wstETH
     */
    function stEthPerToken() external view returns (uint256);

    /**
     * @dev Get amount of wstETH for a one stETH
     */
    function tokensPerStEth() external view returns (uint256);

    /**
     * @dev Approve tokens for transfer
     */
    function approve(address _spender, uint256 _amount) external returns (bool);

    /**
     * @dev Transfer tokens to destinatination address
     */
    function transfer(
        address _recipient,
        uint256 _amount
    ) external returns (bool);

    /**
     * @dev Transfer tokens to from address to destinatination address
     */
    function transferFrom(
        address _sender,
        address _recipient,
        uint256 _amount
    ) external returns (bool);

    /**
     * @dev Get balance of wstETH
     */
    function balanceOf(address _account) external view returns (uint256);
}

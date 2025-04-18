//SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

interface ILido {
    function submit(address _referral) external payable returns (uint256);

    function balanceOf(address _tokenHolder) external view returns (uint256);

    function transfer(
        address _recipient,
        uint256 _amount
    ) external returns (bool);

    function approve(address _spender, uint256 _amount) external returns (bool);

    function transferFrom(
        address _sender,
        address _recipient,
        uint256 _amount
    ) external returns (bool);
}

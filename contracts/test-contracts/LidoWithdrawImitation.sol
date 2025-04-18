// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "../interfaces/IWithdrawalQueue.sol";
import "./LidoImitation.sol";
import "hardhat/console.sol";

contract LidoWithdrawImitation is IWithdrawalQueue {
    LidoImitation lido;

    uint requestId;
    mapping(uint => WithdrawalRequestStatus) requests;

    constructor(address lidoAddress) {
        lido = LidoImitation(lidoAddress);
    }

    function requestWithdrawals(
        uint256[] memory _amounts,
        address _owner
    ) public returns (uint256[] memory) {
        uint256[] memory requestIds = new uint256[](1);

        for (uint i = 0; i < _amounts.length; i++) {
            requests[requestId] = WithdrawalRequestStatus({
                amountOfStETH: _amounts[i],
                amountOfShares: _amounts[i],
                owner: _owner,
                timestamp: block.timestamp,
                isFinalized: false,
                isClaimed: false
            });

            requestIds[i] = (requestId);
            requestId++;
        }
        console.log(requestIds[0]);
        return requestIds;
    }

    function requestWithdrawalsWstETH(
        uint256[] calldata _amounts,
        address _owner
    ) public returns (uint256[] memory) {
        uint256[] memory requestIds = new uint256[](1);
        console.log("_amounts 2", _amounts[0]);

        for (uint i = 0; i < _amounts.length; i++) {
            requests[requestId] = WithdrawalRequestStatus({
                amountOfStETH: _amounts[i],
                amountOfShares: _amounts[i],
                owner: _owner,
                timestamp: block.timestamp,
                isFinalized: false,
                isClaimed: false
            });

            requestIds[i] = (requestId);
            requestId++;
        }

        return requestIds;
    }

    function getWithdrawalStatus(
        uint256[] memory _requestIds
    ) public view returns (WithdrawalRequestStatus[] memory) {
        WithdrawalRequestStatus[]
            memory _requests = new WithdrawalRequestStatus[](1);

        for (uint i = 0; i < _requestIds.length; i++) {
            _requests[i] = requests[_requestIds[i]];
        }

        return _requests;
    }

    function claimWithdrawal(uint256 _requestId) public {
        WithdrawalRequestStatus storage withdrawalStatus = requests[_requestId];
        withdrawalStatus.isClaimed = true;
        payable(withdrawalStatus.owner).transfer(
            withdrawalStatus.amountOfStETH
        );
    }

    function balanceOf(
        address _owner
    ) external view returns (uint256 balance) {}

    function getLastRequestId() public view returns (uint256) {
        return requestId - 1;
    }

    function approveRequest(uint256 _requestId) public {
        WithdrawalRequestStatus storage withdrawalStatus = requests[_requestId];
        withdrawalStatus.isFinalized = true;
    }

    function onOracleReport(
        bool _isBunkerModeNow,
        uint256 _bunkerStartTimestamp,
        uint256 _currentReportTimestamp
    ) external {}

    function getRoleAdmin(bytes32 role) external view returns (bytes32) {}

    function findCheckpointHints(
        uint256[] memory _requestIds,
        uint256 _firstIndex,
        uint256 _lastIndex
    ) external view returns (uint256[] memory) {}

    function getLastCheckpointIndex() external view returns (uint256) {}

    function claimWithdrawalsTo(
        uint256[] memory _requestIds,
        uint256[] memory _hints,
        address _recipient
    ) external {}

    function MIN_STETH_WITHDRAWAL_AMOUNT() external view returns (uint256) {}

    function MAX_STETH_WITHDRAWAL_AMOUNT() external view returns (uint256) {}

    function grantRole(bytes32 role, address account) external {}

    function hasRole(
        bytes32 role,
        address account
    ) external view returns (bool) {}

    function renounceRole(bytes32 role, address callerConfirmation) external {}

    function revokeRole(bytes32 role, address account) external {}
}

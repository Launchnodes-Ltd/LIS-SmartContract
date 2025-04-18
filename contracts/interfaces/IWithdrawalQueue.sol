//SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/access/IAccessControl.sol";

interface IWithdrawalQueue is IAccessControl {
    struct WithdrawalRequestStatus {
        uint256 amountOfStETH;
        uint256 amountOfShares;
        address owner;
        uint256 timestamp;
        bool isFinalized;
        bool isClaimed;
    }
    function MIN_STETH_WITHDRAWAL_AMOUNT() external view returns (uint256);

    function MAX_STETH_WITHDRAWAL_AMOUNT() external view returns (uint256);

    function requestWithdrawals(
        uint256[] calldata _amounts,
        address _owner
    ) external returns (uint256[] calldata requestIds);

    function requestWithdrawalsWstETH(
        uint256[] calldata _amounts,
        address _owner
    ) external returns (uint256[] calldata requestIds);

    function getWithdrawalStatus(
        uint256[] memory _requestIds
    ) external view returns (WithdrawalRequestStatus[] calldata statuses);

    function claimWithdrawal(uint256 _requestId) external;

    function findCheckpointHints(
        uint256[] memory _requestIds,
        uint256 _firstIndex,
        uint256 _lastIndex
    ) external view returns (uint256[] memory hintIds);

    function getLastCheckpointIndex() external view returns (uint256);

    function claimWithdrawalsTo(
        uint256[] memory _requestIds,
        uint256[] memory _hints,
        address _recipient
    ) external;

    function balanceOf(address _owner) external view returns (uint256 balance);

    function getLastRequestId() external view returns (uint256);

    function onOracleReport(
        bool _isBunkerModeNow,
        uint256 _bunkerStartTimestamp,
        uint256 _currentReportTimestamp
    ) external;
}

// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "./NGOLis.sol";
import "./interfaces/IWstEth.sol";

import "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract NGOLisFactory is Ownable {
    /*------------------------------------------------ Events -------------------------------------------------------------*/
    /**
     * @dev Emitted when a new NGO is created.
     * @param _name The name of the NGO.
     * @param _imageLink The link to the image associated with the NGO.
     * @param _description A description of the NGO.
     * @param _link A link associated with the NGO.
     * @param _rewardsOwner The address of the rewards owner for the NGO.
     * @param _ngoAddress The address of the newly created NGO contract.
     * @param _oracle Oracle address which initiate handleNGOdistribution function on a daily basis.
     */
    event NGOCreated(
        string _name,
        string _imageLink,
        string _description,
        string _link,
        address _rewardsOwner,
        address _ngoAddress,
        string _location,
        address _oracle
    );

    /**
     * @dev Emitted when an implementation was changed.
     * @param _newImplementation Address of new implementation.
     */
    event ImplementationChanged(address _newImplementation);

    /**
     * @dev Emitted when a lis fee was claimed.
     * @param _value The name of the NGO.
     */
    event LisFeeClaimed(uint256 _value);

    /*------------------------------------------------ Errors -------------------------------------------------------------*/

    /**
     * @dev Error indicating if address is equal null address.
     */
    error NullAddress();

    /*------------------------------------------------ Storage -------------------------------------------------------------*/
    /**
     * @dev Address of the Lido Smart Contract.
     */
    address private _lidoSCAddress;
    /**
     * @dev Address of the NGO implementation contract.
     */
    address private _ngoImplementation;
    /**
     * @dev Address of the withdrawal Smart Contract.
     */
    address private _withdrawalSCAddress;

    /**
     * @dev Address of the wrapped StEth Smart Contract.
     */
    address private _wstETHAddress;

    /**
     * @dev Constructor to initialize contract parameters.
     * @param _lidoSC The address of the Lido Smart Contract.
     * @param _withdrawalSC The address of the withdrawal Smart Contract.
     * @param _ngoImplementationAddress The address of the NGO implementation contract.
     * @param _owner Owner of Factory contract.
     */
    constructor(
        address _lidoSC,
        address _withdrawalSC,
        address _ngoImplementationAddress,
        address _wstETHSC,
        address _owner
    ) Ownable(_owner) {
        if (_lidoSC == address(0)) revert NullAddress();
        if (_withdrawalSC == address(0)) revert NullAddress();
        if (_ngoImplementationAddress == address(0)) revert NullAddress();
        if (_wstETHSC == address(0)) revert NullAddress();

        _lidoSCAddress = _lidoSC;
        _withdrawalSCAddress = _withdrawalSC;
        _wstETHAddress = _wstETHSC;
        _ngoImplementation = _ngoImplementationAddress;
    }

    /*------------------------------------------------ Functions -------------------------------------------------------------*/
    /**
     * @dev Creates a new NGO contract with the specified parameters.
     * @param _name The name of the NGO.
     * @param _imageLink The link to the image associated with the NGO.
     * @param _description A description of the NGO.
     * @param _link A link associated with the NGO.
     * @param _location The location of NGO.
     * @param _rewardsOwner The address of the rewards owner for the NGO.
     * @param _owner The owner/admin of NGO.
     * @param _oracle Oracle address which initiate handleNGOdistribution function on a daily basis.
     * @notice Emit [NGOCreated](#ngocreated) event
     */
    function createNGO(
        string memory _name,
        string memory _imageLink,
        string memory _description,
        string memory _link,
        string memory _location,
        address _rewardsOwner,
        address _owner,
        address _oracle
    ) public onlyOwner {
        ERC1967Proxy _ngoAddress = new ERC1967Proxy(
            _ngoImplementation,
            abi.encodeWithSelector(
                NGOLis(payable(address(0))).initialize.selector,
                _lidoSCAddress,
                _rewardsOwner,
                _withdrawalSCAddress,
                _owner,
                _oracle,
                _wstETHAddress
            )
        );

        emit NGOCreated(
            _name,
            _imageLink,
            _description,
            _link,
            _rewardsOwner,
            address(_ngoAddress),
            _location,
            _oracle
        );
    }

    /**
     * @dev Withdraw lis fee.
     * @notice Emit [LisFeeClaimed](#lisfeeclaimed) event
     */
    function withdrawFeeStEth() public onlyOwner {
        IWstEth _wstETHSC = IWstEth(_wstETHAddress);

        uint256 _balanceForWithdraw = _wstETHSC.balanceOf(address(this));

        _wstETHSC.transfer(owner(), _balanceForWithdraw);

        emit LisFeeClaimed(_balanceForWithdraw);
    }

    /**
     * @dev Set new implementation to NGOLis.
     * When some function need to be updated in smart contract NGOLis
     * You can deploy new contract version, use this function and after that next NGO will be used new smart contract
     */
    function setImplementation(address _newImplementation) public onlyOwner {
        if (_newImplementation == address(0)) revert NullAddress();
        _ngoImplementation = _newImplementation;
        emit ImplementationChanged(_newImplementation);
    }
}

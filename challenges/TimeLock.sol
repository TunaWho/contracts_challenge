// SPDX-License-Identifier: MIT

/**
TimeLock is a contract where transactions must be queued for some minimum time before it can be executed.

It's usually used in DAO to increase transparency. Call to critical functions are restricted to time lock.

This give users time to take action before the transaction is executed by the time lock.

For example, TimeLock can be used to increase users' trust that the DAO will not rug pull.

Here is the contract that will be used to test TimeLock

https://www.youtube.com/watch?v=P1f2a5Ckjpg
*/


pragma solidity ^0.8.17;

contract TestTimeLock {
    address public timeLock;
    bool public canExecute;
    bool public executed;

    constructor(address _timeLock) {
        timeLock = _timeLock;
    }

    fallback() external {}

    function func() external payable {
        require(msg.sender == timeLock, "not time lock");
        require(canExecute, "cannot execute this function");
        executed = true;
    }

    function setCanExecute(bool _canExecute) external {
        canExecute = _canExecute;
    }
}

contract TimeLock {
    event Queue(
        bytes32 indexed txId,
        address indexed target,
        uint value,
        string func,
        bytes data,
        uint timestamp
    );
    event Execute(
        bytes32 indexed txId,
        address indexed target,
        uint value,
        string func,
        bytes data,
        uint timestamp
    );
    event Cancel(bytes32 indexed txId);

    uint public constant MIN_DELAY = 10; // seconds
    uint public constant MAX_DELAY = 1000; // seconds
    uint public constant GRACE_PERIOD = 1000; // seconds

    address public owner;
    // tx id => queued
    mapping(bytes32 => bool) public queued;

    constructor() {
        owner = msg.sender;
    }

    receive() external payable {}

    function getTxId(
        address _target,
        uint _value,
        string calldata _func,
        bytes calldata _data,
        uint _timestamp
    ) public pure returns (bytes32) {
        return keccak256(abi.encode(_target, _value, _func, _data, _timestamp));
    }

    /**
     * @param _target Address of contract or account to call
     * @param _value Amount of ETH to send
     * @param _func Function signature, for example "foo(address,uint256)"
     * @param _data ABI encoded data send.
     * @param _timestamp Timestamp after which the transaction can be executed.
     */
    function queue(
        address _target,
        uint _value,
        string calldata _func,
        bytes calldata _data,
        uint _timestamp
    ) external returns (bytes32 txId) {
        // Only owner can call
        // Revert if transaction is already queued
        // Revert if _timestamp is less than MIN_DELAY or greater than MAX_DELAY from block.timestamp
        // Compute the transaction hash by calling getTxId and queue the transaction into the mapping queued
        // emit the event Queue
        // Return the transaction id that was queued
        
    }

    function execute(
        address _target,
        uint _value,
        string calldata _func,
        bytes calldata _data,
        uint _timestamp
    ) external payable returns (bytes memory) {
        // This function will execute a transaction that's been queued.

        // Only owner can call.
        // Revert if transaction is not queued
        // Revert if current timestamp is less tnan _timestamp or if it is beyond _timestamp + GRACE_PERIOD
        // Remove transaction from queue
        // Prepare the data to send to _target. If _func is not empty, then compute the function selector of _func and prepend it to _data.
        // Call _target sending _value, revert if the call fails
        // emit the event Execute
        // Return data returned from calling _target
    }

    function cancel(bytes32 _txId) external {
        // This function will cancel a queued transaction.

        // Only owner can call.
        // Revert if transaction is not queued
        // Remove transaction from queue
        // emit the event Cancel
    }
}

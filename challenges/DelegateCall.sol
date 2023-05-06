// SPDX-License-Identifier: MIT

/**
delegatecall is like call, except the code of callee is executed inside the caller.

For example contract A calls delegatecall on contract B. Code inside B is executed using A's context such as storage, msg.sender and msg.value.

This is the contract that is called.

*/

pragma solidity ^0.8.17;

contract TestDelegateCall {
    // Storage layout must be the same as contract A
    uint public num;
    address public sender;
    uint public value;

    function setVars(uint _num) external payable {
        num = _num;
        sender = msg.sender;
        value = msg.value;
    }

    function setNum(uint _num) external {
        num = _num;
    }
}

contract DelegateCall {
    uint public num;
    address public sender;
    uint public value;

    function setVars(address _test, uint _num) external payable {
        // This contract's storage is updated, TestDelegateCall's storage is not modified.
        (bool success, bytes memory data) = _test.delegatecall(
            abi.encodeWithSignature("setVars(uint256)", _num)
        );
        require(success, "tx failed");
    }

    function setNum(address _test, uint _num) external {
        require(_test != address(0), "Caller: cannot be zero address");
        (bool success,) = _test.delegatecall(
            abi.encodeWithSignature("setNum(uint256)", _num)
        );
        require(success, "tx failed");
    }
}

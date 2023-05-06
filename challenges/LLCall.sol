// SPDX-License-Identifier: MIT

/**
call is a low level function to call other contracts.

Here is the contract that is called

*/

pragma solidity ^0.8.17;

contract TestCall {
    fallback() external payable {}

    function foo(
        string memory _message,
        uint _x
    ) external payable returns (bool) {
        return true;
    }

    bool public barWasCalled;

    function bar(uint _x, bool _b) external {
        barWasCalled = true;
    }
}

contract Call {
    function callFoo(address payable _addr) external payable {
        // You can send ether and specify a custom gas amount
        // returns 2 outputs (bool, bytes)
        // bool - whether function executed successfully or not (there was an error)
        // bytes - any output returned from calling the function
        (bool success, bytes memory data) = _addr.call{
            value: msg.value,
            gas: 5000
        }(abi.encodeWithSignature("foo(string,uint256)", "call foo", 123));
        require(success, "tx failed");
    }

    // Calling a function that does not exist triggers the fallback function, if it exists.
    function callDoesNotExist(address _addr) external {
        (bool success, bytes memory data) = _addr.call(
            abi.encodeWithSignature("doesNotExist()")
        );
    }

    function callBar(address _addr) external {
        require(_addr != address(0), "zero address");
        (bool success, ) = _addr.call(
            abi.encodeWithSignature("bar(uint256,bool)", 200, true)
        );
        require(success, "tx failed");
    }
}

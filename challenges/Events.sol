// SPDX-License-Identifier: MIT

/**
Events allow smart contracts to log data to the blockchain without using state variables.

Events are commonly used for debugging, monitoring and a cheap alternative to state variables for storing data.

*/


pragma solidity ^0.8.17;

contract Event {
    event Log(string message, uint val);
    event Message(address indexed _from, address indexed _to, string _message);
    event IndexedLog(address indexed sender, uint val);

    function examples() external {
        emit Log("Foo", 123);
        emit IndexedLog(msg.sender, 123);
    }
    
    function sendMessage(address _addr, string calldata _message) external {
        emit Message(msg.sender, _addr, _message);
    }
}

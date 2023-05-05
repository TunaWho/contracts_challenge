// SPDX-License-Identifier: MIT

/**
Ether can be sent from a contract to another address in 3 ways, transfer, send and call.

How are transfer, send and call different?
transfer (forwards 2300 gas, throws error on failure)
send (forwards 2300 gas, returns bool)
call (forwards specified gas or defaults to all, returns bool and outputs in bytes)

Which function should you use?
call is the recommended method to use for security reasons.

*/

pragma solidity ^0.8.17;

contract SendEther {
    function sendViaTransfer(address payable _to) external payable {
        // This function is no longer recommended for sending Ether.
        _to.transfer(msg.value);
    }

    function sendViaSend(address payable _to) external payable {
        // Send returns a boolean value indicating success or failure.
        // This function is not recommended for sending Ether.
        bool sent = _to.send(msg.value);
        require(sent, "Failed to send Ether");
    }

    function sendViaCall(address payable _to) external payable {
        // Call returns a boolean value indicating success or failure.
        // This is the current recommended method to use.
        (bool sent, bytes memory data) = _to.call{value: msg.value}("");
        require(sent, "Failed to send Ether");
    }
    
    fallback() external payable {}
    
    function sendEth(address payable _to, uint _amount) external {
        require(_to != address(0), "address can not be zero address");
        require(_amount > 0, "amount underflow");
        (bool sent,) = _to.call{value: _amount}("");
        require(sent, "Failed to send Ether");
    }
}

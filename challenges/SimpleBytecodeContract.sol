// SPDX-License-Identifier: MIT

/**
Write a smart contract that always return the number 42. The size of the smart contract must be less than or equal to 10 bytes.

https://www.youtube.com/watch?v=0qQUhsPafJc
*/

pragma solidity ^0.8.17;

contract Factory1 {
    event Log(address addr);

    function deploy() external {
        // Code
    }
}
// solution

contract Factory {
    event Log(address addr);

    function deploy() external {
        bytes memory bytecode = hex"69602a60005260206000f3600052600a6016f3";
        address addr;
        assembly {
            // Deploy contract with bytecode loaded in the memory
            // create(value, offset, size)
            addr := create(0, add(bytecode, 0x20), 0x16)
        }
        require(addr != address(0));

        emit Log(addr);
    }
}
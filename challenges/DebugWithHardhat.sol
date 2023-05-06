// SPDX-License-Identifier: MIT

/**
All solidity challenges in smartcontract.engineer can be debugged with Hardhat's console.sol.

You can print logging messages and contract variables by calling console.log.

Run the tests and messages will be printed along with the output of the tests.

For more info about hardhat, check out the documentation

*/

pragma solidity ^0.8.17;

contract Token {
    mapping(address => uint) public balances;

    constructor() {
        balances[msg.sender] = 100;
    }

    function transfer(address to, uint amount) external {
        balances[msg.sender] -= amount;
        balances[to] += amount;
    }
}

// solution

import "hardhat/console.sol";

contract Token {
    mapping(address => uint) public balances;

    constructor() {
        balances[msg.sender] = 100;
    }

    function transfer(address to, uint amount) external {
        balances[msg.sender] -= amount;
        balances[to] += amount;

        console.log("transfer", msg.sender, to, amount);
    }
}

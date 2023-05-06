// SPDX-License-Identifier: MIT

/**
Let's say you need to call two functions in a smart contract. You will need to send two transactions.

MultiDelegatecall is a handy smart contract that enables a contract to execute multiple functions in a single transaction.

https://www.youtube.com/watch?v=NkTWU6tc9WU
*/

pragma solidity ^0.8.17;

contract MultiDelegatecall {
    function multiDelegatecall(
        bytes[] calldata data
    ) external payable returns (bytes[] memory results) {
        results = new bytes[](data.length);
        for (uint i = 0; i < data.length; i++) {
            (bool success, bytes memory res) = address(this).delegatecall(data[i]);
            
            if (!success) {
                revert("Delegate Failed");
            }
            
            results[i] = res;
        }
    }
}

contract TestMultiDelegatecall is MultiDelegatecall {
    event Log(address caller, string func, uint i);

    function func1(uint x, uint y) external {
        emit Log(msg.sender, "func1", x + y);
    }

    function func2() external returns (uint) {
        emit Log(msg.sender, "func2", 2);
        return 111;
    }
}

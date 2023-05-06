// SPDX-License-Identifier: MIT

/**
MultiCall is a handy contract that queries multiple contracts in a single function call and returns all the results.

This function can be modified to work with call or delegatecall.

However for this challenge we will use staticcall to query other contracts.

Here is the contract that will be called.

https://www.youtube.com/watch?v=PDR054Cy8qM
*/

pragma solidity ^0.8.17;

contract TestMultiCall {
    function test(uint _i) external pure returns (uint) {
        return _i;
    }
}

contract MultiCall {
    function multiCall(
        address[] calldata targets,
        bytes[] calldata data
    ) external view returns (bytes[] memory) {
        require(targets.length == data.length, "Something wrong!");
        bytes[] memory results = new bytes[](data.length);

        for (uint i; i < targets.length; i++) {
            (bool success, bytes memory result) = targets[i].staticcall(data[i]);
            results[i] = result;
            require(success, "Something wrong");
        }

        return results;
    }
}

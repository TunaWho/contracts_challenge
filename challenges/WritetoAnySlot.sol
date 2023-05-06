// SPDX-License-Identifier: MIT

/**
State variables are stored in slots. There are 2 ** 256 - 1 slots, each slot can store up to 32 bytes.

We can write to any slot using assembly. This technique is used in proxy contracts to store the address of the implementation contract.

Write a smart contract that can store an address in any slot.

*/

pragma solidity ^0.8.17;

library StorageSlot1 {
    // Code here
}

contract TestSlot1 {
    bytes32 public constant TEST_SLOT = keccak256("TEST_SLOT");

    function write(address _addr) external {
        // Code here
    }

    function get() external view returns (address) {
        // Code here
    }
}






// solution

library StorageSlot {
    // Wrap address in a struct so that it can be passed around as a storage pointer
    struct AddressSlot {
        address value;
    }

    function getAddressSlot(
        bytes32 slot
    ) internal pure returns (AddressSlot storage pointer) {
        assembly {
            // Get the pointer to AddressSlot stored at slot
            pointer.slot := slot
        }
    }
}

contract TestSlot {
    bytes32 public constant TEST_SLOT = keccak256("TEST_SLOT");

    function write(address _addr) external {
        StorageSlot.AddressSlot storage data = StorageSlot.getAddressSlot(
            TEST_SLOT
        );
        data.value = _addr;
    }

    function get() external view returns (address) {
        StorageSlot.AddressSlot storage data = StorageSlot.getAddressSlot(
            TEST_SLOT
        );
        return data.value;
    }
}
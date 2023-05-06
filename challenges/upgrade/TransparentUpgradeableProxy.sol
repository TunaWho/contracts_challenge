// SPDX-License-Identifier: MIT

/**
Implement a tranparent upgradeable proxy.

This is the library contract to store address to any storage slot.

https://www.youtube.com/watch?v=xluCHy_HB-4
https://www.youtube.com/watch?v=RcyCW1nigog
https://www.youtube.com/watch?v=CLhPUrxwP7k
https://www.youtube.com/watch?v=EUOERNErbyI
https://www.youtube.com/watch?v=KGmV8-NdPgE
*/


pragma solidity ^0.8.17;

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

contract CounterV1 {
    uint public count;

    function inc() external {
        count += 1;
    }
}

contract CounterV2 {
    uint public count;

    function inc() external {
        count += 1;
    }

    function dec() external {
        count -= 1;
    }
}

contract TransparentUpgradeableProxy {
    // Code here

    modifier ifAdmin() {
        // Code here
    }
}

// solution 

contract TransparentUpgradeableProxy2 {
    // All functions / variables should be private, forward all calls to fallback

    // -1 for unknown preimage
    // 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc
    bytes32 private constant IMPLEMENTATION_SLOT =
        bytes32(uint(keccak256("eip1967.proxy.implementation")) - 1);
    // 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103
    bytes32 private constant ADMIN_SLOT =
        bytes32(uint(keccak256("eip1967.proxy.admin")) - 1);

    constructor() {
        _setAdmin(msg.sender);
    }

    modifier ifAdmin() {
        if (msg.sender == _getAdmin()) {
            _;
        } else {
            _fallback();
        }
    }

    function _getAdmin() private view returns (address) {
        return StorageSlot.getAddressSlot(ADMIN_SLOT).value;
    }

    function _setAdmin(address _admin) private {
        require(_admin != address(0), "admin = zero address");
        StorageSlot.getAddressSlot(ADMIN_SLOT).value = _admin;
    }

    function _getImplementation() private view returns (address) {
        return StorageSlot.getAddressSlot(IMPLEMENTATION_SLOT).value;
    }

    function _setImplementation(address _implementation) private {
        require(
            _implementation.code.length > 0,
            "implementation is not contract"
        );
        StorageSlot.getAddressSlot(IMPLEMENTATION_SLOT).value = _implementation;
    }

    // Admin interface //
    function changeAdmin(address _admin) external ifAdmin {
        _setAdmin(_admin);
    }

    function upgradeTo(address _implementation) external ifAdmin {
        _setImplementation(_implementation);
    }

    function admin() external ifAdmin returns (address) {
        return _getAdmin();
    }

    function implementation() external ifAdmin returns (address) {
        return _getImplementation();
    }

    // User interface //
    function _delegate(address _implementation) internal {
        assembly {
            // Copy msg.data. We take full control of memory in this inline assembly
            // block because it will not return to Solidity code. We overwrite the
            // Solidity scratch pad at memory position 0.

            // calldatacopy(t, f, s) - copy s bytes from calldata at position f to mem at position t
            // calldatasize() - size of call data in bytes
            calldatacopy(0, 0, calldatasize())

            // Call the implementation.
            // out and outsize are 0 because we don't know the size yet.

            // delegatecall(g, a, in, insize, out, outsize) -
            // - call contract at address a
            // - with input mem[in…(in+insize))
            // - providing g gas
            // - and output area mem[out…(out+outsize))
            // - returning 0 on error (eg. out of gas) and 1 on success
            let result := delegatecall(
                gas(),
                _implementation,
                0,
                calldatasize(),
                0,
                0
            )

            // Copy the returned data.
            // returndatacopy(t, f, s) - copy s bytes from returndata at position f to mem at position t
            // returndatasize() - size of the last returndata
            returndatacopy(0, 0, returndatasize())

            switch result
            // delegatecall returns 0 on error.
            case 0 {
                // revert(p, s) - end execution, revert state changes, return data mem[p…(p+s))
                revert(0, returndatasize())
            }
            default {
                // return(p, s) - end execution, return data mem[p…(p+s))
                return(0, returndatasize())
            }
        }
    }

    function _fallback() private {
        _delegate(_getImplementation());
    }

    fallback() external payable {
        _fallback();
    }

    receive() external payable {
        _fallback();
    }
}

// SPDX-License-Identifier: MIT

/**
Another way to remove array element while keeping the array without any gaps is to copy the last element into the slot to remove and then remove the last element.

This technique is more gas efficient than shifting array elements. Unlike the array shifting technique this does not preserve order of elements.

*/


pragma solidity ^0.8.17;

contract ArrayReplaceLast {
    uint[] public arr = [1, 2, 3, 4];

    function remove(uint _index) external {
        require(_index < arr.length, "index out of length array");
        arr[_index] = arr[arr.length - 1];
        arr.pop();
    }
}

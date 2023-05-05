// SPDX-License-Identifier: MIT

/**
When an array element is removed using delete, it does not shrink the array length.

This leaves a gap in the array. Here we introduce an technique to shrink the array after removing an element.

*/


pragma solidity ^0.8.17;

contract ArrayShift {
    uint[] public arr = [1, 2, 3];
    
    function moveIndexToEnd(uint _index) internal {
        for (uint i = _index; i < arr.length - 1; i++) {
            arr[i] = arr[i + 1];
        }
    }

    function remove(uint _index) external {
        require(_index < arr.length, "index out of bound");
        moveIndexToEnd(_index);
        arr.pop();
    }
}

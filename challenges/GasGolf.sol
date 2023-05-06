// SPDX-License-Identifier: MIT

/**
Gas optimize this contract.

https://www.youtube.com/watch?v=4r20M9Fr8lY
*/

pragma solidity ^0.8.17;

// visibility - public, private, internal, external
// Gas optimize the function sumIfEvenAndLessThan99 to less than or equal to 48628 gas.

contract GasGolf {
    uint public total;

    function sumIfEvenAndLessThan99(uint[] memory nums) external {
        for (uint i = 0; i < nums.length; i += 1) {
            bool isEven = nums[i] % 2 == 0;
            bool isLessThan99 = nums[i] < 99;
            if (isEven && isLessThan99) {
                total += nums[i];
            }
        }
    }
}

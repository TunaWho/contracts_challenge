// SPDX-License-Identifier: MIT

/**
Underflows and overflows results in an error in Solidity. However this behaviour can be disabled by writing your code inside unchecked.

Unchecked math can save gas.
https://www.youtube.com/watch?v=_pvup5lyC3Q
*/

pragma solidity ^0.8.17;

contract UncheckedMath1 {
    function add(uint x, uint y) external pure returns (uint) {
        // 22291 gas
        // return x + y;

        // 22103 gas
        unchecked {
            return x + y;
        }
    }

    function sub(uint x, uint y) external pure returns (uint) {
        // 22329 gas
        // return x - y;
        // Code
    }

    function sumOfSquares(uint x, uint y) external pure returns (uint) {
        // Wrap complex math logic inside unchecked
        unchecked {
            uint x2 = x * x;
            uint y2 = y * y;

            return x2 + y2;
        }
    }

    function sumOfCubes(uint x, uint y) external pure returns (uint) {
        // Code
    }
}

// solution
contract UncheckedMath {
    function add(uint x, uint y) external pure returns (uint) {
        // 22291 gas
        // return x + y;

        // 22103 gas
        unchecked {
            return x + y;
        }
    }

    function sub(uint x, uint y) external pure returns (uint) {
        // 22329 gas
        // return x - y;

        // 22147 gas
        unchecked {
            return x - y;
        }
    }

    function sumOfSquares(uint x, uint y) external pure returns (uint) {
        // Wrap complex math logic inside unchecked
        unchecked {
            uint x2 = x * x;
            uint y2 = y * y;

            return x2 + y2;
        }
    }

    function sumOfCubes(uint x, uint y) external pure returns (uint) {
        unchecked {
            uint x3 = x * x * x;
            uint y3 = y * y * y;

            return x3 + y3;
        }
    }
}

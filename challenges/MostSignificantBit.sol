// SPDX-License-Identifier: MIT

/**
Find the most significant bit of a number.

For example

1 = 0001 in binary
most significant bit = 0

6 = 0110 in binary
most significant bit = 2

10 = 1010 in binary
most significant bit = 3

https://www.youtube.com/watch?v=qslvI7T6Y6E
https://www.youtube.com/watch?v=M6awK0lskR4
https://www.youtube.com/watch?v=yVh_klUBjWI

*/

pragma solidity ^0.8.17;

contract MostSignificantBit1 {
    function findMostSignificantBit(uint x) external pure returns (uint8 r) {
        // This function will return the most significant bit of uint x.

        // uint8 is used for the output since it will be a number between 0 to 255.
    }
}


// solution

contract MostSignificantBit {
    function findMostSignificantBit(uint x) external pure returns (uint8 r) {
        // x >= 2 ** 128
        if (x >= 0x100000000000000000000000000000000) {
            x >>= 128;
            r += 128;
        }
        // x >= 2 ** 64
        if (x >= 0x10000000000000000) {
            x >>= 64;
            r += 64;
        }
        // x >= 2 ** 32
        if (x >= 0x100000000) {
            x >>= 32;
            r += 32;
        }
        // x >= 2 ** 16
        if (x >= 0x10000) {
            x >>= 16;
            r += 16;
        }
        // x >= 2 ** 8
        if (x >= 0x100) {
            x >>= 8;
            r += 8;
        }
        // x >= 2 ** 4
        if (x >= 0x10) {
            x >>= 4;
            r += 4;
        }
        // x >= 2 ** 2
        if (x >= 0x4) {
            x >>= 2;
            r += 2;
        }
        // x >= 2 ** 1
        if (x >= 0x2) r += 1;
    }
}

contract MostSignificantBitAssembly {
    function mostSignificantBit(uint x) external pure returns (uint msb) {
        assembly {
            let f := shl(7, gt(x, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF))
            x := shr(f, x)
            // or can be replaced with add
            msb := or(msb, f)
        }
        assembly {
            let f := shl(6, gt(x, 0xFFFFFFFFFFFFFFFF))
            x := shr(f, x)
            msb := or(msb, f)
        }
        assembly {
            let f := shl(5, gt(x, 0xFFFFFFFF))
            x := shr(f, x)
            msb := or(msb, f)
        }
        assembly {
            let f := shl(4, gt(x, 0xFFFF))
            x := shr(f, x)
            msb := or(msb, f)
        }
        assembly {
            let f := shl(3, gt(x, 0xFF))
            x := shr(f, x)
            msb := or(msb, f)
        }
        assembly {
            let f := shl(2, gt(x, 0xF))
            x := shr(f, x)
            msb := or(msb, f)
        }
        assembly {
            let f := shl(1, gt(x, 0x3))
            x := shr(f, x)
            msb := or(msb, f)
        }
        assembly {
            let f := gt(x, 0x1)
            msb := or(msb, f)
        }
    }
}
// SPDX-License-Identifier: MIT

/**
Local and state variables have default values.

Here are the default values for data types that we have covered so far.

type	default value
int	0
uint	0
bool	false
address	0x0000000000000000000000000000000000000000
bytes32	0x0000000000000000000000000000000000000000000000000000000000000000

*/


pragma solidity ^0.8.17;

contract DefaultValues {
    int public i; // 0
    bytes32 public b32; // 0x0000000000000000000000000000000000000000000000000000000000000000
    address public addr; // 0x0000000000000000000000000000000000000000
    uint public u;
    bool public b;
}

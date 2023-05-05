// SPDX-License-Identifier: MIT

/**
Mappings are like hash tables or dictionary in Python, they are useful for fast efficient lookups.

*/


pragma solidity ^0.8.17;

contract MappingBasic {
    // Mapping from address to uint used to store balance of addresses
    mapping(address => uint) public balances;

    // Nested mapping from address to address to bool
    // used to store if first address is a friend of second address
    mapping(address => mapping(address => bool)) public isFriend;

    function examples() external {
        // Insert
        balances[msg.sender] = 123;
        // Read
        uint bal = balances[msg.sender];
        // Update
        balances[msg.sender] += 456;
        // Delete
        delete balances[msg.sender];

        // msg.sender is a friend of this contract
        isFriend[msg.sender][address(this)] = true;
    }
    
    function get(address _addr) external view returns(uint) {
        require(_addr != address(0), "Zero Address");
        return balances[_addr];
    }
    
    function set(address _addr, uint _val) external {
        require(_addr != address(0), "Zero Address");
        balances[_addr] = _val;
    }
    
    function remove(address _addr) external {
        require(_addr != address(0), "Zero Address");
        balances[_addr] = 0;
    }
}

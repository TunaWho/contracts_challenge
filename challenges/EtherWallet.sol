// SPDX-License-Identifier: MIT

/**
Create a contract that can receive Ether from anyone. Only the owner can withdraw.

*/

pragma solidity ^0.8.17;

contract EtherWallet {
    address payable public owner;

    constructor() {
        owner = payable(msg.sender);
    }
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Ownable: caller is not the owner");
        _;
    }
    
    fallback() external payable {}
    
    function withdraw(uint _amount) external onlyOwner {
        require(_amount > 0, "amount invalid");
        (bool sent, ) = owner.call{value: _amount}("");
        require(sent, "Failed to send Ether");
    }
}

// SPDX-License-Identifier: MIT

/**
Vault is a contract where users deposit token to earn yield.

Deposit token to mint shares. Burn shares to withdraw token.

This challenge will focus on the math for minting and burning shares.

https://www.youtube.com/watch?v=k7WNibJOBXE
https://www.youtube.com/watch?v=HHoa0c3AOqo
*/


pragma solidity ^0.8.17;

import "./IERC20.sol";

contract Vault {
    IERC20 public immutable token;

    constructor(address _token) {
        token = IERC20(_token);
    }

    function _mint(address _to, uint _shares) private {
        // code here
    }

    function _burn(address _from, uint _shares) private {
        // code here
    }

    function deposit(uint _amount) external {
        // code here
    }

    function withdraw(uint _shares) external {
        // code here
    }
}




// solution

import "./IERC20.sol";

contract Vault {
    IERC20 public immutable token;

    uint public totalSupply;
    mapping(address => uint) public balanceOf;

    constructor(address _token) {
        token = IERC20(_token);
    }

    function _mint(address _to, uint _shares) private {
        totalSupply += _shares;
        balanceOf[_to] += _shares;
    }

    function _burn(address _from, uint _shares) private {
        totalSupply -= _shares;
        balanceOf[_from] -= _shares;
    }

    function deposit(uint _amount) external {
        /*
        a = amount
        B = balance of token before deposit
        T = total supply
        s = shares to mint

        (T + s) / T = (a + B) / B 

        s = aT / B
        */
        uint shares;
        if (totalSupply == 0) {
            shares = _amount;
        } else {
            shares = (_amount * totalSupply) / token.balanceOf(address(this));
        }

        _mint(msg.sender, shares);
        token.transferFrom(msg.sender, address(this), _amount);
    }

    function withdraw(uint _shares) external {
        /*
        a = amount
        B = balance of token before withdaw
        T = total supply
        s = shares to burn

        (T - s) / T = (B - a) / B 

        a = B * s / T
        */
        uint amount = (token.balanceOf(address(this)) * _shares) / totalSupply;
        _burn(msg.sender, _shares);
        token.transfer(msg.sender, amount);
    }
}

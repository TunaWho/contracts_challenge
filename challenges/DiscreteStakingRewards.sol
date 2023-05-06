// SPDX-License-Identifier: MIT

/**
Discrete staking rewards is similar to staking rewards contract. The difference is that the amount of rewards given can vary every second.

https://www.youtube.com/watch?v=mo6rHnDU8us
https://www.youtube.com/watch?v=_I1n1WbRz7o

Declare state variables for storing the amounts of token staked

mapping(address => uint) public balanceOf;
uint public totalSupply;


Declare state variables for calculating rewards

A state variable to store the sum of reward amounts / total staked

uint private rewardIndex;

Mapping that stores the current rewardIndex per staker when the staker either stakes, unstakes or claim rewards.

mapping(address => uint) private rewardIndexOf;

Mapping that stores the amount of rewards earned for each staker

mapping(address => uint) private earned;

A number multiplied with reward amounts. This is used to prevent divisions rounding down to 0.

uint private constant MULTIPLIER = 1e18;


Complete the function updateRewardIndex

function updateRewardIndex(uint reward) external {}

This function will pull in rewards and then update rewardIndex.

Transfer reward amount of rewardToken from msg.sender to this contract
Increment rewardIndex by (reward * MULTIPLIER) / totalSupply

Complete the internal function _calculateRewards

function _calculateRewards(address account) private view returns (uint) {}

This function will return the amount of rewards an account has earned since the last time the account has staked, unstaked or claimed rewards.

Amount of reward is calculated by the following code.

shares * (rewardIndex - rewardIndexOf[account]) / MULTIPLIER

shares is amount staked by account.

rewardIndex - rewardIndex[account] stores the sum of reward / totalSupply since the last time the account has staked, unstaked or claimed.

rewardIndex is scaled up by MULTIPLIER so we divide by MULTIPLIER to get the correct amount of rewards.


Complete the external function calculateRewardsEarned

function calculateRewardsEarned(address account) external view returns (uint) {}

This function will return the amount of rewards the account has earned.

Call the internal function _calcualteRewards to get the rewards earned recently.
Remainder of rewards is stored in earned[account]

Complete the internal function _updateRewards

function _updateRewards(address account) private {}

This function will update the reward earned and reward index of account.

Later we will call this function inside stake, unstake and claim.

Update earned[account] by calling _calculateRewards
Update rewardIndex[account] to current rewardIndex

Complete the function stake

function stake(uint amount) external {}

This function will pull stakingToken from msg.sender.

First, call _updateRewards for msg.sender to update the rewards earned by msg.sender
Update the state variables balanceOf and totalSupply
Transfer stakingToken from msg.sender to this contract.

Complete the function unstake

function unstake(uint amount) external {}

This function will unstake and transfer the stakingToken back to the staker.

Call _updateRewards for msg.sender to update the rewards earned
Update the state variables balanceOf and totalSupply
Transfer the stakingToken to msg.sender

Complete the function claim

function claim() external returns (uint) {}

Claim will send rewards to staker

Update rewards earned by msg.sender by calling _updateRewards
Transfer the reward to msg.sender and reset earned[msg.sender] to 0
Return the amount of reward that was transferred to msg.sender

*/


pragma solidity ^0.8.17;

import "./IERC20.sol";

contract DiscreteStakingRewards1 {
    IERC20 public immutable stakingToken;
    IERC20 public immutable rewardToken;

    constructor(address _stakingToken, address _rewardToken) {
        stakingToken = IERC20(_stakingToken);
        rewardToken = IERC20(_rewardToken);
    }

    function updateRewardIndex(uint reward) external {
        // Code
    }

    function _calculateRewards(address account) private view returns (uint) {
        // Code
    }

    function calculateRewardsEarned(
        address account
    ) external view returns (uint) {
        // Code
    }

    function _updateRewards(address account) private {
        // Code
    }

    function stake(uint amount) external {
        // Code
    }

    function unstake(uint amount) external {
        // Code
    }

    function claim() external returns (uint) {
        // Code
    }
}




// solution

contract DiscreteStakingRewards {
    IERC20 public immutable stakingToken;
    IERC20 public immutable rewardToken;

    mapping(address => uint) public balanceOf;
    uint public totalSupply;

    uint private constant MULTIPLIER = 1e18;
    uint private rewardIndex;
    mapping(address => uint) private rewardIndexOf;
    mapping(address => uint) private earned;

    constructor(address _stakingToken, address _rewardToken) {
        stakingToken = IERC20(_stakingToken);
        rewardToken = IERC20(_rewardToken);
    }

    function updateRewardIndex(uint reward) external {
        rewardToken.transferFrom(msg.sender, address(this), reward);
        rewardIndex += (reward * MULTIPLIER) / totalSupply;
    }

    function _calculateRewards(address account) private view returns (uint) {
        uint shares = balanceOf[account];
        return (shares * (rewardIndex - rewardIndexOf[account])) / MULTIPLIER;
    }

    function calculateRewardsEarned(
        address account
    ) external view returns (uint) {
        return earned[account] + _calculateRewards(account);
    }

    function _updateRewards(address account) private {
        earned[account] += _calculateRewards(account);
        rewardIndexOf[account] = rewardIndex;
    }

    function stake(uint amount) external {
        _updateRewards(msg.sender);

        balanceOf[msg.sender] += amount;
        totalSupply += amount;

        stakingToken.transferFrom(msg.sender, address(this), amount);
    }

    function unstake(uint amount) external {
        _updateRewards(msg.sender);

        balanceOf[msg.sender] -= amount;
        totalSupply -= amount;

        stakingToken.transfer(msg.sender, amount);
    }

    function claim() external returns (uint) {
        _updateRewards(msg.sender);

        uint reward = earned[msg.sender];
        if (reward > 0) {
            earned[msg.sender] = 0;
            rewardToken.transfer(msg.sender, reward);
        }

        return reward;
    }
}

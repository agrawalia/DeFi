//Synthetix Staking Reward
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract StakingReward {
    IERC20 public rewardToken;
    IERC20 public stakingToken;
    
    // amount of tokens invented per sec
    uint public rewardRate= 100;

    // last time this contract was called
    uint public lastUpdateTime;

    uint rewardPerTokenStored;

}




// SPDX-License-Identifier : MIT
// stake : Lock tokens into our smart contract
// withdraw : unlock tokens and pull out of the conract
// claimRewards : users get their reward tokens

pragma solidity ^0.8.7;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Staking {
    IERC20 public s_stakingToken;
    IERC20 public s_rewardToken;

    // address-> how much quantity of tokens it has staked
    mapping(address => uint256) public s_balances;

    //mapping of how much reward each address has to claim
    mapping(address => uint256) public s_rewards;

    // mapping of how much each address has been paid reward tokens
    mapping(address => uint256) public s_UserRewardPerTokenPaid;

    // total no of tokens sent to this contract
    uint256 public s_totalSupply;
    uint256 public s_rewardPerTokenStored;
    uint256 public s_lastUpdateTime;
    uint256 public constant REWARD_RATE = 100; // reward tokens per sec

    error Staking_TransferFailed();
    error Staking_NeedMoreZero();

    modifier updateReward(address account) {
        // how much reward per token
        s_rewardPerTokenStored = RewardPerToken();
        s_lastUpdateTime = block.timestamp;
        s_rewards[account] = Earned(account);
        s_UserRewardPerTokenPaid[account] = s_rewardPerTokenStored;
        _;
    }

    modifier moreThanZero(uint256 amount) {
        if (amount == 0) {
            revert Staking_NeedMoreZero();
        }
        _;
    }

    function RewardPerToken() public view returns (uint256) {
        if (s_totalSupply == 0) {
            return s_rewardPerTokenStored;
        }
        return
            s_rewardPerTokenStored +
            (((block.timestamp - s_lastUpdateTime) * REWARD_RATE) * 1e18) /
            s_totalSupply;
    }

    function Earned(address account) public view returns (uint256) {
        uint256 currentBalance = s_balances[account];
        uint256 amountPaid = s_UserRewardPerTokenPaid[account]; //how much investors have been paid already
        uint256 currentRewardPerToken = RewardPerToken();
        uint256 pastRewards = s_rewards[account];
        uint256 earned = (((currentBalance * (currentRewardPerToken - amountPaid)) / 1e18) +
            pastRewards);
        return earned;
    }

    constructor(address stakingToken, address rewardToken) {
        s_stakingToken = IERC20(stakingToken);
        s_rewardToken = IERC20(rewardToken);
    }

    // We allow only ERC20 tokens for staking

    function Stake(uint256 amount) external updateReward(msg.sender) moreThanZero(amount) {
        // keep track of how much this user has staked
        s_balances[msg.sender] += amount;
        s_totalSupply += amount;
        //emit event
        bool success = s_stakingToken.transferFrom(msg.sender, address(this), amount);

        //require(success, "failed");
        if (!success) {
            revert Staking_TransferFailed();
        }
    }

    function Withdraw(uint256 amount) external updateReward(msg.sender) moreThanZero(amount) {
        s_balances[msg.sender] -= amount;
        s_totalSupply -= amount;
        //emit event
        bool success = s_stakingToken.transfer(msg.sender, amount);

        //require(success, "failed");
        if (!success) {
            revert Staking_TransferFailed();
        }
    }

    function ClaimReward() external updateReward(msg.sender) {
        // How much reward do investors get ?
        uint256 reward = s_rewards[msg.sender];
        bool success = s_rewardToken.transfer(msg.sender, reward);
        if (!success) {
            revert Staking_TransferFailed();
        }

        //
    }
}

pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./Token.sol";

contract GANJESStaking is Ownable(msg.sender) {
    // using SafeMath for uint256;

    GANJESToken public token;

    struct Stake {
        uint256 amount;
        uint256 startTime;
    }

    mapping(address => Stake) public stakes;
    function initialize(GANJESToken _token) external {
            token = _token;
            // minAPR is now inherited from GANJESStakingProxy and should not be re-initialized here
            // maxAPR is now inherited from GANJESStakingProxy and should not be re-initialized here
    }

    function stake(uint256 _amount) external {
        require(_amount > 0, "Staking amount should be greater than 0");
        require(token.balanceOf(msg.sender) >= _amount, "Insufficient balance");

        token.transferFrom(msg.sender, address(this), _amount);

        Stake memory newStake = Stake({amount: _amount, startTime: block.timestamp});

        stakes[msg.sender] = newStake;
    }

    function calculateReward(address _staker,uint256 _minAPR, uint256 _maxAPR) public view returns (uint256) {
        Stake memory userStake = stakes[_staker];
        require(userStake.amount > 0, "No stake found");

        uint256 stakingDuration = block.timestamp - userStake.startTime;
        uint256 stakingDays = stakingDuration / (1 days);

        // Simplified linear reward calculation
        uint256 rewardRate = _minAPR + stakingDays*20/365;// Linear increase from 15% to 35% over a year
        rewardRate = rewardRate > 40 ? _maxAPR : rewardRate; // Cap at 35%

        uint256 reward = (userStake.amount * rewardRate) / 100;
        return reward;
    }

    
    function unstake(uint256 minApr, uint256 maxApr ) external {
        Stake memory userStake = stakes[msg.sender];
        require(userStake.amount > 0, "No stake found");

        uint256 reward = calculateReward(msg.sender,minApr,maxApr);

        // Transfer the staked amount and reward back to the staker
        token.transfer(msg.sender, userStake.amount + reward);

        // Reset the stake
        delete stakes[msg.sender];
    }
}

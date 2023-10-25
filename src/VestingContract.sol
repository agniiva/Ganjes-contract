pragma solidity ^0.8.0;



contract GANJESVesting is Ownable {
    using SafeMath for uint256;

    GANJESToken public token;
    
    // Vesting details in minutes for testing purposes
    uint256 public constant CLIFF_DURATION = 1 minutes;
    uint256 public constant VESTING_DURATION = 4 minutes;
    
    // Addresses of the beneficiaries
    address public teamAndAdvisors;
    address public earlyBackers;
    
    // Vesting start time
    uint256 public vestingStartTime;

    // Amount of tokens vested
    mapping(address => uint256) public vestedAmount;

    constructor(address _token, address _teamAndAdvisors, address _earlyBackers) {
        token = GANJESToken(_token);
        teamAndAdvisors = _teamAndAdvisors;
        earlyBackers = _earlyBackers;
    }
    
    function startVesting() external onlyOwner {
        vestingStartTime = block.timestamp;
    }

    function claim() external {
        require(block.timestamp > vestingStartTime, "Vesting hasn't started yet");
        
        if (msg.sender == teamAndAdvisors) {
            require(block.timestamp > vestingStartTime + CLIFF_DURATION, "Cliff period not reached");
            
            uint256 elapsedTime = block.timestamp - (vestingStartTime + CLIFF_DURATION);
            uint256 claimableAmount = token.balanceOf(address(this)).mul(elapsedTime).div(VESTING_DURATION);
            
            vestedAmount[teamAndAdvisors] = vestedAmount[teamAndAdvisors].add(claimableAmount);
            token.transfer(teamAndAdvisors, claimableAmount);
            
        } else if (msg.sender == earlyBackers) {
            require(block.timestamp > vestingStartTime + CLIFF_DURATION, "1-minute lockup not reached");
            uint256 backersAmount = token.balanceOf(address(this));
            vestedAmount[earlyBackers] = vestedAmount[earlyBackers].add(backersAmount);
            token.transfer(earlyBackers, backersAmount);
        }
    }
}
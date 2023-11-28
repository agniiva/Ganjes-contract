// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "@openzeppelin/contracts/finance/VestingWallet.sol";

contract GANJESVesting is Ownable, ReentrancyGuard {
    using SafeERC20 for IERC20;

    IERC20 public token;

    // Vesting details in seconds for production, you can switch it back to minutes for testing
    uint256 public constant CLIFF_DURATION = 1 minutes;
    uint64 public constant VESTING_DURATION = 4 minutes;
    // address private owner;
    address public teamAndAdvisors;
    address public earlyBackers;

    VestingWallet public teamAndAdvisorsVesting;
    VestingWallet public earlyBackersVesting;

    constructor(address _token)
        Ownable(msg.sender)
        ReentrancyGuard()
    {
        token = IERC20(_token);
    }

    function startVesting() external onlyOwner {
        teamAndAdvisorsVesting = new VestingWallet(
            msg.sender,
            block.timestamp,
            VESTING_DURATION
        );

        earlyBackersVesting = new VestingWallet(
           msg.sender,
            block.timestamp,
            VESTING_DURATION
        );
    }

    function release() external {
        if (msg.sender == teamAndAdvisors) {
            teamAndAdvisorsVesting.release();
        } else if (msg.sender == earlyBackers) {
            earlyBackersVesting.release();
        } else {
            revert("Not eligible to claim");
        }
    }

    function vestingStartTime() external view returns (uint256 teamStartTime, uint256 backersStartTime) {
        teamStartTime = teamAndAdvisorsVesting.start();
        backersStartTime = earlyBackersVesting.start();
    }

    function fundVestingContracts(uint256 teamAmount, uint256 backersAmount) external onlyOwner {
        require(teamAmount > 0 && backersAmount > 0, "Funding amount must be greater than 0");
        token.safeTransfer(address(teamAndAdvisorsVesting), teamAmount);
        token.safeTransfer(address(earlyBackersVesting), backersAmount);
    }
}

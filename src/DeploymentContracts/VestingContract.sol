// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/finance/VestingWallet.sol";
import "./Token.sol";

contract  GANJESVesting {
    // using SafeERC20 for IERC20;
    GANJESToken public token;
    // IERC20 public token;
    mapping(address => VestingWallet) public vestingWallets;


    

    function startBackersVesting(address _backersAddress, uint64 backersDuration) internal {
        require(_backersAddress != address(0), "Address cannot be zero");

        vestingWallets[_backersAddress] = new VestingWallet(
            _backersAddress,
            uint64(block.timestamp),
            backersDuration
        );
    }

    function fundVestingWallet(address beneficiary, uint256 amount, address ICOContract, uint duration) internal {
        require(msg.sender == address(ICOContract), "Only ICO contract can fund");
        VestingWallet wallet = vestingWallets[beneficiary];
        require(address(wallet) != address(0), "Vesting wallet does not exist");
        startBackersVesting(beneficiary, uint64(duration));
        token.transferFrom(ICOContract, address(wallet), amount);
    }

    function tokensRelease(address beneficiary) internal  {
        VestingWallet wallet = vestingWallets[beneficiary];
        require(address(wallet) != address(0), "Not eligible to claim");
        if (block.timestamp >= wallet.start() + wallet.duration()) {
            uint256 amount = wallet.releasable();
            require(amount>0, "Tokens Not Enough");
            wallet.release();
        }
    }
}
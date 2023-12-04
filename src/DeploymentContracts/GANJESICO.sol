// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "./Token.sol";
import "./VestingContract.sol";

contract GANJESICO is ReentrancyGuard, GANJESVesting, Ownable {

    uint256 public tokenPrice;
    uint256 public tokensSold;
    uint256 public maxPurchase;
    uint256 public balanceGanjes;
    address public tokenAddress;
    uint64 public vestingDurationCurrent;
    
    
    event TokensReleased(address indexed beneficiary, uint256 amount);
    event TokensPurchased(address indexed buyer, uint256 amount);

    constructor (uint256 _tokenSupply,uint256 _tokenPrice) payable Ownable(msg.sender)  {
        token = new GANJESToken(_tokenSupply);
        tokenPrice = _tokenPrice;
        maxPurchase = (token.totalSupply() * 33 / 100) * 10 / 100;
        balanceGanjes=token.balanceOf(address(this));
        tokenAddress=address(token);
        vestingDurationCurrent=6*30 days;
    }

   


    function buyTokens(uint256 _numberOfTokens) external payable nonReentrant {
        require(msg.value == _numberOfTokens * tokenPrice, "Incorrect Ether sent");
        require(token.balanceOf(address(this)) >= _numberOfTokens, "Not enough tokens in the contract");
        require(_numberOfTokens <= maxPurchase, "You can't buy more than the maximum allowed");
        
        tokensSold += _numberOfTokens;
        fundVestingWallet(msg.sender, _numberOfTokens, address(this), vestingDurationCurrent);

        emit TokensPurchased(msg.sender, _numberOfTokens);
    }

    function releaseVestedTokens(address beneficiary) external {
        require(beneficiary != address(0), "Invalid Address");
        tokensRelease(beneficiary);

    }

    function setVestingDuration(uint64 durationInMonths) external onlyOwner {
        vestingDurationCurrent=durationInMonths*30 days;
    }

    function endSale() external onlyOwner nonReentrant {
        require(token.transfer(msg.sender, token.balanceOf(address(this))), "Unable to transfer tokens to admin");
    }
}
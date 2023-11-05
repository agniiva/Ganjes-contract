pragma solidity ^0.8.0;

import "./Token.sol";

contract GANJESICO {

    GANJESToken public token;
    address public admin;
    uint256 public tokenPrice;
    uint256 public tokensSold;
    uint256 public maxPurchase;

    event TokensPurchased(address indexed buyer, uint256 amount);

    constructor(address _tokenAddress, uint256 _tokenPrice) {
        token = GANJESToken(_tokenAddress);
        admin = msg.sender;
        tokenPrice = _tokenPrice;
        maxPurchase = (token.totalSupply() * 33 / 100) * 10 / 100;
    }

    function buyTokens(uint256 _numberOfTokens) public payable {
        require(msg.value == _numberOfTokens * tokenPrice, "Incorrect Ether sent");
        require(token.balanceOf(address(this)) >= _numberOfTokens, "Not enough tokens in the contract");
        require(_numberOfTokens <= maxPurchase, "You can't buy more than the maximum allowed");

        tokensSold += _numberOfTokens;
        token.transfer(msg.sender, _numberOfTokens);

        emit TokensPurchased(msg.sender, _numberOfTokens);
    }

    function endSale() public {
        require(msg.sender == admin, "Only the admin can end the sale");
        require(token.transfer(admin, token.balanceOf(address(this))), "Unable to transfer tokens to admin");
    }

}
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract GANJESToken is ERC20, Ownable {
    constructor(uint256 _TOTAL_SUPPLY) Ownable(msg.sender) ERC20("GANJES Token", "GANJES") {
        // Total supply of 3.33 billion tokens
        _TOTAL_SUPPLY = _TOTAL_SUPPLY * (10 ** decimals());

        // Transfer the total supply to the contract's owner
        _mint(msg.sender, _TOTAL_SUPPLY);
    }
}

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract GANJESToken is ERC20, Ownable {
    constructor(uint256 TOTAL_SUPPLY) Ownable(msg.sender) ERC20("GANJES Token", "GANJES") {
        // Total supply of 3.33 billion tokens
        TOTAL_SUPPLY = 3330000000 * (10 ** decimals());

        // Transfer the total supply to the contract's owner
        _mint(msg.sender, TOTAL_SUPPLY);
    }
}

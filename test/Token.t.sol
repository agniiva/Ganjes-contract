pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/Token.sol";
import "../src/VestingContract.sol";
import "forge-std/Vm.sol";
import "forge-std/console.sol";

contract GANJESTokenAndVestingTest is Test {
    GANJESToken token;
    GANJESVesting vesting;

    address owner;
    address teamAndAdvisors;
    address initialInvestors;

    function setUp() public {
        owner = address(this);
        teamAndAdvisors = address(0x1);
        initialInvestors = address(0x2);

        token = new GANJESToken(10000000);
        vesting = new GANJESVesting(address(token));

        token.transfer(address(vesting), 1000000);
    }

    function testDeployment() public {
        assertTrue(address(token) != address(0), "Token address should be set");
        assertTrue(address(vesting) != address(0), "Vesting address should be set");
    }

    function testFailClaimBeforeVestingPeriod() public {
        vesting.release();
        vesting.startVesting();
    }
}

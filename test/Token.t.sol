pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/DeploymentContracts/Token.sol";
import "../src/DeploymentContracts/VestingContract.sol";
import "forge-std/Vm.sol";
import "forge-std/console.sol";

contract GANJESTokenTest is Test {
    GANJESToken token;

    address owner;
    uint256 totalSupply;

    function setUp() public {
        owner = msg.sender;
        totalSupply=10000000;

        token = new GANJESToken(totalSupply);

    }

    function testDeployment() public {
       assertEq(token.balanceOf(address(this)), totalSupply*(10 ** 18));
    }

    //     function testFailClaimBeforeVestingPeriod() public {
    //         vesting.startVesting();
    //         // vesting.release();

    //     }
}

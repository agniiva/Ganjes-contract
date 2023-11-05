
pragma solidity ^0.8.0;

import "../src/VestingContract.sol";
import "../src/Token.sol";
import "ds-test/test.sol";

contract VestingContractTest {

    GANJESVesting vesting;
    GANJESToken token;

    function beforeEach(address _token, address _teamAndAdvisors, address _earlyBackers) public {
        vesting = new GANJESVesting(_token, _teamAndAdvisors, _earlyBackers);
        token = GANJESToken(_token);
    }

    function testInitialization() public {
        assert(address(vesting.token()) == address(token));
    }

    function testVestingStart() public {
        vesting.startVesting();
        uint256 startTime; uint256 endTime;
(startTime, endTime) = vesting.vestingStartTime();
assert(startTime != 0);
    }

    function testRelease() public {
        // Ensure that tokens cannot be claimed before the cliff duration
        try vesting.release() {
            assert(false);
        } catch {
            // Expected revert
        }

    }
    

    function testFunding() public {
        uint256 initialBalance = token.balanceOf(address(vesting));
        uint256 amount = 1000 * 10**18; // Example amount
        token.transfer(address(vesting), amount);
        assert(token.balanceOf(address(vesting)) == initialBalance + amount);
    }

    function invariants() public {
        uint256 initialBalance = token.balanceOf(address(vesting));
        // The total amount of tokens in the VestingWallet contracts should never exceed the initial funding amount
        assert(token.balanceOf(address(vesting)) <= initialBalance);

    }

}
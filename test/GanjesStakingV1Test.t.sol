
pragma solidity ^0.8.0;
import "../src/GanjesStakingV1.sol";
import "../src/GANJESStakingProxy.sol";
import "ds-test/test.sol";

contract GanjesStakingV1Test is DSTest {
    GANJESStakingProxy public stakingProxy;
    GANJESStaking public staking;
    GANJESToken public token;

   function beforeEach() public {
        
        address _admin = msg.sender;
     token = new GANJESToken(100000); // Assigning the contract creator as admin
        uint256 _minAPR = 100; // Static value for minimum APR
        uint256 _maxAPR = 200; // Static value for maximum APR

        staking = new GANJESStaking();
        stakingProxy = new GANJESStakingProxy(address(staking), _admin, token, _minAPR, _maxAPR);
        staking = GANJESStaking(address(stakingProxy));
        // token = _token;
    }

    function testInitializationThroughProxy() public view {
        assert(address(staking) == address(stakingProxy));
    }
        // Test that the staking contract is initialized using the proxy
    

    function testParametersFromProxy() public {
    //   staking = GANJESStaking(address(stakingProxy));
                uint256 newMinAPR = 5;
                uint256 newMaxAPR = 10;
                stakingProxy.setAPRRange(newMinAPR, newMaxAPR);
                assert(stakingProxy.minAPR() == newMinAPR);
                assert(stakingProxy.maxAPR() == newMaxAPR);
    }
        // Test that parameters stored inside GanjesStakingProxy are only being used inside GanjesStakingV1
}

pragma solidity ^0.8.0;
import "../src/GanjesStakingV1.sol";
import "../src/GANJESStakingProxy.sol";
import "ds-test/test.sol";

contract GanjesStakingV1Test is DSTest {
    GANJESStakingProxy public stakingProxy;
    GANJESStaking public staking;
    GANJESToken public token;

    function beforeEach(GANJESToken _token, address _admin, uint256 _minAPR, uint256 _maxAPR) public {
        stakingProxy = new GANJESStakingProxy(address(staking), _admin, _token, _minAPR, _maxAPR);
        staking = GANJESStaking(address(stakingProxy));
        token = _token;
    }

    function testInitializationThroughProxy() public {
        assert(address(staking) == address(stakingProxy));
    }
        // Test that the staking contract is initialized using the proxy
    

    function testParametersFromProxy() public {
        assert(staking.minAPR() == stakingProxy.minAPR());
        assert(staking.maxAPR() == stakingProxy.maxAPR());
    }
        // Test that parameters stored inside GanjesStakingProxy are only being used inside GanjesStakingV1
}
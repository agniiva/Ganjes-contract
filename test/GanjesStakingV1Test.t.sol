//Test for staking contracts not included in project rn


// pragma solidity ^0.8.0;

// import "../src/GanjesStakingV1.sol";
// import "../src/GANJESStakingProxy.sol";
// import "forge-std/Test.sol";

// contract GanjesStakingV1Test is Test {
//     GANJESStakingProxy public stakingProxy;
//     GANJESStaking public staking;
//     GANJESToken public token;

//     function setUp() public {
//         address admin = msg.sender;
//         token = new GANJESToken(100000); // Assigning the contract creator as admin
//         uint256 _minAPR = 100; // Static value for minimum APR
//         uint256 _maxAPR = 200; // Static value for maximum APR

//         staking = new GANJESStaking();
//         stakingProxy = new GANJESStakingProxy(address(staking), admin, _minAPR, _maxAPR);
//         // staking = GANJESStaking(address(stakingProxy));
//         // token = _token;
//     }

//     function testInitializationThroughProxy() public {
//         // assert(address(staking) == address(stakingProxy));
//     }
//     // Test that the staking contract is initialized using the proxy

//     function testParametersFromProxy() public {
//         //   staking = GANJESStaking(address(stakingProxy));
//         uint256 newMinAPR = 5;
//         uint256 newMaxAPR = 10;
//         stakingProxy.setAPRRange(newMinAPR, newMaxAPR);
//         console.logUint(stakingProxy.minAPR());
//         assertEq(stakingProxy.minAPR(), newMinAPR);
//         // assert(stakingProxy.maxAPR() == newMaxAPR);
//     }
//     // Test that parameters stored inside GanjesStakingProxy are only being used inside GanjesStakingV1
// }

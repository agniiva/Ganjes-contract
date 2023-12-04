//Mock tests for old vesting contract

// pragma solidity ^0.8.0;

// import "../src/VestingContract.sol";
// import "../src/Token.sol";
// import "forge-std/Test.sol";
// import "forge-std/console.sol";

// contract VestingContractTest is Test {
//     address private owner;
//     GANJESVesting vesting;
//     GANJESToken token;

//     function setUp() public {
//         token = new GANJESToken(100000);

//         vesting = new GANJESVesting(address(token));

//         owner = msg.sender;
//     }

//     function testInitialization() public {
//         //     // console.log(string(vesting.address()));
//         assertEq(address(vesting.token()), address(token));
//     }

//     function testVestingStart() public {
//         vesting.startVesting();
//         uint256 teamStartTime;
//         uint256 teamEndTime;
//         uint256 earlyBackersStartTime;
//         uint256 earlyBackersEndTime;

//         (teamStartTime, earlyBackersStartTime, teamEndTime, earlyBackersEndTime) = vesting.vestingStartTime();
//         assertEq(teamStartTime, vesting.teamAndAdvisorsVesting().start());
//         assertEq(earlyBackersStartTime, vesting.earlyBackersVesting().start());
//         assertEq(teamEndTime, vesting.teamAndAdvisorsVesting().end());
//         assertEq(earlyBackersEndTime, vesting.earlyBackersVesting().end());
//     }

//     function testRelease() public {
//         // Ensure that tokens cannot be claimed before the cliff duration
//         vesting.startVesting();

//         // assertEq(a, b);
//     }

//     function testFunding() public {
//         uint256 initialBalance = token.balanceOf(address(vesting));
//         uint256 amount = 1000 * 10 ** 18; // Example amount
//         token.transfer(address(vesting), amount);
//         assert(token.balanceOf(address(vesting)) == initialBalance + amount);
//     }

//     function testInvariants(address vestingMock) public view {
//         uint256 initialBalance = token.balanceOf(address(vestingMock));
//         // The total amount of tokens in the VestingWallet contracts should never exceed the initial funding amount
//         assert(token.balanceOf(address(vestingMock)) <= initialBalance);
//     }
// }

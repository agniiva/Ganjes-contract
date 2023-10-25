const GANJESToken = artifacts.require("GANJESToken");
const GANJESVesting = artifacts.require("GANJESVesting");

contract("GANJES Token and Vesting", (accounts) => {
    let token, vesting;
    const owner = accounts[0];
    const teamAndAdvisors = accounts[1];
    const initialInvestors = accounts[2];

    beforeEach(async () => {
        token = await GANJESToken.new({ from: owner });
        vesting = 
        await GANJESVesting.new(token.address, teamAndAdvisors, initialInvestors, { from: owner });
        
        // Transfer some tokens to the vesting contract for testing
        await token.transfer(vesting.address, "1000000", { from: owner });
    });

    it("should correctly deploy the contracts", async () => {
        assert(token);
        assert(vesting);
    });

    it("should set the vesting start time correctly", async () => {
        await vesting.startVesting({ from: owner });
        const startTime = await vesting.vestingStartTime();
        assert.notEqual(startTime.toNumber(), 0, "Vesting start time not set");
    });

    it("should not allow to claim before vesting period", async () => {
        await vesting.startVesting({ from: owner });
        
        try {
            await vesting.claim({ from: teamAndAdvisors });
            assert.fail("Claim was allowed before vesting period");
        } catch (error) {
            assert(error.message.indexOf("revert") >= 0, "Expected revert error, but got: " + error.message);
        }
    });

    it("should allow to claim after vesting period", async () => {
        await vesting.startVesting({ from: owner });
        
        // Simulating passing of time in the test environment
        await new Promise(resolve => setTimeout(resolve, 2000));  // 2 seconds delay to simulate time passing

        await vesting.claim({ from: teamAndAdvisors });
        const balance = await token.balanceOf(teamAndAdvisors);
        assert.notEqual(balance.toNumber(), 0, "Tokens were not claimed");
    });
});
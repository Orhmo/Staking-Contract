
const { ethers, deployments} = require("hardhat");
const {  expect, assert } = require("chai");

describe("Staking", () => {
  let StakingFactory
  let Staking
  let Stakeholders
  let stakedAmount = ethers.utils.parseEther ("2")
  let stakeholder
  let deployer
  let StakeholdersAddress

  beforeEach(async() => {
      Stakeholders = await ethers.getSigners();
      deployer = Stakeholders[0];
      stakeholder = Stakeholders[1];
      StakingFactory = await ethers.getContractFactory("Staking");
      Staking = await StakingFactory.deploy();
  })

  describe("Stake", () => {

  it ("deploys a stake", async () => {
    assert.ok(Staking.address)
  });

  it("allows people to stake tokens and requires a minimum stake", async () => {
    await expect(Staking.stake()).to.be.revertedWith(
      "Minimum stake is 1 ether"
    )
  });

  it("Should allow people stake an amount greater than minimum stake", async () => {
      console.log('\t'," Stakeholder Address: ", deployer.address)

      console.log('\t',"  Staking...")
      tx = await Staking.stake({ value: stakedAmount })

      console.log('\t',"  Waiting for confirmation...")
      const txResponse = await Staking.getstakeholdersIndex
      (
        deployer.address
      )

      assert.equal(txResponse.toString(), stakedAmount.toString())

      const newBalance = await Staking.getBalance()
      console.log('\t',"  New balance: ", ethers.utils.formatEther(newBalance))
      expect(newBalance).to.equal(stakedAmount);
    });

    it("Adds staker to array of stakeholders", async () => {
      await Staking.stake({ value: stakedAmount })
      const staker = await Staking.getStakeholders(0)
      assert.equal(deployer.address, staker)
      expect(await Staking.getStakeholder()).to.include(deployer.address);
      expect(await Staking.isStakeholder(deployer.address)).to.be.true;
    });



  describe ("Withdraw", () => {
    beforeEach(async () => {
      await Staking.stake({ value: stakedAmount})
      Stakeholders = await ethers.getSigners()
      StakingFactory = await ethers.getContractFactory("Staking");
    })

    it("should fail to allow withdraws from non stakeholders", async () => {
      const NonStaker = await Staking.connect(
        Stakeholders[2]
      )
      await expect(
        NonStaker.withdrawStake()
      ).to.be.revertedWith("Only a stakeholder can call this function")
    });

    it("allows stakeholder withdraw stake and reward after unlock date", async () => {
      console.log('\t',"  Withdrawing...")
      await expect (await Staking.withdrawStake()).to.changeEtherBalances(
        [ deployer.address, Staking ],
        [ stakedAmount, stakedAmount.mul("-1") ]
      );
       expect(await Staking.getstakeholdersIndex(deployer.address)).to.equal(0);

    });
  });
});
})

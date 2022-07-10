const main = async () => {
  const stakedAmount = ethers.utils.parseEther("3");

  const [Stakeholders] = await ethers.getSigners();
  const deployer = Stakeholders[0];
  console.log('Address deploying the contract -->', Stakeholders.address);

  const StakingFactory = await ethers.getContractFactory("Staking");
  const staking = await StakingFactory.deploy();

  console.log('Staking contract adddress -->', staking.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });

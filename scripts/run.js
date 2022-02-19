const main = async () => {
  const [owner, randomPerson] = await hre.ethers.getSigners();
  const domainContractFactory = await hre.ethers.getContractFactory("Domains");
  const domainContract = await domainContractFactory.deploy('ibis');
  await domainContract.deployed();
  console.log("Contract deployed to:", domainContract.address);
  console.log("Contract deployed by:", owner.address);

  let txn = await domainContract.register("itoka", {value: hre.ethers.utils.parseEther('0.1')});
  await txn.wait();

  const balance = await hre.ethers.provider.getBalance(domainContract.address);
  console.log("Contract balance:", hre.ethers.utils.formatEther(balance));

  const domainOwner = await domainContract.getAddress("itoka");
  console.log("Owner of domain itoka:", domainOwner);

  const addressDomain = await domainContract.getDomain(owner.address);
  console.log("Domain for %s:%s",domainContract.address,addressDomain);


  txn = await domainContract.setAllRecords("itoka", "Itoka", "https://open.spotify.com/track/5Y0hkLkzdrTuPGWYLvm6oO?si=04a4fc609d35498a","seba_itokazu");
  await txn.wait();

  const domainRecords = await domainContract.getRecord('itoka');
  console.log("Record of domain itoka:", domainRecords);
};

const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (error) {
    console.log(error);
    process.exit(1);
  }
};

runMain();

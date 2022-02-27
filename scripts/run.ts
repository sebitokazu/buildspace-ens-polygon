import { run, ethers } from "hardhat";

const main = async () => {

  await run("compile");

  const [owner, randomPerson] = await ethers.getSigners();
  const domainContractFactory = await ethers.getContractFactory("Domains");
  const domainContract = await domainContractFactory.deploy("ibis");
  await domainContract.deployed();
  console.log("Contract deployed to:", domainContract.address);
  console.log("Contract deployed by:", owner.address);

  let txn = await domainContract.register("itoka", {
    value: ethers.utils.parseEther("0.1"),
  });
  await txn.wait();

  const balance = await ethers.provider.getBalance(domainContract.address);
  console.log("Contract balance:", ethers.utils.formatEther(balance));

  const domainOwner = await domainContract.getAddress("itoka");
  console.log("Owner of domain itoka:", domainOwner);

  txn = await domainContract.setAllRecords(
    "itoka",
    "Itoka",
    "https://open.spotify.com/track/5Y0hkLkzdrTuPGWYLvm6oO?si=04a4fc609d35498a",
    "seba_itokazu"
  );
  await txn.wait();

  const domainRecords = await domainContract.getRecord("itoka");
  console.log("Record of domain itoka:", domainRecords);

  const names = await domainContract.getAllNames();
  console.log("All minted domains: ", names);

  // Quick! Grab the funds from the contract! (as superCoder)
  try {
    txn = await domainContract.connect(randomPerson).withdraw();
    await txn.wait();
  } catch (error) {
    console.log("Could not rob contract");
  }

  // Let's look in their wallet so we can compare later
  let ownerBalance = await ethers.provider.getBalance(owner.address);
  console.log("Balance of owner before withdrawal:", ethers.utils.formatEther(ownerBalance));

  // Oops, looks like the owner is saving their money!
  txn = await domainContract.connect(owner).withdraw();
  await txn.wait();
  
  // Fetch balance of contract & owner
  const contractBalance = await ethers.provider.getBalance(domainContract.address);
  ownerBalance = await ethers.provider.getBalance(owner.address);

  console.log("Contract balance after withdrawal:", ethers.utils.formatEther(contractBalance));
  console.log("Balance of owner after withdrawal:", ethers.utils.formatEther(ownerBalance));

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

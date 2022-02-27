import { run, ethers } from "hardhat";

const main = async () => {
    await run("compile");

    const domainContractFactory = await ethers.getContractFactory('Domains');
    const domainContract = await domainContractFactory.deploy("ibis");
    await domainContract.deployed();
  
    console.log("Contract deployed to:", domainContract.address);
  
    let txn = await domainContract.register("d10s",  {value: ethers.utils.parseEther('0.3')});
    await txn.wait();
    console.log("Minted domain d10s.ibis");
  
    txn = await domainContract.setAllRecords("d10s", "Diegote", "https://open.spotify.com/track/5s8onl5Lw5q1AijP5BUm7G?si=eb2b46ed48594777", "");
    await txn.wait();
    console.log("Set all records for d10s.ibis");
  
    const address = await domainContract.getAddress("d10s");
    console.log("Owner of domain d10s:", address);
  
    const balance = await ethers.provider.getBalance(domainContract.address);
    console.log("Contract balance:", ethers.utils.formatEther(balance));
  }
  
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
const {
    time,
    loadFixture,
  } = require("@nomicfoundation/hardhat-toolbox/network-helpers");
  const { anyValue } = require("@nomicfoundation/hardhat-chai-matchers/withArgs");
  const { expect } = require("chai");
  
describe("ERC777 Attack", async () => {
  let ERC1820Registry;
  let ERC777TokenContract;
  let attackerContract;
  let attacker;
  let withdrawalLimit =10;
  let ERC777TokensRecipientInterface = "0xb281fc8c12954d22544db45de3159a39272895b169a852b314f9cc762e44c53b" //keccak256("ERC777TokensRecipient");

  beforeEach("deploy contract", async () => {
    [attacker] = await ethers.getSigners();
     ERC1820Registry = await ethers.deployContract("ERC1820Registry");
     ERC777TokenContract = await ethers.deployContract("VulnerableAccessToken", [withdrawalLimit,ERC1820Registry.target]); //Initial Mint amount is 1000 tokens
     attackerContract = await ethers.deployContract("MaliciousRecipient", [ERC777TokenContract.target,withdrawalLimit,ERC1820Registry.target]);

  });
  it("should be deployed", async () => {
    console.log("ERC1820Registry address: ", ERC1820Registry.target);
    console.log("ERC777TokenContract address: ", ERC777TokenContract.target);
    console.log("attackerContract address: ", attackerContract.target);
  });

  it("Registry value should be changed", async () => {
    const addressContract = await ERC1820Registry.getInterfaceImplementer(attackerContract.target,ERC777TokensRecipientInterface);
    console.log("Registry value: ", addressContract);
    expect(addressContract).to.equal(attackerContract.target);
  })

  it("check balance", async () => {
    const totalSupply = await ERC777TokenContract.totalSupply();
    console.log("Total supply: ", totalSupply.toString());
    expect(totalSupply.toString()).to.equal("1000");
  });

  it("check balance of attacker contract should be 0", async () => {
    const balance = await ERC777TokenContract.balanceOf(attackerContract.target);
    console.log("balance of attacker contract: ", balance.toString());
    expect(balance.toString()).to.equal("0");
  
  });

  it("Start attack and then check balance of attacker contract", async () => {
    await attackerContract.callWithdraw(); //attack function
    const balance = await ERC777TokenContract.balanceOf(attackerContract.target);
    console.log("balance of attacker contract: ", balance.toString());
    expect(balance.toString()).to.equal("110"); //the withdraw amount is 110 tokens because firstly it will run then the again 10 times each time 10 tokens will be deducted;
  
  })

  it("Once attack is complete we cannot claim before 1 day", async () => {
    await attackerContract.callWithdraw(); //attack function
    const balance = await ERC777TokenContract.balanceOf(attackerContract.target);
    console.log("balance of attacker contract: ", balance.toString());
    const tx =  attackerContract.callWithdraw(); //attack function
    await expect(tx).to.be.revertedWith("Withdrawal not allowed yet.");
  })
});

const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Transactions", function () {
  let Transactions, transactions, owner;

  beforeEach(async () => {
    [owner] = await ethers.getSigners();
    Transactions = await ethers.getContractFactory("Transactions");
    transactions = await Transactions.deploy(owner.address);
    await transactions.deployed();
  });

  it("should create transaction entry", async function () {
    const txHash = "0x1234...";
    await transactions.createTxnEntry(
      txHash,
      owner.address,
      addr1.address,
      "0x0000...",
      "19.07",
      "72.81"
    );

    const tx = await transactions.transactions(0);
    expect(tx.txnHash).to.equal(txHash);
    expect(tx.fromAddr).to.equal(owner.address);
  });

  it("should validate transaction chain", async function () {
    await transactions.createTxnEntry("0x1234...", owner.address, addr1.address, "0x0000...", "19.07", "72.81");
    await expect(
      transactions.createTxnEntry("0xabcd...", owner.address, addr1.address, "0xdeadbeef", "18.52", "73.91")
    ).to.be.revertedWith("Transaction error occurred!");
  });
});
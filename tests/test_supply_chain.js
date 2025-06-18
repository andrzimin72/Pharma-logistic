const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("SupplyChain", function () {
  let SupplyChain, supplyChain, RawMaterial, rawMaterial;

  beforeEach(async () => {
    [owner, addr1, addr2] = await ethers.getSigners();

    SupplyChain = await ethers.getContractFactory("SupplyChain");
    supplyChain = await SupplyChain.deploy();
    await supplyChain.deployed();

    RawMaterial = await ethers.getContractFactory("RawMaterial");
    rawMaterial = await RawMaterial.deploy(
      owner.address,
      "0x1234...",
      "Paracetamol",
      1000,
      addr1.address,
      addr2.address
    );
    await rawMaterial.deployed();
  });

  it("should register user as supplier", async function () {
    await supplyChain.registerUser("John", ["Mumbai"], 1, addr1.address);
    const user = await supplyChain.userInfo(addr1.address);
    expect(user.name).to.equal("John");
    expect(user.role).to.equal(1); // supplier
  });

  it("should create raw material", async function () {
    await supplyChain.supplierCreatesRawPackage("Aspirin", 500, addr1.address, addr2.address);
    const count = await supplyChain.supplierGetPackageCount();
    expect(count).to.equal(1);
  });
});
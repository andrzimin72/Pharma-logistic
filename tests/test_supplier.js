const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Supplier", function () {
  let Supplier, supplier, owner, addr1;

  beforeEach(async () => {
    [owner, addr1] = await ethers.getSigners();
    Supplier = await ethers.getContractFactory("Supplier");
    supplier = await Supplier.deploy();
    await supplier.deployed();
  });

  it("should create raw material", async function () {
    await supplier.createRawMaterialPackage("Paracetamol", 1000, addr1.address, owner.address);
    const packages = await supplier.getAllPackages();
    expect(packages.length).to.equal(1);
  });

  it("should return correct number of packages", async function () {
    await supplier.createRawMaterialPackage("Paracetamol", 1000, addr1.address, owner.address);
    const count = await supplier.getNoOfPackagesOfSupplier();
    expect(count).to.equal(1);
  });
});
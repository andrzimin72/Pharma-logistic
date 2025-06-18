const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("RawMaterial", function () {
  let RawMaterial, rawMaterial, owner, addr1, addr2;

  beforeEach(async () => {
    [owner, addr1, addr2] = await ethers.getSigners();
    RawMaterial = await ethers.getContractFactory("RawMaterial");
    rawMaterial = await RawMaterial.deploy(
      owner.address,
      "0x1234567890abcdef",
      "Paracetamol",
      1000,
      addr1.address,
      addr2.address
    );
    await rawMaterial.deployed();
  });

  it("should create a raw material", async function () {
    const status = await rawMaterial.getRawMaterialStatus();
    expect(status).to.equal(0); // atCreator
  });

  it("should allow transporter to pick up package", async function () {
    await rawMaterial.pickPackage(addr1.address);
    const status = await rawMaterial.getRawMaterialStatus();
    expect(status).to.equal(1); // picked
  });
});
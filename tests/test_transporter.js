const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Transporter", function () {
  let Transporter, transporter, RawMaterial, rawMaterial;

  beforeEach(async () => {
    [owner, addr1, addr2] = await ethers.getSigners();

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

    Transporter = await ethers.getContractFactory("Transporter");
    transporter = await Transporter.deploy();
    await transporter.deployed();
  });

  it("should handle raw material transport", async function () {
    await transporter.handlePackage(rawMaterial.address, 1, "0x0000000000000000000000000000000000000000");
    const status = await rawMaterial.getRawMaterialStatus();
    expect(status).to.equal(1); // picked
  });
});
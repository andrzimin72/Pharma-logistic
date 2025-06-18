const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Manufacturer", function () {
  let Manufacturer, manufacturer, RawMaterial, rawMaterial, Medicine, medicine;

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

    Manufacturer = await ethers.getContractFactory("Manufacturer");
    manufacturer = await Manufacturer.deploy();
    await manufacturer.deployed();
  });

  it("should receive raw material", async function () {
    await manufacturer.manufacturerReceivedPackage(rawMaterial.address, owner.address);
    const materials = await manufacturer.getManufacturerRawMaterials(owner.address);
    expect(materials[0]).to.equal(rawMaterial.address);
  });

  it("should create new medicine", async function () {
    await manufacturer.manufacturerCreatesMedicine(
      owner.address,
      "Aspirin",
      [rawMaterial.address],
      500,
      [addr1.address],
      addr2.address,
      2
    );
    const medicines = await manufacturer.getManufacturerMedicines(owner.address);
    expect(medicines.length).to.equal(1);
  });
});
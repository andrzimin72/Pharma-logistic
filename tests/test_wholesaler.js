const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Wholesaler", function () {
  let Wholesaler, wholesaler, Medicine, medicine;

  beforeEach(async () => {
    [owner, addr1, addr2] = await ethers.getSigners();

    Medicine = await ethers.getContractFactory("Medicine");
    medicine = await Medicine.deploy(
      owner.address,
      "Aspirin",
      [],
      500,
      [addr1.address],
      addr2.address,
      1
    );
    await medicine.deployed();

    Wholesaler = await ethers.getContractFactory("Wholesaler");
    wholesaler = await Wholesaler.deploy();
    await wholesaler.deployed();
  });

  it("should receive medicine", async function () {
    await wholesaler.medicineRecievedAtWholesaler(medicine.address);
    const status = await medicine.getBatchIDStatus();
    expect(status).to.equal(3); // deliveredAtW
  });

  it("should transfer medicine to distributor", async function () {
    await wholesaler.transferMedicineWtoD(medicine.address, addr1.address, addr2.address);
    const subContracts = await wholesaler.MedicineWtoD(owner.address);
    expect(subContracts.length).to.equal(1);
  });
});
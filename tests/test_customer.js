const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Customer", function () {
  let Customer, customer, Medicine, medicine;

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
      2
    );
    await medicine.deployed();

    Customer = await ethers.getContractFactory("Customer");
    customer = await Customer.deploy();
    await customer.deployed();
  });

  it("should receive medicine", async function () {
    await customer.medicineRecievedAtCustomer(medicine.address, addr2.address);
    const status = await medicine.getBatchIDStatus();
    expect(status).to.equal(6); // deliveredAtC
  });

  it("should verify medicine provenance", async function () {
    const isValid = await customer.verifyMedicineProvenance(medicine.address);
    expect(isValid).to.be.true;
  });
});
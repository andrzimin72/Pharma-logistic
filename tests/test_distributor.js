const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Distributor", function () {
  let Distributor, distributor, Medicine, medicine;

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

    Distributor = await ethers.getContractFactory("Distributor");
    distributor = await Distributor.deploy();
    await distributor.deployed();
  });

  it("should receive medicine", async function () {
    await distributor.medicineRecievedAtDistributor(medicine.address, addr1.address);
    const status = await medicine.getBatchIDStatus();
    expect(status).to.equal(4); // deliveredAtD
  });

  it("should transfer medicine to customer", async function () {
    await distributor.transferMedicineDtoC(medicine.address, addr1.address, addr2.address);
    const subContracts = await distributor.MedicineDtoC(owner.address);
    expect(subContracts.length).to.equal(1);
  });
});
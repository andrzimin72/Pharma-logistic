const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Medicine", function () {
  let Medicine, medicine, owner, addr1, addr2;

  beforeEach(async () => {
    [owner, addr1, addr2] = await ethers.getSigners();
    Medicine = await ethers.getContractFactory("Medicine");
    medicine = await Medicine.deploy(
      owner.address,
      "Aspirin",
      [addr1.address],
      500,
      [addr2.address],
      addr1.address,
      1
    );
    await medicine.deployed();
  });

  it("should return correct medicine info", async function () {
    const info = await medicine.getMedicineInfo();
    expect(info._manufacturerAddr).to.equal(owner.address);
    expect(info._description).to.equal("Aspirin");
  });

  it("should allow transporter to pick medicine", async function () {
    await medicine.pickMedicine(addr2.address);
    const status = await medicine.getBatchIDStatus();
    expect(status).to.be.oneOf([1, 2]); // pickedForW or pickedForD
  });

  it("should update status after delivery", async function () {
    await medicine.pickMedicine(addr2.address);
    await medicine.receivedMedicine(addr1.address);
    const status = await medicine.getBatchIDStatus();
    expect(status).to.be.oneOf([3, 4]); // deliveredAtW or deliveredAtD
  });
});
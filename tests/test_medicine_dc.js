const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("MedicineD_C", function () {
  let MedicineD_C, medDC, owner, addr1, addr2;

  beforeEach(async () => {
    [owner, addr1, addr2] = await ethers.getSigners();
    MedicineD_C = await ethers.getContractFactory("MedicineD_C");
    medDC = await MedicineD_C.deploy(
      "0x1234567890abcdef",
      owner.address,
      addr1.address,
      addr2.address
    );
    await medDC.deployed();
  });

  it("should start with status 'atcreator'", async function () {
    const status = await medDC.getBatchIDStatus();
    expect(status).to.equal(0); // atcreator
  });

  it("should allow transporter to call pickDC()", async function () {
    await medDC.pickDC(medicineAddress, addr1.address);
    const status = await medDC.getBatchIDStatus();
    expect(status).to.equal(1); // picked
  });

  it("should allow customer to receive package", async function () {
    await medDC.pickDC(medicineAddress, addr1.address);
    await medDC.receiveDC(medicineAddress, addr2.address);
    const status = await medDC.getBatchIDStatus();
    expect(status).to.equal(2); // delivered
  });
});
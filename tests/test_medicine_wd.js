const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("MedicineW_D", function () {
  let MedicineW_D, medWD, owner, addr1, addr2;

  beforeEach(async () => {
    [owner, addr1, addr2] = await ethers.getSigners();
    MedicineW_D = await ethers.getContractFactory("MedicineW_D");
    medWD = await MedicineW_D.deploy(
      "0x1234567890abcdef",
      owner.address,
      addr1.address,
      addr2.address
    );
    await medWD.deployed();
  });

  it("should start with status 'atcreator'", async function () {
    const status = await medWD.getBatchIDStatus();
    expect(status).to.equal(0); // atcreator
  });

  it("should allow transporter to call pickWD()", async function () {
    await medWD.pickWD(medicineAddress, addr1.address);
    const status = await medWD.getBatchIDStatus();
    expect(status).to.equal(1); // picked
  });

  it("should allow distributor to receive package", async function () {
    await medWD.pickWD(medicineAddress, addr1.address);
    await medWD.receiveWD(medicineAddress, addr2.address);
    const status = await medWD.getBatchIDStatus();
    expect(status).to.equal(2); // delivered
  });
});
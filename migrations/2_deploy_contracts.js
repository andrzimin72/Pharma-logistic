const SupplyChain = artifacts.require("SupplyChain");
const RawMaterial = artifacts.require("RawMaterial");
const Medicine = artifacts.require("Medicine");
const MedicineW_D = artifacts.require("MedicineW_D");
const MedicineD_C = artifacts.require("MedicineD_C");
const Transactions = artifacts.require("Transactions");

module.exports = async function(deployer, network, accounts) {
  const [deployerAddr] = accounts;

  // Deploy RawMaterial
  await deployer.deploy(RawMaterial, deployerAddr, "0x1234...", "Paracetamol", 1000, deployerAddr, deployerAddr);
  const rawMaterial = await RawMaterial.deployed();
  console.log("RawMaterial deployed at:", rawMaterial.address);

  // Deploy Medicine
  await deployer.deploy(Medicine, deployerAddr, "Aspirin", [rawMaterial.address], 500, [deployerAddr], deployerAddr, 1);
  const medicine = await Medicine.deployed();
  console.log("Medicine deployed at:", medicine.address);

  // Deploy MedicineW_D
  await deployer.deploy(MedicineW_D, medicine.address, deployerAddr, deployerAddr, deployerAddr);
  const medWD = await MedicineW_D.deployed();
  console.log("MedicineW_D deployed at:", medWD.address);

  // Deploy MedicineD_C
  await deployer.deploy(MedicineD_C, medicine.address, deployerAddr, deployerAddr, deployerAddr);
  const medDC = await MedicineD_C.deployed();
  console.log("MedicineD_C deployed at:", medDC.address);

  // Deploy Transactions
  await deployer.deploy(Transactions, deployerAddr);
  const transactions = await Transactions.deployed();
  console.log("Transactions deployed at:", transactions.address);

  // Deploy SupplyChain
  await deployer.deploy(SupplyChain);
  const supplyChain = await SupplyChain.deployed();
  console.log("SupplyChain deployed at:", supplyChain.address);
};
require("dotenv").config();
const hre = require("hardhat");

async function main() {
  const [deployer] = await hre.ethers.getSigners();

  console.log("Deploying contracts with the account:", deployer.address);
  console.log("Account balance:", (await deployer.getBalance()).toString());

  // Deploy RawMaterial
  const RawMaterial = await hre.ethers.getContractFactory("RawMaterial");
  const rawMaterial = await RawMaterial.deploy(
    deployer.address,
    "0x1234567890abcdef",
    "Paracetamol",
    1000,
    deployer.address,
    deployer.address
  );
  await rawMaterial.deployed();
  console.log("RawMaterial deployed to:", rawMaterial.address);

  // Deploy Medicine
  const Medicine = await hre.ethers.getContractFactory("Medicine");
  const medicine = await Medicine.deploy(
    deployer.address,
    "Aspirin",
    [rawMaterial.address],
    500,
    [deployer.address],
    deployer.address,
    1
  );
  await medicine.deployed();
  console.log("Medicine deployed to:", medicine.address);

  // Deploy MedicineW_D
  const MedicineW_D = await hre.ethers.getContractFactory("MedicineW_D");
  const medWD = await MedicineW_D.deploy(
    medicine.address,
    deployer.address,
    deployer.address,
    deployer.address
  );
  await medWD.deployed();
  console.log("MedicineW_D deployed to:", medWD.address);

  // Deploy MedicineD_C
  const MedicineD_C = await hre.ethers.getContractFactory("MedicineD_C");
  const medDC = await MedicineD_C.deploy(
    medicine.address,
    deployer.address,
    deployer.address,
    deployer.address
  );
  await medDC.deployed();
  console.log("MedicineD_C deployed to:", medDC.address);

  // Deploy Transactions
  const Transactions = await hre.ethers.getContractFactory("Transactions");
  const transactions = await Transactions.deploy(deployer.address);
  await transactions.deployed();
  console.log("Transactions deployed to:", transactions.address);

  // Deploy SupplyChain
  const SupplyChain = await hre.ethers.getContractFactory("SupplyChain");
  const supplyChain = await SupplyChain.deploy();
  await supplyChain.deployed();
  console.log("SupplyChain deployed to:", supplyChain.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
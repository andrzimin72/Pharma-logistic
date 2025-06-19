# Pharma-logistic
The proposed system offers a decentralized, tamper-proof, and transparent way to manage pharmaceutical supply chains. Combining blockchain with AI improves both operational efficiency and customer trust. The system can be extended to other industries like food supply or luxury goods to combat counterfeiting.

1. These contracts manage the lifecycle of medicines, from raw materials to final delivery to customers. Here's a breakdown of each file and its purpose:

1.1.  Medicine.sol. This is the core Medicine contract that defines the structure and behavior of medicine tracking in the supply chain. 
Key Features:  Tracks medicine properties: description, rawMaterials, manufacturer, wholesaler, distributor, customer, quantity. Uses an enum medicineStatus to track the current state (e.g., at manufacturer, picked for delivery, delivered). Emits events like ShippmentUpdate for transparency.
Functions include:
-pickMedicine() – Called by transporter to pick up medicine;
-receivedMedicine() – Called by wholesaler/distributor upon receipt;
-sendWtoD() / receivedWtoD() – Transfer between wholesaler and distributor;
-sendDtoC() / receivedDtoC() – Final delivery to customer.
Deploys a new Transactions contract during creation for logging transaction history.

1.2. Manufacturer.sol. Manages how manufacturers receive raw materials and create medicines.
Key Features: Uses mappings to track:
-manufacturerRawMaterials: Raw materials owned by a manufacturer;
-manufacturerMedicines: Medicines created by a manufacturer.
Functions include:
-manufacturerReceivedPackage() – Records receipt of raw material;
-manufacturerCreatesMedicine() – Creates a new medicine using raw materials.

1.3. Distributor.sol. Handles how distributors receive and forward medicines to customers.
Key Features: Mappings:
- MedicinesAtDistributor: Stores list of medicines received;
- MedicineDtoC: Tracks medicine transfers to customers;
- MedicineDtoCTxContract: Links to transaction contracts.
Functions:
- medicineRecievedAtDistributor() – Logs when medicine arrives;
- transferMedicineDtoC() – Initiates transfer to a customer with a new MedicineD_C contract.

1.4. MedicineD_C.sol
Represents the direct transfer of medicine from Distributor to Customer .
Key Features:
- tracks entities involved: sender, transporter, receiver;
- uses an enum packageStatus (atcreator, picked, delivered).
Functions:
-pickDC() – Transporter picks up medicine;
-receiveDC() – Customer receives medicine;
-get_addressStatus() – Returns current status of the package.

2. System Workflow Summary
Here’s how these contracts interact in the supply chain:
Supplier → Manufacturer: Raw materials are tracked via RawMaterial.sol (not shown here), and the manufacturer receives them using manufacturerReceivedPackage().
Manufacturer creates Medicine: Using manufacturerCreatesMedicine(), a new Medicine contract is deployed.
Manufacturer → Wholesaler/Distributor: The medicine is picked and transferred using pickMedicine() and receivedMedicine().
Wholesaler → Distributor: Handled via sendWtoD() and receivedWtoD().
Distributor → Customer: Managed by transferMedicineDtoC(), which creates a MedicineD_C contract to handle the transfer.
Transporter involvement: Each transfer requires a transporter to call pickDC() before delivering to the next entity.

3. Suggestions & Observations
Event Logging: Events like ShippmentUpdate help with traceability and can be used in the DApp for real-time updates.
Access Control: Most functions have require() checks for authorization, ensuring only valid roles can perform actions.
Transaction Tracking: A new Transactions contract is created per medicine to log movements with details like sender, receiver, timestamp, and location.
Possible Improvements:
- consider adding error messages in require() statements for better debugging.
- ensure all contracts use consistent naming and code formatting.
- add modifiers for role-based access control instead of inline checks where possible.

4. Solidity smart contract files that together form a blockchain-based pharmaceutical supply chain system, as described in the paper titled "Blockchain and AI in Pharmaceutical Supply Chain". I'll walk you through each file, explain its role, and how they work together to provide traceability, transparency, and anti-counterfeiting capabilities.

4.1. MedicineW_D.sol
This contract handles the transfer of medicine from Wholesaler to Distributor.
Key Features:
- tracks entities: sender, transporter, receiver;
- uses an enum packageStatus: atcreator, picked, delivered.
Functions:
- pickWD() – Called by transporter to pick up medicine;
- receiveWD() – Called by distributor upon receipt.
Updates the main Medicine contract with status changes (sendWtoD() and receivedWtoD()).

4.2. Migrations.sol
Standard Truffle migration contract used to manage deployment scripts on the Ethereum blockchain.
Key Features:
- ensures only the owner can upgrade or set migration status;
- used internally by Truffle framework; no business logic.

4.3. RawMaterial.sol
Tracks raw materials (e.g., chemical ingredients) used by manufacturers to produce medicines.
Key Features:
- status tracking: atCreator, picked, delivered;
- events: Logs shipment updates for transparency.
Functions:
- pickPackage() – Transporter picks raw material;
- receivedPackage() – Manufacturer receives raw material;
- emits events like ShippmentUpdate.

4.4. Supplier.sol
Manages suppliers who create and register raw material packages.
Key Features:
- allows supplier to create raw material packages using createRawMaterialPackage();
- stores list of raw materials per supplier.
Functions:
- getNoOfPackagesOfSupplier() – Returns number of packages created;
- getAllPackages() – Returns all package addresses.

4.5. SupplyChain.sol
Main contract that inherits and coordinates roles like Supplier, Manufacturer, Wholesaler, Distributor, Customer, and Transporter.
Key Features:
- role-based access control using modifiers;
- enum roles: Defines user types (supplier, manufacturer, etc.);
- events: buyEvent, respondEvent, sendEvent, receivedEvent – for traceability.
User management:
- registerUser() – Owner adds users with roles;
- changeUserRole() – Owner updates roles.
Function wrappers for each role:
- supplierCreatesRawPackage() – Creates raw materials;
- manufacturerCreatesNewMedicine() – Produces new medicine;
- wholesalerReceivedMedicine() – Receives medicine;
- distributorTransferMedicinetoCustomer() – Sends to customer;
- customerReceivedMedicine() – Final delivery.

4.6. System Workflow Summary
Here’s how these contracts interact:
Supplier → Manufacturer
Supplier creates raw material via createRawMaterialPackage().
Transporter calls pickPackage() to pick up raw material.
Manufacturer calls receivedPackage() to receive it.
Manufacturer → Wholesaler/Distributor
Manufacturer creates medicine via manufacturerCreatesMedicine().
Calls pickMedicine() to send to wholesaler/distributor.
Receiver calls receivedMedicine().
Wholesaler → Distributor
Wholesaler uses transferMedicineW_D() to pass medicine to distributor.
pickWD() and receiveWD() handle the transfer.
Distributor → Customer
Distributor calls transferMedicineDtoC() to send to customer.
Transporter picks up via pickDC(), customer receives via receiveDC().
All steps are logged in the blockchain via events and transaction contracts , ensuring full traceability.

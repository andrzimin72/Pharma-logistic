// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

import "./Medicine.sol";
import "./Transactions.sol";
import "./SupplyChainBase.sol";

contract Customer is SupplyChainBase {
    // Stores medicines received by the customer
    mapping(address => address[]) public medicinesAtCustomer;

    // Maps medicine address to transaction contract
    mapping(address => address) public medicineTxContract;

    string public ipfsHash; // Off-chain metadata storage

    event MedicineReceived(address indexed customer, address indexed medicine);

    /**
     * @dev Customer receives medicine
     */
    function medicineRecievedAtCustomer(address _medicineAddr) public onlyRole(Role.Customer) {
        Medicine medicine = Medicine(_medicineAddr);
        (, , , , address receiver) = medicine.getBatchIDStatus(); // Adjust based on your Medicine.sol structure

        require(receiver == msg.sender, "Only designated customer can receive");

        uint rtype = medicine.receivedMedicine(msg.sender);
        require(rtype == 3, "Invalid medicine type");

        medicinesAtCustomer[msg.sender].push(_medicineAddr);

        emit MedicineReceived(msg.sender, _medicineAddr);
    }

    /**
     * @dev Set IPFS hash for off-chain verification
     */
    function setIPFSHash(string memory _ipfsHash) public onlyRole(Role.Customer) {
        ipfsHash = _ipfsHash;
    }

    /**
     * @dev Get IPFS hash for off-chain verification
     */
    function getIPFSHash() public view returns (string memory) {
        return ipfsHash;
    }

    /**
     * @dev Get all medicines owned by a customer
     */
    function getMyMedicines()
        public
        view
        returns (address[] memory)
    {
        return medicinesAtCustomer[msg.sender];
    }

    /**
     * @dev Verify medicine provenance
     */
    function verifyMedicineProvenance(address _medicineAddr)
        public
        view
        returns (bool)
    {
        Medicine medicine = Medicine(_medicineAddr);
        (, address manufacturer, , address wholesaler, address distributor) = medicine.getMedicineInfo();

        return (manufacturer != address(0) && wholesaler != address(0) && distributor != address(0));
    }
}
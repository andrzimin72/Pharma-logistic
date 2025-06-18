// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

import "./Medicine.sol";
import "./MedicineD_C.sol";
import "./SupplyChainBase.sol";

contract Distributor is SupplyChainBase {
    // Stores medicines currently at the distributor
    mapping(address => address[]) public medicinesAtDistributor;

    // Tracks transfers from distributor to customer
    mapping(address => address[]) public medicineDtoCTransfers;

    // Maps medicine address to its transfer contract
    mapping(address => address) public medicineDtoCTxContract;

    event MedicineReceivedByDistributor(address indexed distributor, address indexed medicine);
    event MedicineTransferredToCustomer(address indexed distributor, address indexed medicine, address customer);

    /**
     * @dev Distributor receives medicine
     */
    function medicineRecievedAtDistributor(address _medicineAddr) public onlyRole(Role.Distributor) {
        Medicine medicine = Medicine(_medicineAddr);
        (, , , address receiver,) = medicine.getBatchIDStatus(); // Adjust based on your Medicine.sol structure

        require(receiver == msg.sender, "Only designated receiver can call this");

        uint rtype = medicine.receivedMedicine(msg.sender);
        require(rtype == 2, "Invalid medicine type");

        medicinesAtDistributor[msg.sender].push(_medicineAddr);

        emit MedicineReceivedByDistributor(msg.sender, _medicineAddr);
    }

    /**
     * @dev Transfer medicine from distributor to customer
     */
    function transferMedicineDtoC(
        address _medicineAddr,
        address _transporterAddr,
        address _customerAddr
    ) public onlyRole(Role.Distributor) {
        MedicineD_C medicineD_C = new MedicineD_C(
            _medicineAddr,
            msg.sender,
            _transporterAddr,
            _customerAddr
        );

        medicineDtoCTransfers[msg.sender].push(address(medicineD_C));
        medicineDtoCTxContract[_medicineAddr] = address(medicineD_C);

        emit MedicineTransferredToCustomer(msg.sender, _medicineAddr, _customerAddr);
    }

    /**
     * @dev Get all medicines at the distributor
     */
    function getMedicinesForDistributor()
        public
        view
        returns (address[] memory)
    {
        return medicinesAtDistributor[msg.sender];
    }

    /**
     * @dev Get medicine transfer contract for a specific medicine
     */
    function getSubContractDC(address _medicineAddr)
        public
        view
        returns (address)
    {
        return medicineDtoCTxContract[_medicineAddr];
    }
}
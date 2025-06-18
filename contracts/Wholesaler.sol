// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

import "./Medicine.sol";
import "./MedicineW_D.sol";
import "./SupplyChainBase.sol";

contract Wholesaler is SupplyChainBase {
    // Stores medicines currently at the wholesaler
    mapping(address => address[]) public medicinesAtWholesaler;

    // Tracks transfers from wholesaler to distributor
    mapping(address => address[]) public medicineWtoDTransfers;

    // Maps medicine address to its transfer contract
    mapping(address => address) public medicineWtoDTxContract;

    event MedicineReceivedByWholesaler(address indexed wholesaler, address indexed medicine);
    event MedicineTransferredToDistributor(address indexed wholesaler, address indexed medicine, address distributor);

    /**
     * @dev Wholesaler receives medicine
     */
    function medicineRecievedAtWholesaler(address _medicineAddr) public onlyRole(Role.Wholesaler) {
        Medicine medicine = Medicine(_medicineAddr);
        (, , , address receiver,) = medicine.getBatchIDStatus(); // Adjust based on your Medicine.sol structure

        require(receiver == msg.sender, "Only designated receiver can call this");

        uint rtype = medicine.receivedMedicine(msg.sender);
        require(rtype == 1, "Invalid medicine type");

        medicinesAtWholesaler[msg.sender].push(_medicineAddr);

        emit MedicineReceivedByWholesaler(msg.sender, _medicineAddr);
    }

    /**
     * @dev Transfer medicine from wholesaler to distributor
     */
    function transferMedicineWtoD(
        address _medicineAddr,
        address _transporterAddr,
        address _distributorAddr
    ) public onlyRole(Role.Wholesaler) {
        MedicineW_D medicineW_D = new MedicineW_D(
            _medicineAddr,
            msg.sender,
            _transporterAddr,
            _distributorAddr
        );

        medicineWtoDTransfers[msg.sender].push(address(medicineW_D));
        medicineWtoDTxContract[_medicineAddr] = address(medicineW_D);

        emit MedicineTransferredToDistributor(msg.sender, _medicineAddr, _distributorAddr);
    }

    /**
     * @dev Get all medicines at the wholesaler
     */
    function getMedicinesForWholesaler()
        public
        view
        returns (address[] memory)
    {
        return medicinesAtWholesaler[msg.sender];
    }

    /**
     * @dev Get medicine transfer contract for a specific medicine
     */
    function getSubContractWD(address _medicineAddr)
        public
        view
        returns (address)
    {
        return medicineWtoDTxContract[_medicineAddr];
    }
}
// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

import "./Supplier.sol";
import "./Manufacturer.sol";
import "./Wholesaler.sol";
import "./Distributor.sol";
import "./Customer.sol";
import "./Transporter.sol";
import "./SupplyChainBase.sol";

contract SupplyChain is SupplyChainBase {
    // Entities
    Supplier public supplier;
    Manufacturer public manufacturer;
    Wholesaler public wholesaler;
    Distributor public distributor;
    Customer public customer;
    Transporter public transporter;

    event UserRegistered(address indexed user, bytes32 name, Role role);
    event RawMaterialCreated(address indexed rawMaterialAddress, address indexed creator);
    event MedicineCreated(address indexed medicineAddress, address indexed creator);

    constructor() {
        // Initialize main supply chain entities
        supplier = new Supplier();
        manufacturer = new Manufacturer();
        wholesaler = new Wholesaler();
        distributor = new Distributor();
        customer = new Customer();
        transporter = new Transporter();
    }

    /**
     * @dev Register a user with a specific role
     */
    function registerUser(
        address _userAddr,
        bytes32 _name,
        string memory _location,
        Role _role
    ) public onlyOwner {
        registerUser(_userAddr, _name, _location, _role);
        emit UserRegistered(_userAddr, _name, _role);
    }

    /**
     * @dev Create a raw material package (Supplier)
     */
    function createRawMaterial(
        bytes32 _description,
        uint _quantity,
        address _transporterAddr,
        address _manufacturerAddr
    ) public onlyRole(Role.Supplier) {
        RawMaterial rawMaterial = new RawMaterial(
            msg.sender,
            keccak256(abi.encodePacked(msg.sender, block.timestamp)),
            _description,
            _quantity,
            _transporterAddr,
            _manufacturerAddr
        );
        emit RawMaterialCreated(address(rawMaterial), msg.sender);
    }

    /**
     * @dev Manufacturer creates a new medicine
     */
    function createMedicine(
        bytes32 _description,
        address[] memory _rawAddr,
        uint _quantity,
        address[] memory _transporterAddr,
        address _receiverAddr,
        uint rcvrType
    ) public onlyRole(Role.Manufacturer) {
        Medicine medicine = new Medicine(
            msg.sender,
            _description,
            _rawAddr,
            _quantity,
            _transporterAddr,
            _receiverAddr,
            rcvrType
        );
        emit MedicineCreated(address(medicine), msg.sender);
    }

    /**
     * @dev Move product through the supply chain
     */
    function handleShipment(
        address _product,
        uint8 transporterType,
        address _cid
    ) public onlyRole(Role.Transporter) {
        transporter.handlePackage(_product, transporterType, _cid);
    }

    /**
     * @dev Get list of all medicines created by a manufacturer
     */
    function getManufacturerMedicines(address _manufacturer)
        public
        view
        returns (address[] memory)
    {
        return manufacturer.getManufacturerMedicines(_manufacturer);
    }

    /**
     * @dev Get list of all raw materials received by a manufacturer
     */
    function getManufacturerRawMaterials(address _manufacturer)
        public
        view
        returns (address[] memory)
    {
        return manufacturer.getManufacturerRawMaterials(_manufacturer);
    }

    /**
     * @dev Get list of medicines at a distributor
     */
    function getDistributorMedicines(address _distributor)
        public
        view
        returns (address[] memory)
    {
        return distributor.getMedicinesForDistributor();
    }

    /**
     * @dev Get list of medicines at a customer
     */
    function getCustomerMedicines(address _customer)
        public
        view
        returns (address[] memory)
    {
        return customer.getMyMedicines();
    }

    /**
     * @dev Verify the origin of a medicine
     */
    function verifyMedicineProvenance(address _medicineAddr)
        public
        view
        returns (bool)
    {
        return customer.verifyMedicineProvenance(_medicineAddr);
    }
}
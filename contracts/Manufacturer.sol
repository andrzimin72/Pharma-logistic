// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

import "./RawMaterial.sol";
import "./Medicine.sol";
import "./SupplyChainBase.sol";

contract Manufacturer is SupplyChainBase {
    // Mapping from manufacturer address to list of raw material addresses
    mapping(address => address[]) public manufacturerRawMaterials;

    // Mapping from manufacturer address to list of medicine addresses
    mapping(address => address[]) public manufacturerMedicines;

    event RawMaterialReceived(address indexed manufacturer, address rawMaterialAddress);
    event MedicineCreated(address indexed manufacturer, address medicineAddress);

    constructor() {}

    /**
     * @dev Manufacturer receives raw material package
     * Only callable by the manufacturer
     */
    function manufacturerReceivedPackage(
        address _rawMaterialAddr,
        address _manufacturerAddress
    ) public onlyRole(Role.Manufacturer) {
        RawMaterial(_rawMaterialAddr).receivedPackage(_manufacturerAddress);
        manufacturerRawMaterials[_manufacturerAddress].push(_rawMaterialAddr);

        emit RawMaterialReceived(_manufacturerAddress, _rawMaterialAddr);
    }

    /**
     * @dev Manufacturer creates new medicine
     * Only callable by the manufacturer
     */
    function manufacturerCreatesMedicine(
        bytes32 _description,
        address[] memory _rawAddr,
        uint _quantity,
        address[] memory _transporterAddr,
        address _receiverAddr,
        uint rcvrType
    ) public onlyRole(Role.Manufacturer) {
        Medicine _medicine = new Medicine(
            msg.sender,
            _description,
            _rawAddr,
            _quantity,
            _transporterAddr,
            _receiverAddr,
            rcvrType
        );

        manufacturerMedicines[msg.sender].push(address(_medicine));

        emit MedicineCreated(msg.sender, address(_medicine));
    }

    /**
     * @dev Get all raw materials received by a manufacturer
     */
    function getManufacturerRawMaterials(address _manufacturer)
        public
        view
        returns (address[] memory)
    {
        return manufacturerRawMaterials[_manufacturer];
    }

    /**
     * @dev Get all medicines created by a manufacturer
     */
    function getManufacturerMedicines(address _manufacturer)
        public
        view
        returns (address[] memory)
    {
        return manufacturerMedicines[_manufacturer];
    }
}
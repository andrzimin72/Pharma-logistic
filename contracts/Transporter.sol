// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

import "./SupplyChainBase.sol";
import "./RawMaterial.sol";
import "./Medicine.sol";
import "./MedicineW_D.sol";
import "./MedicineD_C.sol";

contract Transporter is SupplyChainBase {
    event ShipmentUpdate(
        address indexed product,
        address indexed from,
        address indexed to,
        uint8 transporterType,
        uint8 status
    );

    constructor() {}

    /**
     * @dev Handle package movement based on transporter type
     */
    function handlePackage(
        address _addr,
        uint8 transporterType,
        address cid
    ) public onlyRole(Role.Transporter) {
        if (transporterType == 1) {
            // Supplier -> Manufacturer
            RawMaterial(_addr).pickPackage(msg.sender);
        } else if (transporterType == 2) {
            // Manufacturer -> Wholesaler
            Medicine(_addr).pickMedicine(msg.sender);
        } else if (transporterType == 3) {
            // Wholesaler -> Distributor
            MedicineW_D(cid).pickWD(_addr, msg.sender);
        } else if (transporterType == 4) {
            // Distributor -> Customer
            MedicineD_C(cid).pickDC(_addr, msg.sender);
        }
    }

    /**
     * @dev Verify that the current user is a transporter
     */
    function verifyTransporter() public view returns (bool) {
        return users[msg.sender].role == Role.Transporter;
    }
}
// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

import "./SupplyChainBase.sol";

contract MedicineW_D is SupplyChainBase {
    enum PackageStatus { Created, Picked, Delivered }

    address public medId;
    address public sender;
    address public transporter;
    address public receiver;
    PackageStatus public status;

    event ShipmentUpdate(
        address indexed product,
        address indexed from,
        address indexed to,
        uint8 transporterType,
        uint8 status
    );

    constructor(
        address _medId,
        address _sender,
        address _transporter,
        address _receiver
    ) {
        medId = _medId;
        sender = _sender;
        transporter = _transporter;
        receiver = _receiver;
        status = PackageStatus.Created;
    }

    function pickWD(address _transporterAddr) public onlyRole(Role.Transporter) {
        require(transporter == _transporterAddr, "Only assigned transporter can call this function.");
        require(status == PackageStatus.Created, "Package already picked or delivered.");

        status = PackageStatus.Picked;

        emit ShipmentUpdate(medId, sender, receiver, 3, uint8(status));
    }

    function receiveWD(address _receiverAddr) public onlyRole(Role.Distributor) {
        require(receiver == _receiverAddr, "Only assigned distributor can receive.");
        require(status == PackageStatus.Picked, "Not yet picked up.");

        status = PackageStatus.Delivered;

        emit ShipmentUpdate(medId, sender, receiver, 3, uint8(status));
    }

    function getBatchIDStatus() public view returns (uint8) {
        return uint8(status);
    }
}
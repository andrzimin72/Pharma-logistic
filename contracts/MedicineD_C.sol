// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

import "./SupplyChainBase.sol";

contract MedicineD_C is SupplyChainBase {
    enum PackageStatus { Created, Picked, Delivered }

    address public medId;
    address public sender;
    address public transporter;
    address public receiver;
    PackageStatus public status;

    string public ipfsHash; // Off-chain metadata storage

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

    function pickDC(address _transporterAddr) public onlyRole(Role.Transporter) {
        require(transporter == _transporterAddr, "Only assigned transporter can call this function.");
        require(status == PackageStatus.Created, "Package already picked or delivered.");

        status = PackageStatus.Picked;

        emit ShipmentUpdate(medId, sender, receiver, 4, uint8(status));
    }

    function receiveDC(address _receiverAddr) public onlyRole(Role.Customer) {
        require(receiver == _receiverAddr, "Only assigned customer can receive.");
        require(status == PackageStatus.Picked, "Not yet picked up.");

        status = PackageStatus.Delivered;

        emit ShipmentUpdate(medId, sender, receiver, 4, uint8(status));
    }

    function getBatchIDStatus() public view returns (uint8) {
        return uint8(status);
    }

    function setIPFSHash(string memory _ipfsHash) public onlyOwner {
        ipfsHash = _ipfsHash;
    }

    function getIPFSHash() public view returns (string memory) {
        return ipfsHash;
    }
}
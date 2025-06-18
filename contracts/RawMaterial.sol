// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

import "./SupplyChainBase.sol";
import "./Transactions.sol";

contract RawMaterial is SupplyChainBase {
    enum PackageStatus { Created, Picked, Delivered }

    struct RawMaterialData {
        bytes32 description;
        uint quantity;
        address transporter;
        address manufacturer;
        address supplier;
        PackageStatus status;
        string ipfsHash; // Off-chain metadata
        address txnContractAddress;
    }

    mapping(address => RawMaterialData) public rawMaterials;

    event ShipmentUpdate(
        address indexed productId,
        address indexed transporter,
        address indexed manufacturer,
        uint8 transporterType,
        uint8 status
    );

    function createRawMaterial(
        address _creatorAddr,
        bytes32 _description,
        uint _quantity,
        address _transporterAddr,
        address _manufacturerAddr,
        string memory _ipfsHash
    ) public onlyRole(Role.Supplier) {
        RawMaterialData storage rawMat = rawMaterials[_creatorAddr];

        rawMat.description = _description;
        rawMat.quantity = _quantity;
        rawMat.transporter = _transporterAddr;
        rawMat.manufacturer = _manufacturerAddr;
        rawMat.supplier = _creatorAddr;
        rawMat.status = PackageStatus.Created;
        rawMat.ipfsHash = _ipfsHash;

        Transactions txContract = new Transactions(_creatorAddr);
        rawMat.txnContractAddress = address(txContract);

        emit ShipmentUpdate(
            _creatorAddr,
            _transporterAddr,
            _manufacturerAddr,
            1, // transporter type
            uint8(PackageStatus.Created)
        );
    }

    function pickPackage(address _transporterAddr) public onlyRole(Role.Transporter) {
        RawMaterialData storage rawMat = rawMaterials[msg.sender];

        require(rawMat.transporter == _transporterAddr, "Only assigned transporter can pick.");
        require(rawMat.status == PackageStatus.Created, "Already picked or delivered.");

        rawMat.status = PackageStatus.Picked;

        emit ShipmentUpdate(
            msg.sender,
            _transporterAddr,
            rawMat.manufacturer,
            1,
            uint8(PackageStatus.Picked)
        );
    }

    function receivePackage(address _manufacturerAddr) public onlyRole(Role.Manufacturer) {
        RawMaterialData storage rawMat = rawMaterials[msg.sender];

        require(rawMat.manufacturer == _manufacturerAddr, "Only assigned manufacturer can receive.");
        require(rawMat.status == PackageStatus.Picked, "Not yet picked up.");

        rawMat.status = PackageStatus.Delivered;

        emit ShipmentUpdate(
            msg.sender,
            rawMat.transporter,
            _manufacturerAddr,
            1,
            uint8(PackageStatus.Delivered)
        );
    }

    function getRawMaterialInfo(address _addr) public view returns (
        bytes32 description,
        uint quantity,
        address transporter,
        address manufacturer,
        address supplier,
        uint8 status,
        string memory ipfsHash
    ) {
        RawMaterialData storage rawMat = rawMaterials[_addr];
        return (
            rawMat.description,
            rawMat.quantity,
            rawMat.transporter,
            rawMat.manufacturer,
            rawMat.supplier,
            uint8(rawMat.status),
            rawMat.ipfsHash
        );
    }
}
// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

import "./RawMaterial.sol";
import "./SupplyChainBase.sol";

contract Supplier is SupplyChainBase {
    mapping(address => address[]) public supplierRawMaterials;

    event RawMaterialCreated(
        address indexed supplier,
        address indexed rawMaterialAddress,
        bytes32 description,
        uint256 quantity
    );

    function createRawMaterialPackage(
        bytes32 _description,
        uint256 _quantity,
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

        supplierRawMaterials[msg.sender].push(address(rawMaterial));

        emit RawMaterialCreated(
            msg.sender,
            address(rawMaterial),
            _description,
            _quantity
        );
    }

    function getNoOfPackagesOfSupplier() public view returns (uint256) {
        return supplierRawMaterials[msg.sender].length;
    }

    function getAllPackages() public view returns (address[] memory) {
        return supplierRawMaterials[msg.sender];
    }
}
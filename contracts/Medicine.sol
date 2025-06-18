// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

import "./SupplyChainBase.sol";
import "./RawMaterial.sol";

contract Medicine is SupplyChainBase {
    struct Product {
        bytes32 description;
        address manufacturer;
        address wholesaler;
        address distributor;
        address customer;
        uint quantity;
        string ipfsHash;
    }

    mapping(address => Product) public products;

    event ShipmentUpdate(
        address indexed product,
        address indexed from,
        address indexed to,
        uint status
    );

    function createMedicine(
        bytes32 _description,
        address[] memory _rawAddr,
        uint _quantity,
        address _receiverAddr,
        uint rcvrType,
        string memory _ipfsHash
    ) public onlyRole(Role.Manufacturer) {
        Product storage product = products[msg.sender];
        product.description = _description;
        product.manufacturer = msg.sender;
        product.quantity = _quantity;
        product.ipfsHash = _ipfsHash;

        if (rcvrType == 1) {
            product.wholesaler = _receiverAddr;
        } else if (rcvrType == 2) {
            product.distributor = _receiverAddr;
        }

        emit ShipmentUpdate(address(this), address(0), msg.sender, 0);
    }

    function getMedicineInfo()
        public
        view
        returns (
            bytes32 description,
            address manufacturer,
            uint quantity,
            string memory ipfsHash
        )
    {
        Product storage product = products[msg.sender];
        return (
            product.description,
            product.manufacturer,
            product.quantity,
            product.ipfsHash
        );
    }
}
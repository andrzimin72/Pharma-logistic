// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

contract SupplyChainBase {
    enum Role {
        NoRole,
        Supplier,
        Transporter,
        Manufacturer,
        Wholesaler,
        Distributor,
        Customer
    }

    struct User {
        bytes32 name;
        string location;
        Role role;
    }

    mapping(address => User) public users;
    address public owner;

    modifier onlyOwner() {
        require(users[msg.sender].role == Role.Supplier && msg.sender == owner, "Only owner");
        _;
    }

    modifier onlyRole(Role _role) {
        require(users[msg.sender].role == _role, "Unauthorized");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function registerUser(
        address _addr,
        bytes32 _name,
        string memory _location,
        Role _role
    ) external onlyOwner {
        users[_addr] = User(_name, _location, _role);
    }
}
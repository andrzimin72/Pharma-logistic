// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

contract Migrations {
    address public owner;
    uint256 public last_completed_migration;

    // Restrict function access to owner only
    modifier restricted() {
        require(msg.sender == owner, "Only contract owner can call this");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    /**
     * @dev Set the completed migration level
     */
    function setCompleted(uint256 completed) external restricted {
        last_completed_migration = completed;
    }

    /**
     * @dev Upgrade the contract and transfer migration state
     */
    function upgrade(address newAddress) external restricted {
        Migrations upgraded = Migrations(newAddress);
        upgraded.setCompleted(last_completed_migration);
    }
}
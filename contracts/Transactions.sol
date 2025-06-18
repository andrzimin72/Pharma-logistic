// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

import "./SupplyChainBase.sol";

contract Transactions is SupplyChainBase {
    struct Txn {
        bytes32 txnHash;
        address fromAddr;
        address toAddr;
        bytes32 prevTxn;
        string latitude;
        string longitude;
        uint256 timestamp;
    }

    Txn[] public transactions;
    uint256 public txnCount = 0;

    event TxnCreated(
        bytes32 indexed txnHash,
        address indexed from,
        address indexed to,
        bytes32 prev,
        uint256 timestamp,
        string latitude,
        string longitude
    );

    constructor(address _creator) SupplyChainBase() {
        registerUser(_creator, "Owner", "Global HQ", Role.Supplier);
    }

    function createTxnEntry(
        bytes32 _txnHash,
        address _from,
        address _to,
        bytes32 _prev,
        string memory _latitude,
        string memory _longitude
    ) public onlyRole(Role.Transporter) {
        if (txnCount > 0) {
            require(transactions[txnCount - 1].txnHash == _prev, "Invalid transaction chain.");
        }

        uint256 _timestamp = block.timestamp;

        transactions.push(Txn(_txnHash, _from, _to, _prev, _latitude, _longitude, _timestamp));
        txnCount++;

        emit TxnCreated(_txnHash, _from, _to, _prev, _timestamp, _latitude, _longitude);
    }

    function getAllTransactions() public view returns (Txn[] memory) {
        Txn[] memory ret = new Txn[](txnCount);
        for (uint256 i = 0; i < txnCount; i++) {
            ret[i] = transactions[i];
        }
        return ret;
    }
}
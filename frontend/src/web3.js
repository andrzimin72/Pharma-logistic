import Web3 from 'web3';

let web3;

if (window.ethereum) {
    web3 = new Web3(window.ethereum);
    try {
        await window.ethereum.enable(); // Legacy MetaMask
    } catch (error) {
        console.log("User denied account access");
    }
} else if (window.web3) {
    web3 = new Web3(window.web3.currentProvider);
} else {
    web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:7545"));
}

export default web3;
require('dotenv').config();
const HDWalletProvider = require('@truffle/hdwallet-provider');

module.exports = {
  networks: {
    development: {
      host: "127.0.0.1",
      port: 7545,
      network_id: "*",
    },
    goerli: {
      provider: () =>
        new HDWalletProvider(
          process.env.PRIVATE_KEY,
          `https://goerli.infura.io/v3/${process.env.INFURA_API_KEY}` 
        ),
      network_id: 5,
      gas: 5500000,
      confirmations: 2,
      timeoutBlocks: 200,
      skipDryRun: true,
    }
  },
  compilers: {
    solc: {
      version: "^0.8.0",
    }
  }
};
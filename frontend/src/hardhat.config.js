require("@nomiclabs/hardhat-waffle");
require("dotenv").config();

module.exports = {
  solidity: "0.8.0", // Make sure this matches your contract versions
  networks: {
    goerli: {
      url: `https://goerli.infura.io/v3/${process.env.INFURA_API_KEY}`, 
      accounts: [`0x${process.env.PRIVATE_KEY}`],
    },
  },
};
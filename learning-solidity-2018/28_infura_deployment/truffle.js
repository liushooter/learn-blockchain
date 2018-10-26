require('babel-register');
require('babel-polyfill');
require('dotenv').config();
const hdkey = require('ethereumjs-wallet/dist/hdkey');

const HDWalletProvider = require("truffle-hdwallet-provider");

module.exports = {
  networks: {
    development: {
      host: "127.0.0.1",
      port: 7545,
      network_id: "*" // Match any network id
    },

    ropsten: {
      provider: function() {
        return new HDWalletProvider(
          process.env.INFURA_MNEMONIC, 
          "https://ropsten.infura.io/" + process.env.INFURA_KEY
        )
      },
      network_id: 3,
      gas: 3000000,
      gasPrice: 21
    }   
  }
};

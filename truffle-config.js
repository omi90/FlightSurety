var HDWalletProvider = require("@truffle/hdwallet-provider");
//var mnemonic = "candy maple cake sugar pudding cream honey rich smooth crumble sweet treat";
var mnemonic = "affair reduce broken stomach symbol monster profit deny arrest family solar bench";
module.exports = {
  networks: {
    development: {
      provider: function() {
        return new HDWalletProvider(mnemonic, "http://127.0.0.1:9545/", 0, 50);
      },
      network_id: '*',
      gas: 2000000
    }
  },
  compilers: {
    solc: {
      version: "^0.5.16"
    }
  }
};
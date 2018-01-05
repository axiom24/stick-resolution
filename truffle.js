var HDWalletProvider = require("truffle-hdwallet-provider");
var mnemonic = "scrap pride tone near local miracle erupt clap lion infant engine bronze"
//var mnemonic = "candy maple cake sugar pudding cream honey rich smooth crumble sweet treat"
module.exports = {
 networks: {
    "live": {
      network_id: 1,
      provider: function() {
        return new HDWalletProvider(mnemonic, "https://mainnet.infura.io/zPjjR465nUBRJa96Onht")
      },
      host: "127.0.0.1",
      from: "0xcfa2769d2575756553be5744b318d3698190f35b",
      gas:120000,
      port: 8546   // Different than the default below
    }
  },
  rpc: {
    host: "127.0.0.1",
    port: 8545
  },
  solc: { optimizer: { enabled: true, runs: 200 } }
};

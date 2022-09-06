require("@nomiclabs/hardhat-waffle");
require("@nomiclabs/hardhat-etherscan");
require("@nomiclabs/hardhat-ethers");

const dotenv = require('dotenv');
dotenv.config();

task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});

module.exports = {
  solidity: "0.8.16",
  paths: {
    artifacts: "./frontend/src/artifacts",
  },
  networks: {
    rinkeby: {
      url: process.env.REACT_APP_RINKEBY_RPC_URL,
      accounts: [process.env.REACT_APP_PRIVATE_KEY]
    },
  },
  etherscan: {
    apiKey: process.env.REACT_APP_ETHERSCAN_KEY,
  },
};

import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
require("dotenv").config();
// require("@nomicfoundation/hardhat-etherscan");

const { SEPOLIARPC, ETHERSCANAPIKEY, PRIVATEKEY, MAINNET, GOERLI } =
  process.env;

const config: HardhatUserConfig = {
  solidity: "0.8.19",
  networks: {
    sepolia: {
      url: SEPOLIARPC,
      //@ts-ignore
      accounts: [PRIVATEKEY],
    },
    goerli: {
      url: GOERLI,
      //@ts-ignore
      accounts: [PRIVATEKEY],
    },
    mainnet: {
      url: MAINNET,
      //@ts-ignore
      accounts: [PRIVATEKEY],
    },
    hardhat: {
      forking: {
        //@ts-ignore
        url: MAINNET,
      },
    },
  },
  etherscan: {
    //@ts-ignore
    apiKey: ETHERSCANAPIKEY,
  },
};

export default config;

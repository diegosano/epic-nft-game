import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import "@nomicfoundation/hardhat-chai-matchers";
import "@nomiclabs/hardhat-ethers";
import 'dotenv/config';

const config: HardhatUserConfig = {
  solidity: "0.8.9",
  networks: {
    goerli: {
      url: process.env.ALCHEMY_STAGING_URL,
      accounts: [process.env.ALCHEMY_PRIVATE_KEY]
    },
    rinkeby: {
      url: process.env.ALCHEMY_STAGING_URL,
      accounts: [process.env.ALCHEMY_PRIVATE_KEY]
    }
  }
};

export default config;

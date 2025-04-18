import { HardhatUserConfig } from "hardhat/types"

import "@nomicfoundation/hardhat-toolbox"
import "@openzeppelin/hardhat-upgrades"
import "@primitivefi/hardhat-dodoc"
import 'hardhat-tracer'
import { coinMarketCapAPIKey, etherscanAPIKey, privateKey } from "./config"
  
const config: HardhatUserConfig = {
  defaultNetwork: 'hardhat',
  dodoc: {
    runOnCompile: true,
    debugMode: false,
    outputDir: './docs',
    keepFileStructure: true,
  },
  solidity: {
    compilers: [
      {
        version: '0.8.20',
        settings: {
          optimizer: { enabled: true, runs: 1000000 },
        },
      },
    ],
  },
  networks: {
    hardhat: {
      forking: {
        url: 'https://eth-mainnet.g.alchemy.com/v2/',
        blockNumber: 19261768,
        enabled: true,
      },
    },
    holesky: {
      accounts: [privateKey],
      chainId: 17000,
      url: 'https://holesky.infura.io/v3/',
    },
    mainnet: {
      accounts: [privateKey],
      chainId: 1,
      url: 'https://eth-mainnet.g.alchemy.com/v2/',
    },
  },

  etherscan: {
    apiKey: etherscanAPIKey,
    customChains: [
      {
        network: 'holesky',
        chainId: 17000,
        urls: {
          apiURL: 'https://api-holesky.etherscan.io/api',
          browserURL: 'https://holesky.etherscan.io',
        },
      },
    ],
  },
  gasReporter: {
    enabled: true,
    coinmarketcap: coinMarketCapAPIKey,
    currency: 'eth',
    token: 'eth',
    gasPriceApi:
      'https://api.polygonscan.com/api?module=proxy&action=eth_gasPrice',
  },
};

export default config

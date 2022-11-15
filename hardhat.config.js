require("@nomiclabs/hardhat-waffle")
require("hardhat-deploy")

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
//import "@nomiclabs/hardhat-waffle";
module.exports = {
    solidity: "0.8.7",
    namedAccounts: {
        deployer: {
            default: 0,
        },
    },
    networks :{
        localhost: {
            chainId: 31337,
        },
        hardhat: {}
    }
}

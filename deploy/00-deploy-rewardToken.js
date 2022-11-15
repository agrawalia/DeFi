const { network } = require("hardhat")
module.exports = async ({ getNamedAccounts, deployments }) => {
    const { deploy , log} = deployments
    const { deployer } = await getNamedAccounts()

    const rewardToken = await deploy("RewardToken", {
        from: deployer,
        args: [],
        log: true,
    })
}

module.exports.tags = ["all", "rewardToken"]

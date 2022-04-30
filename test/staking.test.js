const { ethers, deployments } = require("hardhat")
const { moveBlocks } = require("../utils/move-blocks")
const { moveTime } = require("../utils/move-time")

const SECONDS_IN_A_DAY = 86400
describe("staking test", async function () {
    let staking, rewardToken, deployer, stakeAmount

    beforeEach(async function () {
        const accounts = await ethers.getSigners()
        deployer = accounts[0]

        await deployments.fixture(["all"])
        staking = await ethers.getContract("Staking")
        rewardToken = await ethers.getContract("RewardToken")
        stakeAmount = ethers.utils.parseEther("100000")
    })

    it("allows users to stake and claim rewards", async function () {
        await rewardToken.approve(staking.address, stakeAmount)
        await staking.Stake(stakeAmount)
        const startingEarned = await staking.Earned(deployer.address)
        console.log(`Starting Earned ${startingEarned}`)

        await moveTime(SECONDS_IN_A_DAY)
        await moveBlocks(1)
        const endingEarned = await staking.Earned(deployer.address)
        console.log(`Ending Earned ${endingEarned}`)
    })
})

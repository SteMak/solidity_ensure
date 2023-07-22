import { loadFixture } from "@nomicfoundation/hardhat-toolbox/network-helpers"
import { expect } from "chai"
import { ethers } from "hardhat"

describe("ExampleTarget", function () {
  async function deploy() {
    const ExampleTargetFactory = await ethers.getContractFactory("ExampleTarget")
    const ExampleTarget = await ExampleTargetFactory.deploy()

    return { ExampleTarget }
  }

  it("Test checkBounds - failure", async function () {
    const { ExampleTarget } = await loadFixture(deploy)

    await expect(ExampleTarget.checkBounds(1, 2, 3))
      .to.be.revertedWithCustomError(ExampleTarget, "NotWithinBounds")
      .withArgs(1, 2, 3)
  })

  it("Test checkBounds - success", async function () {
    const { ExampleTarget } = await loadFixture(deploy)

    await ExampleTarget.checkBounds(15, 40, 25)
  })
})

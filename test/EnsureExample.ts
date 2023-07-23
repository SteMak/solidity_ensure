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

    await expect(ExampleTarget.checkBounds(1, 2, 0))
      .to.be.revertedWithCustomError(ExampleTarget, "NotWithinBounds")

      .withArgs(1, 2, 0)

    await expect(ExampleTarget.checkBounds(17, 20, 3333333333))
      .to.be.revertedWithCustomError(ExampleTarget, "NotWithinBounds")
      .withArgs(17, 20, 3333333333)

    await expect(ExampleTarget.checkBounds(2n ** 256n - 1n, 2n ** 256n - 1n, 0))
      .to.be.revertedWithCustomError(ExampleTarget, "NotWithinBounds")
      .withArgs(2n ** 256n - 1n, 2n ** 256n - 1n, 0)

    await expect(ExampleTarget.checkBounds(2n ** 253n, 2n ** 255n, 2n ** 252n))
      .to.be.revertedWithCustomError(ExampleTarget, "NotWithinBounds")
      .withArgs(2n ** 253n, 2n ** 255n, 2n ** 252n)

    await expect(ExampleTarget.checkBounds(10, 5, 7))
      .to.be.revertedWithCustomError(ExampleTarget, "NotWithinBounds")
      .withArgs(10, 5, 7)

    await expect(ExampleTarget.checkBounds(2n ** 254n, 2n ** 25n, 2n ** 255n))
      .to.be.revertedWithCustomError(ExampleTarget, "NotWithinBounds")
      .withArgs(2n ** 254n, 2n ** 25n, 2n ** 255n)
  })

  it("Test checkBounds - success", async function () {
    const { ExampleTarget } = await loadFixture(deploy)

    await ExampleTarget.checkBounds(15, 40, 25)

    await ExampleTarget.checkBounds(15, 40, 15)

    await ExampleTarget.checkBounds(15, 40, 40)

    await ExampleTarget.checkBounds(2n ** 256n - 1n, 2n ** 256n - 1n, 2n ** 256n - 1n)

    await ExampleTarget.checkBounds(2n ** 253n, 2n ** 255n, 2n ** 254n)
  })

  it("Test checkAddress - failure", async function () {
    const { ExampleTarget } = await loadFixture(deploy)

    await expect(
      ExampleTarget.checkAddress(
        "0x0000000000000000000000000000000000000000",
        "0x0000000000000000000000000000000000000001",
      ),
    )
      .to.be.revertedWithCustomError(ExampleTarget, "NotSpecificAddress")
      .withArgs("0x0000000000000000000000000000000000000000", "0x0000000000000000000000000000000000000001")

    await expect(
      ExampleTarget.checkAddress(
        "0x1000000000000000000000000000000000000000",
        "0x0000000000000000000000000000000000000000",
      ),
    )
      .to.be.revertedWithCustomError(ExampleTarget, "NotSpecificAddress")
      .withArgs("0x1000000000000000000000000000000000000000", "0x0000000000000000000000000000000000000000")

    await expect(
      ExampleTarget.checkAddress(
        "0x1234567890abcDEfFedCBA0987654321faBBAEda",
        "0x1234567890abcDeFFe0Cba0987654321Fabbaeda",
      ),
    )
      .to.be.revertedWithCustomError(ExampleTarget, "NotSpecificAddress")
      .withArgs("0x1234567890abcDEfFedCBA0987654321faBBAEda", "0x1234567890abcDeFFe0Cba0987654321Fabbaeda")
  })

  it("Test checkAddress - success", async function () {
    const { ExampleTarget } = await loadFixture(deploy)

    await ExampleTarget.checkAddress(
      "0x0000000000000000000000000000000000000000",
      "0x0000000000000000000000000000000000000000",
    )

    await ExampleTarget.checkAddress(
      "0x1000000000000000000000000000000000000001",
      "0x1000000000000000000000000000000000000001",
    )

    await ExampleTarget.checkAddress(
      "0x1234567890abcDEfFedCBA0987654321faBBAEda",
      "0x1234567890abcDEfFedCBA0987654321faBBAEda",
    )
  })

  it("Test checkBytesHead - failure", async function () {
    const { ExampleTarget } = await loadFixture(deploy)

    await expect(
      ExampleTarget.checkBytesHead("0x00000001", "0x0000000200000000000000000000000000000000000000000000000000000000"),
    )
      .to.be.revertedWithCustomError(ExampleTarget, "HeadBytesMismatch")
      .withArgs("0x00000001", "0x00000002")
    await expect(
      ExampleTarget.checkBytesHead("0x10000000", "0x2000000000000000000000000000000000000000000000000000000000000000"),
    )
      .to.be.revertedWithCustomError(ExampleTarget, "HeadBytesMismatch")
      .withArgs("0x10000000", "0x20000000")
    await expect(
      ExampleTarget.checkBytesHead("0x12345678", "0x7774421312345678123456781234567812345678123456781234567812345678"),
    )
      .to.be.revertedWithCustomError(ExampleTarget, "HeadBytesMismatch")
      .withArgs("0x12345678", "0x77744213")
  })

  it("Test checkBytesHead - success", async function () {
    const { ExampleTarget } = await loadFixture(deploy)

    await ExampleTarget.checkBytesHead(
      "0x12345678",
      "0x1234567800000000000000000000000000000000000000000000000000000000",
    )

    await ExampleTarget.checkBytesHead(
      "0x33377722",
      "0x333777222111444555aaa666eee888fff111222fffbbbccc999ddd000fff4440",
    )
  })
})

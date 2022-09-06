const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("OnChainNFT", function () {
  let owner, addr1, addr2;
  let contract;
  beforeEach(async function () {
    const factory = await ethers.getContractFactory("OnChainNFT");
    contract = await factory.deploy();
    await contract.deployed();
    [owner, addr1, addr2] = await ethers.getSigners();
    console.log(owner.address);
    await contract.mint(1);
  });
  it("OnChainNFT保有者", async function () {
    const idToOwner = await contract.ownerOf(1);
    expect(idToOwner).to.equal(owner.address);
  });
  it("OnChainNFT保有数", async function () {
    const balance = await contract.balanceOf(owner.address);
    expect(balance).to.equal(1);
  });
  it("名前の確認", async function () {
    const name = await contract.name();
    expect(name).to.equal("Web3Labs founder pass");
  });
  it("複数ミントしようとした場合", async function () {
    await expect(contract.mint(1)).revertedWith("Already minted.");
  });
});

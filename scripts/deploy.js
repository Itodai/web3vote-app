const hre = require("hardhat");

async function main() {

  const OnChainNFT = await hre.ethers.getContractFactory("OnChainNFT");
  const onChainNFT = await OnChainNFT.deploy();

  await onChainNFT.deployed();

  console.log("OnChainNFT deployed to:", onChainNFT.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });

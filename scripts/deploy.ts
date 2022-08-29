import { ethers } from 'hardhat';

const main = async () => {
  const gameContractFactory = await ethers.getContractFactory('EpicGame');
  const gameContract = await gameContractFactory.deploy(
    ["Aoife Bray", "Eva Lara", "Eleanor Blevins"],
		[
			"https://i.imgur.com/0cqZrkN.png",
			"https://i.imgur.com/Txq4CJJ.png",
			"https://i.imgur.com/1osfEhf.png",
		],
    [150, 100, 50],
    [50, 100, 150]
  );

  await gameContract.deployed();
  console.log('Contract address: ', gameContract.address);

  let txn;
  txn = await gameContract.mintCharacter(0);
  await txn.wait();
  console.log('Minted NFT #1');

  txn = await gameContract.mintCharacter(1);
  await txn.wait();
  console.log('Minted NFT #2');

  txn = await gameContract.mintCharacter(2);
  await txn.wait();
  console.log('Minted NFT #3');

  txn = await gameContract.mintCharacter(1);
  await txn.wait();
  console.log('Minted NFT #4');
};

const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (error) {
    console.log(error);
    process.exit(1);
  }
};

runMain();

import { ethers } from 'hardhat';

const main = async () => {
  const gameContractFactory = await ethers.getContractFactory('EpicGame');
  const gameContract = await gameContractFactory.deploy(
    ['Aoife Bray', 'Eva Lara', 'Eleanor Blevins'],
    [
      'https://i.imgur.com/pbvx2J1.png',
      'https://i.imgur.com/OhuPEMy.png',
      'https://i.imgur.com/OyETLNw.png',
    ],
    [150, 100, 50],
    [50, 100, 150],
    'Aysha Mathis',
    'https://i.imgur.com/fwCegM5.png',
    10000,
    50
  );

  await gameContract.deployed();

  console.log('Contract address: ', gameContract.address);
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

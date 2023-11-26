import { Deployer } from 'truffle';

const Users = artifacts.require('Users');
const Transfer = artifacts.require('Transfer');

export default async (deployer: Deployer) => {
  await deployer.deploy(Users);
  const UsersInstance = await Users.deployed();
  await deployer.deploy(Transfer, UsersInstance.address);
  const TransferInstance = await Transfer.deployed();
  await UsersInstance.addModifier(TransferInstance.address);
};

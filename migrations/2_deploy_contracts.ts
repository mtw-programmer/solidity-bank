import { Deployer } from 'truffle';

const Users = artifacts.require('Users');
const Transfer = artifacts.require('Transfer');
const ETC = artifacts.require('ETC');

export default async (deployer: Deployer) => {
  await deployer.deploy(Users);
  const UsersInstance = await Users.deployed();
  await deployer.deploy(Transfer, UsersInstance.address);
  await deployer.deploy(ETC);
  const TransferInstance = await Transfer.deployed();
  const ETCInstance = await ETC.deployed();
  await UsersInstance.addModifier(TransferInstance.address);
  await UsersInstance.addModifier(ETCInstance.address);
};

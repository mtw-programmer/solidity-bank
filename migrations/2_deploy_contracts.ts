import { Deployer } from 'truffle';

const Users = artifacts.require('Users');
const Transfer = artifacts.require('Transfer');
const ETC = artifacts.require('ETC');

export default async (deployer: Deployer) => {
  await deployer.deploy(Users);
  const UsersInstance = await Users.deployed();
  await deployer.deploy(Transfer, UsersInstance.address);
  const TransferInstance = await Transfer.deployed();
  await deployer.deploy(ETC, UsersInstance.address, TransferInstance.address);
  const ETCInstance = await ETC.deployed();
  await UsersInstance.addModifier(TransferInstance.address);
  await UsersInstance.addModifier(ETCInstance.address);
};

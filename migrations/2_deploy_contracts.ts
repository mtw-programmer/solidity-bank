const Users = artifacts.require('Users');
const Transfer = artifacts.require('Transfer');

export default async (deployer: { deploy: (contract: any, options?: any) => void }) => {
  await deployer.deploy(Users);
  const UsersInstance = await Users.deployed();
  await deployer.deploy(Transfer, UsersInstance.address);
  const TransferInstance = await Transfer.deployed();
  await UsersInstance.addModifier(TransferInstance.address);
};

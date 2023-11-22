const Users = artifacts.require('Users');
const Transfer = artifacts.require('Transfer');

export default async (deployer: { deploy: (contract: any, options?: any) => void }) => {
  deployer.deploy(Users);
  const UsersInstance = await Users.deployed();
  deployer.deploy(Transfer, UsersInstance.address);
};

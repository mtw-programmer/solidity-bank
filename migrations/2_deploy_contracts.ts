import { Deployer } from 'truffle';

const Transfer = artifacts.require('Transfer');

export default (deployer: Deployer) => {
  deployer.deploy(Transfer);
};

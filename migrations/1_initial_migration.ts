import { Deployer } from 'truffle';

const Migrations = artifacts.require('Migrations');

export default (deployer: Deployer) => {
  deployer.deploy(Migrations);
};

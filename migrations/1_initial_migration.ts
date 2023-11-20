import { Deployer, artifacts } from 'truffle';

const Migrations = artifacts.require('Migrations');

module.exports = (deployer: Deployer) => {
  deployer.deploy(Migrations);
};

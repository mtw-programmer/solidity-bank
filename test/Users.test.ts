import { assert } from 'chai';
import Web3 from 'web3';
import config from '../utils/config';

const web3 = new Web3(`${config.PROTOCOL}://${config.HOST}:${config.PORT}`);

const Users = artifacts.require('./Users.sol');

describe('Users', () => {
  before(async function () {
    this.users = await Users.deployed(),
    this.accounts = await web3.eth.getAccounts();
  });

  it('deploys successfully', async function () {
    const address = await this.users.address;
    assert.notEqual(address, 0x0);
    assert.notEqual(address, '');
    assert.notEqual(address, null);
    assert.notEqual(address, undefined);
  });
});
import { assert } from 'chai';

const Transfer = artifacts.require('./Transfer.sol');

describe('Transfer', () => {
  before(async function () {
    this.transfer = await Transfer.deployed();
  });

  it('deploys successfully', async function () {
    const address = await this.transfer.address;
    assert.notEqual(address, 0x0);
    assert.notEqual(address, '');
    assert.notEqual(address, null);
    assert.notEqual(address, undefined);
  });
});
import { assert } from 'chai';
import Web3 from 'web3';
import config from '../utils/config';

const web3 = new Web3(`${config.PROTOCOL}://${config.HOST}:${config.PORT}`);

const Transfer = artifacts.require('./Transfer.sol');

describe('Transfer Contract:', () => {
  before(async function () {
    this.transfer = await Transfer.deployed();
    this.accounts = await web3.eth.getAccounts();
  });

  it('deploys successfully', async function () {
    const address = await this.transfer.address;
    assert.notEqual(address, 0x0);
    assert.notEqual(address, '');
    assert.notEqual(address, null);
    assert.notEqual(address, undefined);
  });

  it('should emit ToppedUp event when top up an account', async function () {
    const transaction = await this.transfer.sendTransaction({
      from: this.accounts[0],
      value: web3.utils.toWei('1', 'ether')
    });

    const toppedUpEvent = transaction.logs.find((log:{ event:string }) => log.event === 'ToppedUp');

    assert.exists(toppedUpEvent, 'ToppedUp event should be emitted');
    assert.notEqual(toppedUpEvent.args.account.toNumber(), 0, 'Invalid account id');
    assert.equal(toppedUpEvent.args.amount.toString(), web3.utils.toWei('1', 'ether'), 'Amount should match');
  });
});
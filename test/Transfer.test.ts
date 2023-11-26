import { assert } from 'chai';
import Web3 from 'web3';
import config from '../utils/config';

const web3 = new Web3(`${config.PROTOCOL}://${config.HOST}:${config.PORT}`);

const Transfer = artifacts.require('./Transfer.sol');
const Users = artifacts.require('./Users.sol');

describe('Transfer Contract:', () => {
  before(async function () {
    this.transfer = await Transfer.deployed();
    this.users = await Users.deployed();
    this.accounts = await web3.eth.getAccounts();
  });

  describe('[Deploy]', function () {
    it('deploys successfully', async function () {
      const address = await this.transfer.address;
      assert.notEqual(address, 0x0);
      assert.notEqual(address, '');
      assert.notEqual(address, null);
      assert.notEqual(address, undefined);
    });
  });

  describe('[ToppedUp event]', function () {
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

  describe('[transfer]', function () {
    it('fails when invalid address given', async function () {
      await this.users.addFunds(this.accounts[4], 10, { from: this.accounts[0] });
      try {
        await this.transfer.transfer('a', 1, { from: this.accounts[0] });
        assert.fail('Expected an error but did not get one');
      } catch (ex:any) {
        assert.exists(ex.message);
      }
    });

    it('fails when 0x0 address given', async function () {
      try {
        await this.transfer.transfer(0x0, 1, { from: this.accounts[0] });
        assert.fail('Expected an error but did not get one');
      } catch (ex:any) {
        assert.exists(ex.message);
      }
    });

    it('fails when transfer to the same address', async function () {
      try {
        await this.transfer.transfer(this.accounts[4], 1, { from: this.accounts[4] });
        assert.fail('Expected an error but did not get one');
      } catch (ex:any) {
        assert.include(ex.message, "You cannot transfer funds to your own account");
      }
    });

    it('fails when invalid amount given', async function () {
      try {
        await this.transfer.transfer(this.accounts[1], 0, { from: this.accounts[4] });
        assert.fail('Expected an error but did not get one');
      } catch (ex:any) {
        assert.exists(ex.message);
      }
    });

    it('fails when amount is not on the account', async function () {
      try {
        await this.transfer.transfer(this.accounts[0], 10, { from: this.accounts[1] });
        assert.fail('Expected an error but did not get one');
      } catch (ex:any) {
        assert.include(ex.message, "Insufficient amount on the account");
      }
    });

    it('successfully transfer balances', async function () {
      await this.transfer.transfer(this.accounts[5], 1, { from: this.accounts[4] });
      const balanceReceiver = await this.users.getUserBalance.call(this.accounts[5], { from: this.accounts[0] });
      assert.equal(balanceReceiver.toNumber(), 1);
      const balanceSender = await this.users.getUserBalance.call(this.accounts[4], { from: this.accounts[0] });
      assert.equal(balanceSender.toNumber(), 9);
    });
  });
});
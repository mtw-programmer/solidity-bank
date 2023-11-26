import { assert } from 'chai';
import Web3 from 'web3';
import config from '../utils/config';

const web3 = new Web3(`${config.PROTOCOL}://${config.HOST}:${config.PORT}`);

const Users = artifacts.require('./Users.sol');

describe('Users Contract:', () => {
  before(async function () {
    this.users = await Users.deployed(),
    this.accounts = await web3.eth.getAccounts();
  });

  describe('[Deploy]', async function () {
    it('deploys successfully', async function () {
      const address = await this.users.address;
      assert.notEqual(address, 0x0);
      assert.notEqual(address, '');
      assert.notEqual(address, null);
      assert.notEqual(address, undefined);
    });
  });

  describe('[Modifier]', async function () {
    it('fails when restricted account tries to add modifier', async function () {
      try {
        await this.users.addModifier(this.accounts[2], { from: this.accounts[1] });
        assert.fail('Expected an error but did not get one');
      } catch (ex:any) {
        assert.include(ex.message, "This function is restricted to the contract's owner");
      }
    });
  
    it('successfully adds modifier', async function () {
      await this.users.addModifier(this.accounts[1], { from: this.accounts[0] });
    });
  });

  describe('[getUserId]', async function () {
    it('fails when restricted account tries to get user id', async function () {
      try {
        await this.users.getUserId(this.accounts[1], { from: this.accounts[2] });
        assert.fail('Expected an error but did not get one');
      } catch (ex:any) {
        assert.include(ex.message, "This function is restricted to the contract's owner");
      }
    });

    it('successfully gets user id', async function () {
      const res = await this.users.getUserId(this.accounts[1], { from: this.accounts[1] });
      assert.notEqual(res, 0);
    });
  });

  describe('[addFunds]', async function () {
    it('fails when restricted account tries to addFunds', async function () {
      try {
        await this.users.addFunds(this.accounts[1], 1, { from: this.accounts[2] });
        assert.fail('Expected an error but did not get one');
      } catch (ex:any) {
        assert.include(ex.message, "This function is restricted to the contract's owner");
      }
    });
    
    it('fails when invalid address given', async function () {
      try {
        await this.users.addFunds('a', 1, { from: this.accounts[1] });
        assert.fail('Expected an error but did not get one');
      } catch (ex:any) {
        assert.exists(ex.message);
      }
    });
    
    it('fails when 0x0 address given', async function () {
      try {
        await this.users.addFunds(0x0, 1, { from: this.accounts[1] });
        assert.fail('Expected an error but did not get one');
      } catch (ex:any) {
        assert.exists(ex.message);
      }
    });
    
    it('fails when invalid amount given', async function () {
      try {
        await this.users.addFunds(this.accounts[0], 0, { from: this.accounts[1] });
        assert.fail('Expected an error but did not get one');
      } catch (ex:any) {
        assert.exists(ex.message);
      }
    });

    it('successfully adds balances to the account', async function () {
      await this.users.addFunds(this.accounts[0], 1, { from: this.accounts[1] });
    });
  });
});
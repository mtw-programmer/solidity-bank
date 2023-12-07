import { assert } from 'chai';
import Web3 from 'web3';
import config from '../utils/config';

const web3 = new Web3(`${config.PROTOCOL}://${config.HOST}:${config.PORT}`);

const ETC = artifacts.require('./ETC.sol');

describe('ETC Contract:', () => {
  before(async function () {
    this.etc = await ETC.deployed();
    this.accounts = await web3.eth.getAccounts();
  });

  describe('[Deploy]', function () {
    it('deploys successfully', async function () {
      const address = await this.etc.address;
      assert.notEqual(address, 0x0);
      assert.notEqual(address, '');
      assert.notEqual(address, null);
      assert.notEqual(address, undefined);
    });
  });

  describe('[generateCode]', async function () {
    it('fails when amount is invalid', async function () {
      try {
        await this.etc.generateCode.call(0, { from: this.accounts[0] });
        assert.fail('Expected an error but did not get one');
      } catch (ex:any) {
        assert.include(ex.message, "Invalid amount");
      }
    });

    it('successfully generates ETC', async function () {
      const code = await this.etc.generateCode.call(1, { from: this.accounts[0] });
      assert.isTrue(code.toNumber() >= 100000, "Invalid code range");
      assert.isTrue(code.toNumber() <= 999999, "Invalid code range");
    });
  });
});
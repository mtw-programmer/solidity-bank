import { assert } from 'chai';
import Web3 from 'web3';
import config from '../utils/config';

const web3 = new Web3(`${config.PROTOCOL}://${config.HOST}:${config.PORT}`);

const ETC = artifacts.require('./ETC.sol');
const Users = artifacts.require('./Users.sol');

describe('ETC Contract:', () => {
  before(async function () {
    this.etc = await ETC.deployed();
    this.users = await Users.deployed();
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
        await this.etc.generateCode(0, { from: this.accounts[0] });
        assert.fail('Expected an error but did not get one');
      } catch (ex:any) {
        assert.include(ex.message, "Invalid amount");
      }
    });

    it('successfully generates ETC', async function () {
      const receipt = await this.etc.generateCode(1, { from: this.accounts[0] });
      const code = receipt.logs[0].args.code;
      assert.isTrue(code >= 100000, "Invalid code range");
      assert.isTrue(code <= 999999, "Invalid code range");
    });
  });

  describe('[useCode]', async function () {
    it('fails when using invalid code', async function () {
      try {
        await this.etc.useCode(1, { from: this.accounts[0] });
        assert.fail('Expected an error but did not get one');
      } catch (ex:any) {
        assert.include(ex.message, "Code doesn't exists or is expired");
      }
    });

    it('fails when using an expired code', async function () {
      try {
        const receipt = await this.etc.generateCode(1, { from: this.accounts[0] });
        const code = receipt.logs[0].args.code;
        if (typeof web3 !== 'undefined') {
          // Increase the time by 91 seconds
          await (web3.currentProvider as any).send(
            {
              jsonrpc: '2.0',
              method: 'evm_increaseTime',
              params: [91],
              id: 0,
            },
            () => {}
          );
          // Mine a new block to make the changes take effect
          await (web3.currentProvider as any).send(
            {
              jsonrpc: '2.0',
              method: 'evm_mine',
              id: 0,
            },
            () => {}
          );
        }
        await this.users.addFunds(this.accounts[1], 1);
        await this.etc.useCode(code, { from: this.accounts[1] });
        assert.fail('Expected an error but did not get one');
      } catch (ex:any) {
        assert.include(ex.message, "Code doesn't exists or is expired");
      }
    });

    it('fails when using your own code', async function () {
      try {
        const receipt = await this.etc.generateCode(1, { from: this.accounts[0] });
        const code = receipt.logs[0].args.code;
        await this.etc.useCode(code, { from: this.accounts[0] });
        assert.fail('Expected an error but did not get one');
      } catch (ex:any) {
        assert.include(ex.message, "You cannot use your own code");
      }
    });

    it('fails when using a used code', async function () {
      try {
        const receipt = await this.etc.generateCode(1, { from: this.accounts[0] });
        const code = receipt.logs[0].args.code;

        await this.users.addFunds(this.accounts[1], 1 , { from: this.accounts[0] });

        await this.etc.useCode(code, { from: this.accounts[1] });
        await this.etc.useCode(code, { from: this.accounts[1] });

        assert.fail('Expected an error but did not get one');
      } catch (ex:any) {
        assert.include(ex.message, "Code doesn't exists or is expired");
      }
    });

    it('successfully uses a code', async function () {
      const receipt = await this.etc.generateCode(1, { from: this.accounts[0] });
      const code = receipt.logs[0].args.code;
      await this.users.addFunds(this.accounts[1], 1, { from: this.accounts[0] });
      const res = await this.etc.useCode(code, { from: this.accounts[1] });
    });
  });
});
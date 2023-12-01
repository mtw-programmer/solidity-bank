// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import './Users.sol';
import './Transfer.sol';

contract ETC {
  mapping(uint256 => Code) private codes;
  mapping(uint256 => bool) private locked;
  Users private usersContract;
  Transfer private transferContract;
  uint256 nonce;

  struct Code {
    address from;
    uint256 amount;
    uint expirationTime;
    address executedBy;
  }

  constructor(address usersAddress, address payable transferAddress) {
    require(usersAddress != address(0), "Invalid Users contract address");
    require(transferAddress != address(0), "Invalid Transfer contract address");
    usersContract = Users(usersAddress);
    transferContract = Transfer(transferAddress);
  }

  function generateRandomNumber() internal view returns (uint256) {
    uint256 seed = uint256(keccak256(abi.encodePacked(msg.sender, block.timestamp)));

    return uint256(
        keccak256(abi.encodePacked(block.timestamp, blockhash(block.number - 1), nonce, seed))
    ) % 900000 + 100000;
  }

  function generateCode(uint256 _amount) public returns (uint256) {
    require(_amount > 0, "Invalid amount");
    uint256 code = generateRandomNumber();
    while(codes[code].amount == 0 || codes[code].expirationTime > block.timestamp) {
      code = generateRandomNumber();
    }
    codes[code] = Code(msg.sender, _amount, block.timestamp + 1.5 minutes, address(0));
    return code;
  }

  function useCode(uint256 _code) public {
    require(!locked[_code], "Code is temporary locked. Please, try again later");
    require(codes[_code].amount > 0, "Code doesn't exists or is expired");
    require(codes[_code].expirationTime > block.timestamp, "Code doesn't exists or is expired");
    require(codes[_code].executedBy == address(0), "Code doesn't exists or is expired");
    require(codes[_code].from != msg.sender, "You cannot use your own code");
    require(usersContract.getUserBalance(msg.sender) >= codes[_code].amount, "Insufficient amount on the account");
    locked[_code] = true;
    transferContract.transfer(payable(codes[_code].from), codes[_code].amount);
    codes[_code].executedBy = msg.sender;
    locked[_code] = false;
  }

  function cancelCode(uint256 _code) external {
    require(!locked[_code], "Code is temporary locked. Please, try again later");
    require(msg.sender == codes[_code].from, "This function is restricted to the code's owner");
    require(codes[_code].executedBy == address(0), "This code has been already executed");
    require(codes[_code].expirationTime >= block.timestamp, "This code is already expired");
    locked[_code] = true;
    codes[_code].expirationTime = block.timestamp - 1 seconds;
    locked[_code] = false;
  }
}

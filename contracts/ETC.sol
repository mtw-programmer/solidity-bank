// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import './Users.sol';

contract ETC {
  mapping(uint256 => Code) private codes;
  uint256 nonce;

  struct Code {
    address from;
    uint256 amount;
    uint expirationTime;
    address executedBy;
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
    while(codes[code].amount == 0) {
      code = generateRandomNumber();
    }
    codes[code] = Code(msg.sender, _amount, block.timestamp + 1.5 minutes, address(0));
    return code;
  }
}

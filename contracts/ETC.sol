// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import './Users.sol';

contract ETC {
  mapping(string => Code) private codes;
  uint256 nonce;

  struct Code {
    address from;
    address to;
    uint256 amount;
    uint256 expirationTime;
    bool executed;
  }

  function generateRandomNumber() internal view returns (uint256) {
    uint256 seed = uint256(keccak256(abi.encodePacked(msg.sender, block.timestamp)));

    return uint256(
        keccak256(abi.encodePacked(block.timestamp, blockhash(block.number - 1), nonce, seed))
    ) % 900000 + 100000;
  }
}

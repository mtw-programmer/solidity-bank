// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import './Users.sol';

contract ETC {
  mapping(string => Code) private codes;

  struct Code {
    address from;
    address to;
    uint256 amount;
    uint256 expirationTime;
    bool executed;
  }
}

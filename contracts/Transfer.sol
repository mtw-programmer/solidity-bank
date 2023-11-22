// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import './Users.sol';

contract Transfer {
  address private owner;
  Users private usersContract;

  constructor(address usersAddress) {
    owner = msg.sender;
    usersContract = Users(usersAddress);
  }

  event ToppedUp(uint account, uint256 amount, uint256 time);

  receive() external payable {
    emit ToppedUp(usersContract.getUserId(msg.sender), msg.value, block.timestamp);
  }
}

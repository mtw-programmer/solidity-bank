// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import './Users.sol';

contract Transfer {
  Users private usersContract;

  constructor(address usersAddress) {
    usersContract = Users(usersAddress);
    usersContract.addModifier(address(this));
  }

  event ToppedUp(uint account, uint256 amount, uint256 time);

  receive() external payable {
    usersContract.addFunds(msg.sender, msg.value);
    emit ToppedUp(usersContract.getUserId(msg.sender), msg.value, block.timestamp);
  }
}

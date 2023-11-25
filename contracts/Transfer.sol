// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import './Users.sol';

contract Transfer {
  Users private usersContract;

  constructor(address usersAddress) {
    require(usersAddress != address(0), "Invalid Users contract address");
    usersContract = Users(usersAddress);
  }

  event ToppedUp(uint account, uint256 amount, uint256 time);

  receive() external payable {
    usersContract.addFunds(msg.sender, msg.value);
    emit ToppedUp(usersContract.getUserId(msg.sender), msg.value, block.timestamp);
  }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract Transfer {
  address private owner;

  mapping(address => uint) private id;
  mapping(uint => uint256) private balance;

  constructor() {
    owner = msg.sender;
  }

  event ToppedUp(uint account, uint256 amount, uint256 time);

  receive() external payable {
    emit ToppedUp(id[msg.sender], msg.value, block.timestamp);
  }
}

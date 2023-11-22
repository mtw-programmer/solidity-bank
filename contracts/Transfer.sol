// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract Transfer {
  address private owner;

  uint private accountQuantity = 0;
  mapping(address => uint) private id;
  mapping(uint => uint256) private balance;

  constructor() {
    owner = msg.sender;
  }

  function getUserId(address _address) private returns (uint) {
    if (id[_address] == 0) {
      accountQuantity += 1;
      id[_address] = accountQuantity;
    }

    return id[_address];
  }

  event ToppedUp(uint account, uint256 amount, uint256 time);

  receive() external payable {
    emit ToppedUp(getUserId(msg.sender), msg.value, block.timestamp);
  }
}

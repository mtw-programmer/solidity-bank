// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract Users {
  address private owner;
  address private usersContractAddress = address(this);

  uint private accountQuantity = 0;
  mapping(address => uint) private id;
  mapping(uint => uint256) private balance;

  modifier restricted() {
    require(msg.sender == owner, "This function is restricted to the contract's owner");
    _;
  }

  constructor() {
    owner = msg.sender;
  }

  function getUserId(address _address) external restricted returns (uint) {
    if (id[_address] == 0) {
      accountQuantity += 1;
      id[_address] = accountQuantity;
    }

    return id[_address];
  }
}

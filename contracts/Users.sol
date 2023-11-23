// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract Users {
  mapping(address => bool) private modifiers;
  address private usersContractAddress = address(this);

  uint private accountQuantity = 0;
  mapping(address => uint) private id;
  mapping(uint => uint256) private balance;

  constructor() {
    modifiers[msg.sender] = true;
    modifiers[usersContractAddress] = true;
  }

  modifier restricted() {
    require(modifiers[msg.sender] || modifiers[usersContractAddress], "This function is restricted to the contract's owner");
    _;
  }

  function addModifier(address _address) external restricted {
    modifiers[_address] = true;
  }

  function getUserId(address _address) public restricted returns (uint) {
    if (id[_address] == 0) {
      accountQuantity += 1;
      id[_address] = accountQuantity;
    }

    return id[_address];
  }

  function addFunds(address _to, uint256 _amount) external restricted {
    require(getUserId(_to) > 0, "Invalid user address");
    require(_amount > 0, "Invalid amount");
    balance[getUserId(_to)] += _amount;
  }
}

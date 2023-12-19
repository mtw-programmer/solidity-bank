// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract Users {
    mapping(address => bool) private modifiers;
    mapping(address => uint256) private balance;

    constructor() {
        modifiers[msg.sender] = true;
        modifiers[address(this)] = true;
    }

    modifier restricted() {
        require(
            modifiers[msg.sender],
            "This function is restricted to the contract's owner"
        );
        _;
    }

    function addModifier(address _address) external restricted {
        modifiers[_address] = true;
    }

    function getUserBalance(
        address _address
    ) external view restricted returns (uint256) {
        return balance[_address];
    }

    function addFunds(address _to, uint256 _amount) external restricted {
        require(_to != address(0), "Invalid user address");
        require(_amount > 0, "Invalid amount");
        balance[_to] += _amount;
    }

    function takeFunds(address _from, uint256 _amount) external restricted {
        require(_from != address(0), "Invalid user address");
        require(_amount > 0, "Invalid amount");
        require(
            balance[_from] >= _amount,
            "Insufficient amount on the account"
        );
        balance[_from] -= _amount;
    }
}

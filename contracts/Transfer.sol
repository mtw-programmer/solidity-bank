// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./Users.sol";

contract Transfer {
    Users private usersContract;

    constructor(address usersAddress) {
        require(usersAddress != address(0), "Invalid Users contract address");
        usersContract = Users(usersAddress);
    }

    event ToppedUp(address account, uint256 amount, uint256 time);

    receive() external payable {
        usersContract.addFunds(msg.sender, msg.value);
        emit ToppedUp(msg.sender, msg.value, block.timestamp);
    }

    function transfer(address _to, uint256 _amount) external {
        require(
            _to != msg.sender,
            "You cannot transfer funds to your own account"
        );
        usersContract.takeFunds(msg.sender, _amount);
        usersContract.addFunds(_to, _amount);
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/// @notice Import of the Users contract
import "./Users.sol";

/// @title Transfer - handles topping up with fallback and has transfer util
/// @author mtw-programmer
contract Transfer {
    Users private usersContract; /// @dev User's contract instance

    /**
     * @dev Contract constructor, sets Users instance
     * @dev Ensures that no 0 addresses given
     * @param usersAddress The address of the deployed Users contract
     */
    constructor(address usersAddress) {
        require(usersAddress != address(0), "Invalid Users contract address");
        usersContract = Users(usersAddress);
    }

    /// @dev Used fallback
    event ToppedUp(address account, uint256 amount, uint256 time);

    /// @dev Fallback function - addFunds when made transaction
    /// @dev After all emits ToppedUp event
    receive() external payable {
        usersContract.addFunds(msg.sender, msg.value);
        emit ToppedUp(msg.sender, msg.value, block.timestamp);
    }

    /**
     * @notice Function for making transfers
     * @dev Ensures that the user doesn't make a transfer to their own account
     * @dev Ensures that the user has enough funds
     * @param _to Defines the recipient address
     * @param _amount Defines the amount to send
     */
    function transfer(address _to, uint256 _amount) external {
        require(
            _to != msg.sender,
            "You cannot transfer funds to your own account"
        );
        require(
            usersContract.getUserBalance(msg.sender) >= _amount,
            "Insufficient amount on the account"
        );
        usersContract.takeFunds(msg.sender, _amount);
        usersContract.addFunds(_to, _amount);
    }
}

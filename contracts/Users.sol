// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/// @title Users - contains balances and restricted users methods
/// @author mtw-programmer
contract Users {
    mapping(address => bool) private modifiers; /// @dev List of addresses allowed to modify
    mapping(address => uint256) private balance; /// @dev User's account balances

    /// @dev Contract constructor, adds creator and contract addresses to modifiers
    constructor() {
        modifiers[msg.sender] = true;
        modifiers[address(this)] = true;
    }

    /// @dev Restricted modifier
    /// @dev Ensures that only allowed addresses modifies
    modifier restricted() {
        require(
            modifiers[msg.sender],
            "This function is restricted to the contract's owner"
        );
        _;
    }

    /**
     * @dev Adds new modifer
     * @dev Restricted only for modifiers
     * @param _address New modifier's address
     */
    function addModifier(address _address) external restricted {
        modifiers[_address] = true;
    }

    /**
     * @dev Gets user's balance
     * @param _address User's address
     * @return uint256 with a user's account balance
     */
    function getUserBalance(
        address _address
    ) external view restricted returns (uint256) {
        return balance[_address];
    }

    /**
     * @dev Adds balances to the given account
     * @dev Restricted only for modifiers
     * @dev Ensures that the given address is not 0 address
     * @dev Ensures that amount is bigger than 0
     * @param _to Recipient's address
     * @param _amount Amount to add
     */
    function addFunds(address _to, uint256 _amount) external restricted {
        require(_to != address(0), "Invalid user address");
        require(_amount > 0, "Invalid amount");
        balance[_to] += _amount;
    }

    /**
     * @dev Takes balances from the given account
     * @dev Allowed only for modifiers
     * @dev Ensures no 0 addresses given
     * @dev Ensures amount is bigger than 0
     * @dev Ensures that amount is on the account
     * @param _from Address of the account to take balances
     * @param _amount Amount to take from the account
     */
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

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/// @notice Imports of the Users and Transfer contracts
import "./Users.sol";
import "./Transfer.sol";

/// @title ETC (EThereum Codes) - allows using fast generated codes for transactions
/// @author mtw-programmer
contract ETC {
    mapping(uint256 => Code) private codes; /// @dev Mapping of generated code to the code struct
    mapping(uint256 => bool) private locked; /// @dev Mapping of the address that are temporary locked

    Users private usersContract; /// @dev Users contract instance
    Transfer private transferContract; /// @dev Transfer contract instance

    uint256 private nonce; /// @dev Nonce for generating random numbers

    /// @notice This struct represents information about code
    struct Code {
        address from; /// @dev Address of the code creator
        uint256 amount; /// @dev Amount to send
        uint expirationTime; /// @dev Time of code expiration (1.5 mins after creation)
        address executedBy; /// @dev Address of the payer
    }

    /**
     * @dev Contract constructor, sets Users and Transfer instances
     * @dev Ensures that no 0 addresses given
     * @param usersAddress The address of the deployed Users contract
     * @param transferAddress The address of the deployed Transfer contract
     */
    constructor(address usersAddress, address payable transferAddress) {
        require(usersAddress != address(0), "Invalid Users contract address");
        require(
            transferAddress != address(0),
            "Invalid Transfer contract address"
        );
        usersContract = Users(usersAddress);
        transferContract = Transfer(transferAddress);
    }

    /**
     * @dev Generate random number for code
     * @dev The randomness is obtained by hashing the concatenated values using Keccak256,
     *      and then converting the result to a uint256. The modulo operation is used
     *      to limit the range, and the final result is within the range [100,000, 999,999]
     * @return A pseudo-random number within the range [100,000, 999,999]
     */
    function generateRandomNumber() internal view returns (uint256) {
        uint256 seed = uint256(
            keccak256(abi.encodePacked(msg.sender, block.timestamp))
        );
        return
            (uint256(
                keccak256(
                    abi.encodePacked(
                        block.timestamp,
                        blockhash(block.number - 1),
                        nonce,
                        seed
                    )
                )
            ) % 900000) + 100000;
    }

    /**
     * @notice Generate Ethereum Code active for 1.5 mins
     * @dev Ensures that provided _amount is greater than 0
     * @param _amount Amount for the transaction
     * @return 6 digit code number for mapping
     */
    function generateCode(uint256 _amount) public returns (uint256) {
        require(_amount > 0, "Invalid amount");
        uint256 code = generateRandomNumber();
        /// @dev Generates code number to the moment when a code is unique or the old one is expired
        while (
            codes[code].amount == 0 ||
            codes[code].expirationTime > block.timestamp
        ) {
            code = generateRandomNumber();
        }
        codes[code] = Code(
            msg.sender,
            _amount,
            block.timestamp + 1.5 minutes,
            address(0)
        );
        return code;
    }

    /**
     * @notice Pay with the active code
     * @dev Ensures that code is not is not temporary locked for security reasons
     * @dev Ensures that code is set
     * @dev Ensures that code is not expired or inactive
     * @dev Ensures that code wasn't executed before
     * @dev Ensures that code creator is not trying to use their own code
     * @dev Ensures that payer has the sufficient amount on the account
     * @param _code 6 digit code identifier
     */
    function useCode(uint256 _code) public {
        require(
            !locked[_code],
            "Code is temporary locked. Please, try again later"
        );
        require(codes[_code].amount > 0, "Code doesn't exists or is expired");
        require(
            codes[_code].expirationTime > block.timestamp,
            "Code doesn't exists or is expired"
        );
        require(
            codes[_code].executedBy == address(0),
            "Code doesn't exists or is expired"
        );
        require(
            codes[_code].from != msg.sender,
            "You cannot use your own code"
        );
        require(
            usersContract.getUserBalance(msg.sender) >= codes[_code].amount,
            "Insufficient amount on the account"
        );
        /// @dev Temporary locks the code actions due to security reasons
        locked[_code] = true;
        transferContract.transfer(
            payable(codes[_code].from),
            codes[_code].amount
        );
        codes[_code].executedBy = msg.sender;
        locked[_code] = false;
    }

    /**
     * @notice Cancel your own code
     * @dev Ensures that code is not locked
     * @dev Ensures that the users is not trying to cancel someone else code
     * @dev Ensures that code is not already executed
     * @dev Ensures that code is not expired
     * @param _code 6 digit code identifier
     */
    function cancelCode(uint256 _code) external {
        require(
            !locked[_code],
            "Code is temporary locked. Please, try again later"
        );
        require(
            msg.sender == codes[_code].from,
            "This function is restricted to the code's owner"
        );
        require(
            codes[_code].executedBy == address(0),
            "This code has been already executed"
        );
        require(
            codes[_code].expirationTime >= block.timestamp,
            "This code is already expired"
        );
        /// @dev Locks code for a moment due to security reasons
        locked[_code] = true;
        /// @dev Sets code expirationTime to the expired one
        codes[_code].expirationTime = block.timestamp - 1 seconds;
        locked[_code] = false;
    }
}

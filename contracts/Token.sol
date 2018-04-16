pragma solidity ^0.4.15;

import './interfaces/ERC20Interface.sol';

/**
 * @title Token
 * @dev Contract that implements ERC20 token standard
 * Is deployed by `Crowdsale.sol`, keeps track of balances, etc.
 */

contract Token is ERC20Interface {
	// YOUR CODE HERE
	mapping (address => uint256) balanceBook;
	uint256 public totalSupply = 200;

    address owner;

    function Token() {
        owner = msg.sender;
        totalSupply = 10000;
    }

	function balanceOf(address _owner) constant returns (uint256 balance) {
		return balanceBook[_owner];
	}

    function addTokens(uint amount) {
        totalSupply += amount;
    }

	/// @notice send `_value` token to `_to` from `msg.sender`
    /// @param _to The address of the recipient
    /// @param _value The amount of token to be transferred
    /// @return Whether the transfer was successful or not
    function transfer(address _to, uint256 _value) returns (bool success) {
    	// check sender has enough money
    	
    	if (balanceBook[msg.sender] < _value) return false;
    	if (balanceBook[_to] + _value < balanceBook[_to]) return false;
        Transfer(msg.sender, _to, _value);
        balanceBook[msg.sender] -= _value;
    	balanceBook[_to] += _value;
    	return true;
    }

    /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
    /// @param _from The address of the sender
    /// @param _to The address of the recipient
    /// @param _value The amount of token to be transferred
    /// @return Whether the transfer was successful or not
    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
    	emit Transfer(_from, _to, _value);
    	if (balanceBook[from] < value) return false;
        if (balanceBook[_to] + _value < balanceBook[_to]) return false;
    	Transfer(_from, _to, _value);
        balanceBook[_from] -= _value;
    	balanceBook[_to] += _value;
    	return true;
    }

    /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
    /// @param _spender The address of the account able to transfer the tokens
    /// @param _value The amount of tokens to be approved for transfer
    /// @return Whether the approval was successful or not
    function approve(address _spender, uint256 _value) returns (bool success) {
    	require(_value > 0);
    	Approval(msg.sender, _spender, _value);
    	return true;
    }

    /// @param _owner The address of the account owning tokens
    /// @param _spender The address of the account able to transfer the tokens
    /// @return Amount of remaining tokens allowed to spent
    function allowance(address _owner, address _spender) constant returns (uint256 remaining);

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
}


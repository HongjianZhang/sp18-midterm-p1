pragma solidity ^0.4.15;

import './Queue.sol';
import './Token.sol';

/**
 * @title Crowdsale
 * @dev Contract that deploys `Token.sol`
 * Is timelocked, manages buyer queue, updates balances on `Token.sol`
 */

contract Crowdsale {
	// YOUR CODE HERE	
	Token public token;
	address public owner;
	uint public exchangeRate;

	uint private startTime;
	uint private endTime;
	uint private funds;

	Queue public queue;

	modifier saleOn {
		require(now >= startTime && now <= endTime);
		_;
	}

	modifier ownerOnly {
		require(msg.sender == owner);
		_;
	}

	event TokenPurchase(address _from);
	event TokenRefund(address _to);

	function Crowdsale(uint _amount, uint _exchangeRate) {
		owner = msg.sender;
		exchangeRate = _exchangeRate;
		token = new Token();
		token.totalSupply = _amount;
	}

	function mint(uint amount) ownerOnly() {
		token.totalSupply += amount;
	}

	function burn(uint amount) ownerOnly() {
		if (token.totalSupply >= amount) {
			token.totalSupply -= amount;
		}
	}

	function receiveFunds() ownerOnly() {
		if (now > endTime) {
			owner.transfer(funds);
		}
	}

	function buy(uint amount) public payable saleOn() {
		require(!queue.empty() && queue.getFirst() == msg.sender);
		if (amount <= msg.value * exchangeRate) {
			tokensSold += amount;
			bank += msg.value;
			
			TokenPurchase(msg.sender);
			queue.dequeue();
		}
	}

	function refund(uint amount) public saleOn() {
		tokensSold -= amount;
		uint value = amount * exchangeRate
		msg.sender.transfer(value)
		bank -= value;
		TokenRefund(msg.sender);
	}

	function addToQueue() public saleOn() returns (bool) {
		if (queue.qsize() >= 5) {
			return false;
		}
		queue.enqueue(msg.sender);
		return true;
	}

	function public payable {
		revert();
	}

}

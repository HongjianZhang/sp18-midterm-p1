pragma solidity ^0.4.15;

/**
 * @title Queue
 * @dev Data structure contract used in `Crowdsale.sol`
 * Allows buyers to line up on a first-in-first-out basis
 * See this example: http://interactivepython.org/courselib/static/pythonds/BasicDS/ImplementingaQueueinPython.html
 */

contract Queue {
	/* State variables */
	uint8 size = 5;
	// YOUR CODE HERE
	uint timeLimit = 200;

	struct Order {
		address owner;
		uint timestamp;  // the timestamp the order becomes first in the queue
	}
	
	uint8 curNumber = 0;
	Order[] storage orders;


	/* Add events */
	// YOUR CODE HERE

	/* Add constructor */
	// YOUR CODE HERE
	function Queue() {
		orders = new Order[size];
	}

	/* Returns the number of people waiting in line */
	function qsize() constant returns(uint8) {
		// YOUR CODE HERE
		return curNumber;
	}

	/* Returns whether the queue is empty or not */
	function empty() constant returns(bool) {
		// YOUR CODE HERE
		return curNumber == 0;
	}
	
	/* Returns the address of the person in the front of the queue */
	function getFirst() constant returns(address) {
		// YOUR CODE HERE
		return orders[0].address;
	}
	
	/* Allows `msg.sender` to check their position in the queue */
	function checkPlace() constant returns(uint8) {
		// YOUR CODE HERE
		for (uint8 i = 0; i < curNumber; i++) {
			if (orders[i].address == msg.sender) {
				return i;
			}
		}
		return 5;
		// TODO: what if not in the queue;
	}
	
	/* Allows anyone to expel the first person in line if their time
	 * limit is up
	 */
	function checkTime() {
		// YOUR CODE HERE
		if (now - orders[0].timestamp > timeLimit) {
			dequeue();
		}
	}
	
	/* Removes the first person in line; either when their time is up or when
	 * they are done with their purchase
	 */
	function dequeue() {
		// YOUR CODE HERE
		for (uint8 i = 0; i < curNumber-1; i++) {
			orders[i] = orders[i+1];
		}
		orders[curNumber - 1] = address(0);
		orders[0] = now;
		curNumber --;
	}

	/* Places `addr` in the first empty position in the queue */
	function enqueue(address addr) {
		// YOUR CODE HERE
		if (curNumber != size) {
			orders[curNumber-1] = Order(addr, now);
			curNumber ++;
		}
	}
}

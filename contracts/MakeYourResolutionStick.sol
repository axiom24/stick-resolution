pragma solidity ^0.4.4;

import 'zeppelin-solidity/contracts/ownership/Ownable.sol';

contract MakeYourResolutionStick is Ownable {
    struct Goal {
    	bytes32 hash;
        address owner; // goal owner addr
        string description; // set goal description
        uint amount; // set goal amount
        string supervisorEmail; // email of friend
        string creatorEmail; // email of friend
        string deadline;
        bool emailSent;
        bool completed;
    }

    // address owner;
	mapping (bytes32 => Goal) public goals;
	Goal[] activeGoals;

	address test;

	// MakeYourResolutionStick.deployed().then(function(instance) {app=instance;})
	// function MakeYourResolutionStick() {
	// 	owner = msg.sender;
	// }

	// Events
    event setGoalEvent (
    	address _owner,
        string _description,
        uint _amount,
        string _supervisorEmail,
        string _creatorEmail,
        string _deadline,
        bool _emailSent,
        bool _completed
    );

    event setGoalSucceededEvent(bytes32 hash, bool _completed);
    event setGoalFailedEvent(bytes32 hash, bool _completed);

	// app.setGoal("HODL ETH", "random@eth.com", "random@eth.com.com", "2017-12-12", {value: web3.toWei(11.111, 'ether')})
	// app.setGoal("HODL ETH", "random@eth.com.com", "random@eth.com.com", "2017-12-12", {value: web3.toWei(11.111, 'ether'), from: web3.eth.accounts[1]})
	function setGoal(string _description, string _supervisorEmail, string _creatorEmail, string _deadline) payable returns (bytes32, address, string, uint, string, string, string) {
		require(msg.value > 0);
		require(keccak256(_description) != keccak256(''));
		require(keccak256(_creatorEmail) != keccak256(''));
		require(keccak256(_deadline) != keccak256(''));

		bytes32 hash = keccak256(msg.sender, _description, msg.value, _deadline);

		Goal memory goal = Goal({
			hash: hash,
			owner: msg.sender,
			description: _description,
			amount: msg.value,
			supervisorEmail: _supervisorEmail,
			creatorEmail: _creatorEmail,
			deadline: _deadline,
			emailSent: false,
			completed: false
		});

		goals[hash] = goal;
		activeGoals.push(goal);

		setGoalEvent(goal.owner, goal.description, goal.amount, goal.supervisorEmail, goal.creatorEmail, goal.deadline, goal.emailSent, goal.completed);

		return (hash, goal.owner, goal.description, goal.amount, goal.supervisorEmail, goal.creatorEmail, goal.deadline);
	}

	function getGoalsCount() constant returns (uint count) {
	    return activeGoals.length;
	}

	// app.setEmailSent("0x..", {from: web3.eth.accounts[1]})
	function setEmailSent(uint _index, bytes32 _hash) onlyOwner {
		assert(goals[_hash].amount > 0);

		goals[_hash].emailSent = true;
		activeGoals[_index].emailSent = true;
	}

	function setGoalSucceeded(uint _index, bytes32 _hash) onlyOwner {
		assert(goals[_hash].amount > 0);

		goals[_hash].completed = true;
		activeGoals[_index].completed = true;

		goals[_hash].owner.transfer(goals[_hash].amount); // send ether back to person who set the goal

		setGoalSucceededEvent(_hash, true);
	}


	function setGoalFailed(uint _index, bytes32 _hash) {
		assert(goals[_hash].amount > 0);
		// assert(goals[_hash].emailSent == true);

		goals[_hash].completed = false;
		activeGoals[_index].completed = false;

		owner.transfer(goals[_hash].amount); // send ether to contract owner

		setGoalFailedEvent(_hash, false);
	}

	// Fallback function in case someone sends ether to the contract so it doesn't get lost
	function() payable {}

    function kill() onlyOwner { 
    	selfdestruct(owner);
    }
}

// web3.fromWei(web3.eth.getBalance(web3.eth.accounts[1]).toNumber(), 'ether')

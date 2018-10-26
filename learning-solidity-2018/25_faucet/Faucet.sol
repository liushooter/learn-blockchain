pragma solidity 0.4.24;

contract Faucet {
    event ReceivedEthers(uint);
    event WithdrawEthers(uint);
    
    constructor() payable public {
    }
    
    function withdraw(uint withdrawAmount) public {
	    require(withdrawAmount <= 1 ether, "No more than 1 Ether");
	    emit WithdrawEthers(withdrawAmount);
        msg.sender.transfer(withdrawAmount);
    }

	function() public payable {
        emit ReceivedEthers(msg.value);
    }
}
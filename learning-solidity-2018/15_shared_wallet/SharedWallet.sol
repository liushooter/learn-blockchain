/*
based on https://www.youtube.com/watch?v=OwavQTuHoM8
*/

pragma solidity 0.4.24;

contract SharedWallet {
    address private _owner;
    mapping (address => uint8) private _managers;
    
    modifier isOwner {
        require(_owner == msg.sender, "only for owner");
        _;
    }
    
    modifier isManager {
        require(msg.sender == _owner || _managers[msg.sender] == 1, "only for managers");
        _;
    }
    
    constructor() public {
        _owner = msg.sender;
    }
    
    event DepositFunds(address from, uint amount);
    event WithdrawFunds(address to, uint amount);
    
    function addManager(address _manager) public isOwner {
        _managers[_manager] = 1;    
    }
    
    function removeManager(address manager) public isOwner {
        _managers[manager] = 0;
    }
    
    function () public payable {
        emit DepositFunds(msg.sender, msg.value);
    }
    
    function withdraw(uint amount) public isManager {
        require(address(this).balance >= amount, "not enough funds");
        msg.sender.transfer(amount);
        emit WithdrawFunds(msg.sender, amount);
    }
    
}
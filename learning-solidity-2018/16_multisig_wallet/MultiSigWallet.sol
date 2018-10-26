/*
 based on https://www.youtube.com/watch?v=23YLeX7mpbU
*/
pragma solidity 0.4.24;

contract MultiSigWallet {
    address private _owner;
    mapping (address => uint8) private _managers;
    
    modifier isOwner {
        require(_owner == msg.sender, "must be an owner");
        _;
    }
    
    modifier isManager {
        require(
            msg.sender == _owner || _managers[msg.sender] == 1,
            "must be a manager"
            );
        _;
    }
    
    uint constant MIN_SIGNATURES = 3;
    uint private _transactionIdx;

    struct Transaction {
        address from;
        address to;
        uint amount;
        uint8 signatureCount;
        mapping (address => uint8) signatures;
    }

    mapping (uint => Transaction) private _transactions;
    uint[] private _pendingTransactions;  
    
    constructor() public {
        _owner = msg.sender;
    }
    
    event DepositFunds(address from, uint amount);
    event TransferFunds(address to, uint amount);
    event TransactionCreated(
        address from, 
        address to, 
        uint amount, 
        uint transactionId
    );
    
    function addManager(address _manager) public isOwner {
        _managers[_manager] = 1;    
    }
    
    function removeManager(address manager) public isOwner {
        _managers[manager] = 0;
    }
    
    function () public payable {
        emit DepositFunds(msg.sender, msg.value);
    }
    
    function withdraw(uint amount) isManager public {
        transferTo(msg.sender, amount);
    }
    
    function transferTo(address to, uint amount) isManager public {
        require(address(this).balance >= amount, "not enough funds");
        uint transactionId = _transactionIdx++;
        
        Transaction memory transaction;
        transaction.from = msg.sender; //not sure about that
        transaction.to = to;
        transaction.amount = amount;
        transaction.signatureCount = 0;
        _transactions[transactionId] = transaction;
        _pendingTransactions.push(transactionId);
        emit TransactionCreated(msg.sender, to, amount, transactionId);
        
    }
    
    function getPendingTransactions() public isManager view returns(uint[]) {
        return _pendingTransactions;
    }
    
    function signTransaction(uint _transactionId) public isManager {
        Transaction storage transaction = _transactions[_transactionId];
        require(0x0 != transaction.from, "transaction must exist");
        require(
            msg.sender != transaction.from, 
            "creator cannot sign the transaction"
        );
        require(
            transaction.signatures[msg.sender] != 1, 
            "you cannot sign it again"
        );
        
        transaction.signatures[msg.sender] = 1;
        transaction.signatureCount++;
        
        if (transaction.signatureCount >= MIN_SIGNATURES) {
            require(
                address(this).balance >= transaction.amount, 
                "not enough funds"
            );
            transaction.to.transfer(transaction.amount);
            emit TransferFunds(transaction.to, transaction.amount); 
            deleteTransaction(_transactionId);
        }
    }
    
    function deleteTransaction(uint transactionId) public isManager {
        uint8 replace = 0;
        for(uint i = 0; i < _pendingTransactions.length; i++) {
            if (1 == replace) {
                _pendingTransactions[i-1] = _pendingTransactions[i];
            } else if (transactionId == _pendingTransactions[i]) {
                replace = 1;
            }
        }
        delete _pendingTransactions[_pendingTransactions.length - 1];
        _pendingTransactions.length--;
        delete _transactions[transactionId];
    }
    
    function walletBalance() public isManager view returns(uint) {
        return address(this).balance;    
    }
}
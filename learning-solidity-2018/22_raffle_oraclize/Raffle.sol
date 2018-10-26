/* 
    Simple raffle with RNG from Oraclize
    based on https://hackernoon.com/building-a-raffle-contract-using-oraclize-e746e5edff6b
*/
pragma solidity ^0.4.24;

import "../utils/usingOraclize.sol";

contract Raffle is usingOraclize {
    uint8 minParticipants = 2;
    uint8 maxParticipants = 10;
    uint8 participantsNumber;
    uint public chosenNumber;
    address public winner;
    address owner;
    bool raffleFinished = false;
    
    address[] public participants;
    
    mapping (address => bool) participantsMapping;
    
    event ChooseWinner(uint _chosenNumber, address winner);
    event RandomNumberGenerated(uint);

    constructor() public payable {
        owner = msg.sender;
    }

    function() public payable {}
    
    function joinRaffle() public {
        require(!raffleFinished);
        require(msg.sender != owner, "Owner can't join");
        require(participantsNumber <= maxParticipants);
        require(!participantsMapping[msg.sender]);
        participants.push(msg.sender);
        participantsMapping[msg.sender] = true;
        participantsNumber++;
    }
    
    function chooseWinner(uint _chosenNum) internal {
        chosenNumber = _chosenNum;
        winner = participants[chosenNumber];
        emit ChooseWinner(chosenNumber,participants[chosenNumber]);
    }
    
    function generateRandomNum() public {
        require(!raffleFinished);
        require(participantsNumber >= minParticipants && participantsNumber <= maxParticipants);
        oraclize_setProof(proofType_Ledger); // sets the Ledger authenticity proof
        uint N = 4; // number of random bytes we want the datasource to return
        uint delay = 0; // number of seconds to wait before the execution takes place
        uint callbackGas = 200000; // amount of gas we want Oraclize to set for the callback function
        // this function internally generates the correct oraclize_query and returns its queryId
        oraclize_newRandomDSQuery(delay, N, callbackGas); 
    }
    
    // the callback function is called by Oraclize when the result is ready
    // the oraclize_randomDS_proofVerify modifier prevents an invalid proof to execute this function code:
    // the proof validity is fully verified on-chain
    function __callback(bytes32 _queryId, string _result, bytes _proof) public {
        // If we already generated a random number, we can't generate a new one.
        require(!raffleFinished);
        // if we reach this point successfully, it means that the attached authenticity proof has passed!
        require (msg.sender == oraclize_cbAddress());
        if (oraclize_randomDS_proofVerify__returnCode(_queryId, _result, _proof) != 0) {
        // the proof verification has failed, do we need to take any action here? (depends on the use case)
        } else {
             // the proof verification has passed
            raffleFinished = true;
            // for simplicity of use, let's also convert the random bytes to uint if we need
            uint maxRange = participantsNumber; // this is the highest uint we want to get. It should never be greater than 2^(8*N), where N is the number of random bytes we had asked the datasource to return
            uint randomNumber = uint(keccak256(abi.encodePacked(_result))) % maxRange; // this is an efficient way to get the uint out in the [0, maxRange] range
            
            chooseWinner(randomNumber);
            emit RandomNumberGenerated(randomNumber); // this is the resulting random number (uint)
        }
    }
}

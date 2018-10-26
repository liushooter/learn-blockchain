pragma solidity ^0.4.24;

import "../utils/usingOraclize.sol";

contract RandomExample is usingOraclize {
    
    event newRandomNumber_bytes(bytes);
    event newRandomNumber_uint(uint);

    constructor() public {
        oraclize_setProof(proofType_Ledger); // sets the Ledger authenticity proof in the constructor
        update(); // let's ask for N random bytes immediately when the contract is created!
    }
    
    // the callback function is called by Oraclize when the result is ready
    // the oraclize_randomDS_proofVerify modifier prevents an invalid proof to execute this function code:
    // the proof validity is fully verified on-chain
    function __callback(bytes32 _queryId, string _result, bytes _proof) public { 
        require(msg.sender == oraclize_cbAddress());
        
        if (oraclize_randomDS_proofVerify__returnCode(_queryId, _result, _proof) != 0) {
            // the proof verification has failed, do we need to take any action here? (depends on the use case)
        } else {
            // the proof verification has passed
            // now that we know that the random number was safely generated, let's use it..
            
            emit newRandomNumber_bytes(bytes(_result)); // this is the resulting random number (bytes)
            
            // for simplicity of use, let's also convert the random bytes to uint if we need
            // this is the highest uint we want to get. It should never be greater than 2^(8*N), where N is the number of random bytes we had asked the datasource to return
            uint maxRange = 2**(8* 7);
            uint randomNumber = uint(keccak256(abi.encodePacked(_result))) % maxRange; // this is an efficient way to get the uint out in the [0, maxRange] range
            
            emit newRandomNumber_uint(randomNumber); // this is the resulting random number (uint)
        }
    }
    
    function update() payable public {
        uint N = 7; // number of random bytes we want the datasource to return
        uint delay = 0; // number of seconds to wait before the execution takes place
        uint callbackGas = 200000; // amount of gas we want Oraclize to set for the callback function
        // this function internally generates the correct oraclize_query and returns its queryId
        oraclize_newRandomDSQuery(delay, N, callbackGas); 
    }   
}
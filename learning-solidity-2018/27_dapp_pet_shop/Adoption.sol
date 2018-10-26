pragma solidity ^0.4.24;

contract Adoption {
    /*
    - address has 20 bytes
    - public creates a getter automatically by in the case of arrays the key is required 
    and only single value can be returned in such getter
    */
    address[16] public adopters; 
    address owner;

    constructor() public {
        owner = msg.sender;
    }

    function adopt(uint petId) public returns (uint) {
        require(petId >= 0 && petId <= 15, "Wrong pet ID");
        adopters[petId] = msg.sender;
        return petId;
    }

    function getAdopters() public view returns (address[16]) {
        return adopters;
    }

    function cancelAdoption(uint petId) public {
        require(owner == msg.sender, "must be owner");
        adopters[petId] = 0x0;
    }
}
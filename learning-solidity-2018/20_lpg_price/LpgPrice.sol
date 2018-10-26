
pragma solidity ^0.4.24;

import "../utils/usingOraclize.sol";

contract LpgPrice is usingOraclize {
    uint public lpgPriceUSD;

    constructor() public payable {
        update();
    }

    function __callback(string result) public {
        require(msg.sender == oraclize_cbAddress());
        lpgPriceUSD = parseInt(result, 2); 
    }

    function update() public payable {
        oraclize_query("URL", "xml(https://www.fueleconomy.gov/ws/rest/fuelprices).fuelPrices.lpg");
    }
}
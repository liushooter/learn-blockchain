
/*
  Learn more about setting a IPFS node: https://michalzalecki.com/set-up-ipfs-node-on-the-server/
*/
pragma solidity ^0.4.24;

import "../utils/usingOraclize.sol";

contract IpfsOraclize is usingOraclize {
    string public body;

    constructor() public payable {
        update();
    }

    function __callback(string result) public {
        require(msg.sender == oraclize_cbAddress());
        body = result; 
    }

    function update() public payable {
        oraclize_query("IPFS", "json(QmYyuvuafPFxDvRmeLgCkhQEnmNs1fxQW9hAsgj7gvrSV2).body");
    }
}
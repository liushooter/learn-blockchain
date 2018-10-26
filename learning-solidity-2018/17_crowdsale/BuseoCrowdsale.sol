pragma solidity 0.4.24;

import "./BuseoCoin.sol";
import "zeppelin-solidity/contracts/crowdsale/emission/MintedCrowdsale.sol";
import "zeppelin-solidity/contracts/crowdsale/validation/TimedCrowdsale.sol";

contract BuseoCrowdsale is MintedCrowdsale, TimedCrowdsale {
    constructor(
        uint _openingTime,
        uint _closingTime,
        uint _rate,
        address _wallet,
        MintableToken _token 
    ) public Crowdsale(_rate, _wallet, _token) TimedCrowdsale(_openingTime, _closingTime) {

    }
}
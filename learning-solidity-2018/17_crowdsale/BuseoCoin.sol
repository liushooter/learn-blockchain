pragma solidity 0.4.24;

import "zeppelin-solidity/contracts/token/ERC20/MintableToken.sol";

contract BuseoCoin is MintableToken {
    string public name = "Buseo Coin";
    string public symbol = "BUSC";
    uint8 public decimals = 18;
}
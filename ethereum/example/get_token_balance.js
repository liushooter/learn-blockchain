var Web3 = require('web3');
var web3 = new Web3();
web3.setProvider(new web3.providers.HttpProvider("https://mainnet.infura.io/") );

var erc20_abi = [{"constant":true,"inputs":[],"name":"name","outputs":[{"name":"","type":"string"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"totalSupply","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"decimals","outputs":[{"name":"","type":"uint8"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"_owner","type":"address"}],"name":"balanceOf","outputs":[{"name":"balance","type":"uint256"}],"payable":false,"type":"function"}];

var my = "0xd551234ae421e3bcba99a0da6d736074f22192ff";
var eos_contract_address = "0x86fa049857e0209aa7d9e616f7eb3b3b78ecfdb0";

var token = new web3.eth.Contract(erc20_abi, eos_contract_address);

token.methods.balanceOf(my).call()
.then(function(balance){
  console.log(balance);
});


// web3.eth.call({
//   address: my,
//   data: token.methods.balanceOf(my).encodeABI()
// }).then(function(balance){
//   console.log(balance)
// })

// https://github.com/ethereum/web3.js/issues/1089
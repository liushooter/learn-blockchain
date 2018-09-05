var Web3 = require('web3');
var web3 = new Web3();

var my = "0xd551234ae421e3bcba99a0da6d736074f22192ff";
var eos_contract_address = "0x86fa049857e0209aa7d9e616f7eb3b3b78ecfdb0";

web3.setProvider(new web3.providers.WebsocketProvider("ws://localhost:8546") );

var sha3 = web3.utils.sha3("Transfer(address,address,uint256)");
// 0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef

var padding = new Array(24+1).join('0'); // 24
var topic_1 = "0x" + padding + my.slice(2);

var subscription = web3.eth.subscribe('logs',
  { fromBlock: '1', toBlock: "latest", address: eos_contract_address, topics: [sha3, topic_1] },
  function() {}
).on("data", function(tx_data){

  function formatAddress(data) {
    var step1 = web3.utils.hexToBytes(data);
    for (var i = 0; i < step1.length; i++) if (step1[0] == 0) step1.splice(0, 1);
    return web3.utils.bytesToHex(step1);
  }

  console.log(tx_data);

  console.log( "------------------------------" );

  console.log("Contract address:" + tx_data.address);
  console.log("transaction value: " + web3.utils.hexToNumberString(tx_data.data) );
  console.log("from: " + formatAddress(tx_data.topics['1']));
  console.log("to: " + formatAddress(tx_data.topics['2']) ) ;

});


// {
// 　　"address":"0x86Fa049857E0209aa7D9e616F7eb3b3B78ECfdb0",
// 　　"topics":[
// 　　　　"0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef",
// 　　　　"0x000000000000000000000000ce69522b62df911fc11ea8627e18fe2c91fb7189",
// 　　　　"0x0000000000000000000000005da3121f442e3192173cede87bf31f3608c510ab"
// 　　],
// 　　"data":"0x000000000000000000000000000000000000000000000ca4f63d7ec15ea04000",
// 　　"blockNumber":5287061,
// 　　"transactionHash":"0xf2f25bbc4a21919c16e554babc9b3cfd7884b2f6c446ea6fd4b1fc7354bae308",
// 　　"transactionIndex":65,
// 　　"blockHash":"0xca557515bc567d1ca88e245937097957d0351a3f7277435027312dc55bdebb51",
// 　　"logIndex":24,
// 　　"removed":false,
// 　　"id":"log_8db999fc"
// }

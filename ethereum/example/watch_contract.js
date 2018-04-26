var fs = require('fs');
var Web3 = require('web3');

var web3 = new Web3();
web3.setProvider(new web3.providers.WebsocketProvider("ws://localhost:8546") );

var json_file = "./eos_abi.json";
var abi = JSON.parse(fs.readFileSync(json_file));

var my = "0xd551234ae421e3bcba99a0da6d736074f22192ff";
var eos_contract_address = "0x86fa049857e0209aa7d9e616f7eb3b3b78ecfdb0";

var EosContract = new web3.eth.Contract(abi, eos_contract_address);

EosContract.events.Transfer({fromBlock:1, toBlock: "latest"}, function(err, data){
  console.log(data);
});


// geth --datadir /mnt/eth --rpc --ws --wsaddr localhost --wsorigins "*" --wsapi "eth,web3,net,txpool,shh,subpub"

// https://github.com/INFURA/infura/issues/73

// {
//   address: '0x86Fa049857E0209aa7D9e616F7eb3b3B78ECfdb0',
//   blockNumber: 5287776,
//   transactionHash: '0xef9ac879a4965798c19be19e25d463ae39b4ae6c2c1c7f8ad37db44fdd730bec',
//   transactionIndex: 60,
//   blockHash: '0xa91f0b939b2b32eaac389c237effa62d67041db3a08301315a057f8e1fdc381d',
//   logIndex: 33,
//   removed: false,
//   id: 'log_9b70c465',
//   returnValues:
//   Result {
//     '0': '0x1951553Ee59404B295e806d813093196375d544F',
//     '1': '0x58DB97F63A496E74E52f7F792291e8CdEF70E6e7',
//     '2': '26000000000000000000',
//     from: '0x1951553Ee59404B295e806d813093196375d544F',
//     to: '0x58DB97F63A496E74E52f7F792291e8CdEF70E6e7',
//     value: '26000000000000000000' },
//   event: 'Transfer',
//   signature: '0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef',
//   raw:{
//     data: '0x00000000000000000000000000000000000000000000000168d28e3f00280000',
//     topics:
//       [ '0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef',
//         '0x0000000000000000000000001951553ee59404b295e806d813093196375d544f',
//         '0x00000000000000000000000058db97f63a496e74e52f7f792291e8cdef70e6e7'
//       ]
//   }
// }

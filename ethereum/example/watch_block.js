var Web3 = require('web3');
var web3 = new Web3();
web3.setProvider(new web3.providers.WebsocketProvider("ws://localhost:8546") );

var subscribe =  web3.eth.subscribe('newBlockHeaders', function(err, res){
  if(!err){
    console.log(res);
  }
})
.on('data', function(block){
  console.log( "----------" );
  console.log(block);
  console.log( "----------" );
});

subscribe.unsubscribe(function(err, succ){
  if(succ){
    console.log('ok');
  }
});

// geth --datadir /mnt/eth --rpc --ws --wsaddr localhost --wsorigins "*" --wsapi "eth,web3,net,txpool,shh, subpub" --syncmode "full"

// var web3 = new Web3('ws://127.0.0.1:8546');
// web3.setProvider(new web3.providers.HttpProvider("http://localhost:8545") );
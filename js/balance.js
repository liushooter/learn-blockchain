var Trie = require('merkle-patricia-tree/secure');
var levelup = require('levelup');
var leveldown = require('leveldown');
var utils = require('ethereumjs-util');
var Account = require('ethereumjs-account');

var BN = utils.BN;

//leveldb 的位置
var db = levelup(leveldown("/mnt/eth/geth/chaindata"));

var stateRoot = '0x4fffccde51d5e91055274ba4a99b22ae37b604ac77b9e8f89e4b46528d10cc25';
//block 2406803的stateRoot

var trie = new Trie(db, stateRoot);

var addrs = [
  "0xd38d3c226d0a86ce9932608edac39163fcbc550e", //胡乱生成的地址
  "0x91cdc068c87561cbdc242dc6affd0182e45879f9",
  "0xea908b3d5f79d866e25daf1a38814bc1b1405d43",
  "0x84d71dc5aa5f0444e1cc9c4d7ff42e17efb5c84b",
  "0x47fd5bf024f8e1503ed9515bd8d40d6cd6f95766",
  "0xbe0df0f830a9f98b5d480ed9609ee81c2e67b4d6",
  "0x31629fa399fc50da394d997008aec612168b337b",
  "0xa8fee34e1652d223ae5daff9ba390658805d2736",
  "0x8de9cabd5635c9d182dd72e16237c40bf24487c7",
  "0xb3e972762769ab537a7931e3871c04ecb34ac434",
]


for (i = 0; i < addrs.length; i++) {
  var addr = addrs[i];

  trie.get(addr, function(err, raw) {
    if (err) return cb(err)
    var account = new Account(raw)
    console.log('raw Account : ' + JSON.stringify(raw));
    console.log('Account Address: ' + addr);
    console.log('Balance: ' + (new BN(account.balance)).toString());
    console.log("--------------------");
  })

}

// geth --syncmode full # eth同步方式必须是full
// 参考 https://github.com/ethereumjs/merkle-patricia-tree/issues/32#issuecomment-363654149

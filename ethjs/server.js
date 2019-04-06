//Mozilla Public License 2.0
//As per https://github.com/ethereumjs/ethereumjs-vm/blob/master/LICENSE
//Requires the following packages to run as nodejs file https://gist.github.com/tpmccallum/0e58fc4ba9061a2e634b7a877e60143a

//Getting the requirements
var Trie = require('merkle-patricia-tree/secure');
var levelup = require('levelup');
var leveldown = require('leveldown');
var utils = require('ethereumjs-util');
var BN = utils.BN;
var Account = require('ethereumjs-account');

//Connecting to the leveldb database
var db = levelup(leveldown('/Users/shooter/Library/Ethereum/geth/chaindata'));

//Adding the "stateRoot" value from the block so that we can inspect the state root at that block height.
var stateRoot = "0x10c19bc58bbd8b57861d8268b7316c248ab6fb3128ddd12082e4a811b343c3fd";

//Creating a trie object of the merkle-patricia-tree library
var trie = new Trie(db, stateRoot);

var address = '0xbb7b8287f3f0a933474a79eae42cbca977791171'; // block 100

trie.get(address, function (err, raw) {
    if (err) return cb(err)
    //Using ethereumjs-account to create an instance of an account
    var account = new Account(raw)
    console.log('Address: ' + address);
    console.log('raw Account: ' + raw);
    console.log('Account : ' + JSON.stringify(account) );

    //Using ethereumjs-util to decode and present the account balance
    console.log('Balance: ' + account.stateRoot.toString('hex') );
})

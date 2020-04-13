const keyth = require('keythereum')

const keyobj = keyth.importFromFile('0x' + "ce7a516a9948a948808b51864c172d53c8401bf8", '../')

const privateKey = keyth.recover('123456', keyobj) //this takes a few seconds to finish

console.log("privateKey: ", privateKey.toString('hex'))
// e72462df465df759764cdef152a48fc42aff6451ad552af589e619546838545d
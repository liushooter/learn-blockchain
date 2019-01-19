const createKeccakHash = require('keccak')

function toChecksumAddress(address) {
  address = address.toLowerCase().replace('0x', '')
  var hash = createKeccakHash('keccak256').update(address).digest('hex')
  var ret = '0x'

  for (var i = 0; i < address.length; i++) {
    if (parseInt(hash[i], 16) >= 8) {
      ret += address[i].toUpperCase()
    } else {
      ret += address[i]
    }
  }

  return ret
}

// https://github.com/ethereum/EIPs/blob/master/EIPS/eip-55.md

console.log(toChecksumAddress('0xfb6916095ca1df60bb79ce92ce3ea74c37c5d359'))
console.log(toChecksumAddress("0xa31a1f15f94a5bb3012cae593c2c15217e9e21a4"))
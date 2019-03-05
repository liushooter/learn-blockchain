require 'digest'

_pri_key = "ccea9c5a20e2b78c2e0fbdd8ae2d2b67e6b1894ccb7a55fc1de08bd53994ea64"

_wif_mainnet = '80'
_wif_testnet = 'ef'

def _hash160(pub_key)
  bytes = [pub_key].pack("H*")
  Digest::RMD160.hexdigest(Digest::SHA256.digest(bytes) )
end

def _checksum(val)
  hex_str = [val].pack("H*")
  Digest::SHA256.hexdigest(Digest::SHA256.digest(hex_str) )[0...8]
end

def _encode_base58(int_val, leading_zero_bytes=0)
  alpha = "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz"
  base58_val, base = '', alpha.size

  while int_val > 0
    int_val, remainder = int_val.divmod(base)
    base58_val = alpha[remainder] + base58_val
  end

  base58_val
end

def _base58_to_int(base58_val)
    alphabet = "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz"

    size = alphabet.size

    int_val = 0
    base58_val.reverse.split(//).each_with_index do |char,index|
      char_index = alphabet.index(char)
      int_val += (char_index)*(size**(index))
    end
    int_val
  end


def _int_to_hex int
  hex = int.to_s(16)
  (hex.length % 2 == 0) ? hex : ('0'+hex)
end

def _decode_base58(base58_val)
  alphabet = "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz"

  nzeroes = base58_val.chars.find_index{|c| c != alphabet[0]} || base58_val.length-1
  prefix = nzeroes < 0 ? '' : '00' * nzeroes

  nzeroes = base58_val.chars.find_index{|c| c != alphabet} || base58_val.length-1
  prefix = nzeroes < 0 ? '' : '00' * nzeroes
  prefix + _int_to_hex(_base58_to_int(base58_val))
end

def pri_key_to_wif(prefix, pri, compress=true)
  flag = compress ? "01" : ""
  rk = prefix + pri + flag
  hash160 = _hash160(rk)
  checksum = _checksum(rk)
  val = rk + checksum

  _encode_base58(val.to_i(16))
end


def wif_to_pri_key(wif_addr)
  pri_key = ""
  _val = _decode_base58(wif_addr)

  if wif_addr.size == 52
      pri_key = _val[2..-11]
  end

 if wif_addr.size == 51
      pri_key = _val[2..-9]
  end

  pri_key
end

puts "WIF: Wallet Import Format"
puts "非压缩私钥的WIF格式是51位长度, 已5开头"
puts "压缩私钥的WIF格式是52位长度, 已K或L开头"

puts

res = pri_key_to_wif(_wif_mainnet, _pri_key)
puts res
puts wif_to_pri_key(res)

puts

puts wif_to_pri_key(pri_key_to_wif(_wif_mainnet, _pri_key, false))

# http://learnmeabitcoin.com/glossary/wif
# https://github.com/dougal/base58/blob/master/lib/base58.rb
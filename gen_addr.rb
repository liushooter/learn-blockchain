require 'digest'

_pri_key = "ccea9c5a20e2b78c2e0fbdd8ae2d2b67e6b1894ccb7a55fc1de08bd53994ea64"
_pub_key = "04d061e9c5891f579fd548cfd22ff29f5c642714cc7e7a9215f0071ef5a5723f691757b28e31be71f09f24673eed52348e58d53bcfd26f4d96ec6bf1489eab429d"
_compressed_pub_key = "03d061e9c5891f579fd548cfd22ff29f5c642714cc7e7a9215f0071ef5a5723f69" #压缩公钥

_P2PKH = "00"
_P2SH = "05"
_Testnet = "6F"

def _hash160(pub_key)
  bytes = [pub_key].pack("H*") # 转为16进制
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

def gen_addr(prefix, pub)
  hash160 = _hash160(pub)
  tmp = prefix + hash160
  checksum = _checksum(tmp)
  val = tmp+checksum

  leading_zero_bytes = (val.match(/^([0]+)/) ? $1 : '').size / 2
  ("1" * leading_zero_bytes) + _encode_base58(val.to_i(16) )
end

puts gen_addr(_P2PKH, _pub_key)
puts gen_addr(_P2SH, _pub_key)
puts gen_addr(_Testnet, _pub_key)
puts

puts "#############压缩公钥#############"
puts "现在一般都使用压缩公钥, 压缩/未压缩公钥生成的地址确实会不一样, 非压缩公钥早已成了非主流"
puts gen_addr(_P2PKH, _compressed_pub_key)
puts gen_addr(_P2SH, _compressed_pub_key)
puts gen_addr(_Testnet, _compressed_pub_key)
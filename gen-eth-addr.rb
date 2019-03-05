require 'digest/sha3'

# https://github.com/phusion/digest-sha3-ruby

def unhexlify(msg)
  msg.scan(/../).collect { |c| c.to_i(16).chr }.join
end

_openssl_pub_key= "04d061e9c5891f579fd548cfd22ff29f5c642714cc7e7a9215f0071ef5a5723f691757b28e31be71f09f24673eed52348e58d53bcfd26f4d96ec6bf1489eab429d"
_pub_key = _openssl_pub_key[2..-1]
_pub_hex = unhexlify(_pub_key)

hexdigest = Digest::SHA3.hexdigest(_pub_hex, 256)

address = "0x" + hexdigest[24..-1]

puts address #0x9156a7cdab767ffe161ed21a0cb0b688b545b01f

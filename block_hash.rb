require 'digest'

ver = 1
prev_block = "000000000019d6689c085ae165831e934ff763ae46a2a6c172b3f1b60a8ce26f"
mrkl_root = "0e3e2357e806b6cdb1f70b54c3a3a17b6714ee1f0e68bebb44a74b1efd512098"
time = 1231469665
bits = 486604799
nonce = 2573394689

hex_str = [ver].pack("L<") + [prev_block].pack("H*").reverse + [mrkl_root].pack("H*").reverse + [time, bits, nonce].pack("LLL<")

hash_str = Digest::SHA256.digest(Digest::SHA256.digest(hex_str))

block_hash = hash_str.reverse.unpack("H*")
p block_hash[0]
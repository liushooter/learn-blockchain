#coding:utf-8

import sha3
import binascii
from ecdsa import SigningKey, SECP256k1

priv = SigningKey.generate(curve=SECP256k1) #生成私钥
pub = priv.get_verifying_key() #生成公钥

keccak = sha3.keccak_256()
keccak.update( pub.to_string()) #keccak_256哈希运算
address = "0x" + keccak.hexdigest()[24:]

priv_key = binascii.hexlify( priv.to_string())
pub_key = binascii.hexlify( pub.to_string())

print("Private key: " + priv_key.decode() )
print("Public key:  " + pub_key.decode() )
print("Address:     " + address)

print "#############################"

_openssl_pub_key = "04d061e9c5891f579fd548cfd22ff29f5c642714cc7e7a9215f0071ef5a5723f691757b28e31be71f09f24673eed52348e58d53bcfd26f4d96ec6bf1489eab429d"

_pub_key = _openssl_pub_key[2:]
_pub_hex = binascii.unhexlify(_pub_key)

keccak = sha3.keccak_256()
keccak.update(_pub_hex)

address = "0x" + keccak.hexdigest()[24:]

print address #0x9156a7cdab767ffe161ed21a0cb0b688b545b01f
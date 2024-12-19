import hashlib
from Crypto.Hash import keccak
from Crypto.Cipher import AES
from Crypto.Util import Counter

password = "123456"
dec_key = hashlib.scrypt(bytes(password, 'utf-8'), salt = bytes.fromhex('24342a0a31512e75b2e11a1a5dc2706f76b7efaf96dfe2bde5dfcedadbf40a5e'), n = 262144, r = 8, p = 1, maxmem = 2000000000, dklen = 32)

print(dec_key.hex())

validate = dec_key[16:] + bytes.fromhex('07eaa07fc9fb681b2cf836331d0c59e43a971dc65676f7dcf021e83c68374b171e2752a1f56b80606136c35126c17bca465d68479477f18900a3e154b08d48560b25')# ciphertext

keccak_hash = keccak.new(digest_bits = 256)
keccak_hash.update(validate)
print("keccak_hash ", keccak_hash.hexdigest()) # mac

iv_int = int('12e867c52f39fd32403f38da840f7437', 16)
ctr = Counter.new(AES.block_size * 8, initial_value = iv_int)
dec_suite = AES.new(dec_key[0:16], AES.MODE_CTR, counter = ctr)

plain_key = dec_suite.decrypt(bytes.fromhex('07eaa07fc9fb681b2cf836331d0c59e43a971dc65676f7dcf021e83c68374b171e2752a1f56b80606136c35126c17bca465d68479477f18900a3e154b08d48560b25'))# ciphertext
print("privKey", plain_key.hex())
# e72462df465df759764cdef152a48fc42aff6451ad552af589e619546838545d

'''
{
    "crypto":{
        "ciphertext":"07eaa07fc9fb681b2cf836331d0c59e43a971dc65676f7dcf021e83c68374b171e2752a1f56b80606136c35126c17bca465d68479477f18900a3e154b08d48560b25",
        "cipherparams":{
            "iv":"5c5a77e47d835fee47bbc9226217b4a9"
        },
        "cipher":"aes-128-ctr",
        "kdf":"scrypt",
        "kdfparams":{
            "dklen":32,
            "n":262144,
            "p":1,
            "r":8,
            "salt":"24342a0a31512e75b2e11a1a5dc2706f76b7efaf96dfe2bde5dfcedadbf40a5e"
        },
        "mac":"ece6fe402ad14a5ac1b5e40895ce4217f01cf8b2df8507bc5390cbf75ce46da2"
    },
    "id":"7fc8554d-7fb5-4e3e-b526-ea352bd7a233",
    "version":3
}

'''

# https://ethereum.stackexchange.com/questions/3720/how-do-i-get-the-raw-private-key-from-my-mist-keystore-file
# https://ethereum.stackexchange.com/questions/19577/export-parity-private-key

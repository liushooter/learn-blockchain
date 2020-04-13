import hashlib
from Crypto.Hash import keccak
from Crypto.Cipher import AES
from Crypto.Util import Counter

password = "123456"
dec_key = hashlib.scrypt(bytes(password, 'utf-8'), salt = bytes.fromhex('12e26f432ce1a50c9ef7d45cd818a4c070740dffd4e63df577a34c27dda9ef76'), n = 262144, r = 8, p = 1, maxmem = 2000000000, dklen = 32)

print(dec_key.hex())

validate = dec_key[16:] + bytes.fromhex('e5c00fc33f7b0b33e7a40d055d162b10cbd3ff29bb8a225d14a151a51675d8ad')# ciphertext

keccak_hash = keccak.new(digest_bits = 256)
keccak_hash.update(validate)
print("keccak_hash ", keccak_hash.hexdigest()) # mac

iv_int = int('12e867c52f39fd32403f38da840f7437', 16)
ctr = Counter.new(AES.block_size * 8, initial_value = iv_int)
dec_suite = AES.new(dec_key[0:16], AES.MODE_CTR, counter = ctr)

plain_key = dec_suite.decrypt(bytes.fromhex('e5c00fc33f7b0b33e7a40d055d162b10cbd3ff29bb8a225d14a151a51675d8ad'))# ciphertext
print("privKey", plain_key.hex())

'''
{
    "address":"ce7a516a9948a948808b51864c172d53c8401bf8",
    "crypto":{
        "cipher":"aes-128-ctr",
        "ciphertext":"e5c00fc33f7b0b33e7a40d055d162b10cbd3ff29bb8a225d14a151a51675d8ad",
        "cipherparams":{
            "iv":"12e867c52f39fd32403f38da840f7437"
        },
        "kdf":"scrypt",
        "kdfparams":{
            "dklen":32,
            "n":262144,
            "p":1,
            "r":8,
            "salt":"12e26f432ce1a50c9ef7d45cd818a4c070740dffd4e63df577a34c27dda9ef76"
        },
        "mac":"7d4cb77f755b03e10b8782c1893d6c21245d826e20c70a94a258995632706a25"
    },
    "id":"f6333c44-f69e-4636-85c0-8a8d725d9b24",
    "version":3
}

'''

# https://ethereum.stackexchange.com/questions/3720/how-do-i-get-the-raw-private-key-from-my-mist-keystore-file
# https://ethereum.stackexchange.com/questions/19577/export-parity-private-key

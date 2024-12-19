# https://mp.weixin.qq.com/s/zEIIXToqxhClxBpkKRIC3g
# bip86

import bip39
import bech32
from bip32 import BIP32, HARDENED_INDEX
from hashlib import sha256
from ecdsa import SECP256k1, SigningKey

def generate_taproot_address(mnemonic):
    seed = bip39.phrase_to_seed(mnemonic)
    bip32 = BIP32.from_seed(seed)
    path = "m/86'/0'/0'/0/0"
    child_key = bip32.get_privkey_from_path(path)
    private_key = SigningKey.from_string(child_key, curve=SECP256k1)
    public_key = private_key.get_verifying_key().to_string("compressed")
    tweak = sha256(b'TapTweak' + public_key[1:]).digest()
    tweaked_pubkey = bytearray(public_key)
    for i in range(32):
        tweaked_pubkey[1 + i] ^= tweak[i]
    witver = 1  # witness version for Taproot
    witprog = tweaked_pubkey[1:33]
    address = bech32.encode('bc', witver, witprog)
    return address

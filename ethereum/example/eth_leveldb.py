import rlp
import plyvel
from rlp.sedes import big_endian_int, BigEndianInt, Binary, binary, CountableList

from ethereum.transactions import Transaction

header_prefix = b'h'
body_prefix   = b'b' # bodyPrefix + num (uint64 big endian) + hash -> rlpEncode(block body)
num_suffix    = b'n' # headerPrefix + num (uint64 big endian) + numSuffix -> hash

block_num = 1210300 # 高度 0x1277bc
db_path = "/mnt/eth/geth/chaindata"

block_num_b = (block_num).to_bytes(8, byteorder='big') # Uint64 BigEndian
(block_num).to_bytes(8, byteorder='big').hex() # Uint64 BigEndian hex

header_key = header_prefix + block_num_b + num_suffix

db = plyvel.DB(db_path)

block_hash = db.get(header_key)

header_key = header_prefix + block_num_b + block_hash

block_header_data = db.get(header_key)

address = Binary.fixed_length(20, allow_empty=True)
int20 = BigEndianInt(20)
int32 = BigEndianInt(32)
int256 = BigEndianInt(256)
hash32 = Binary.fixed_length(32)
trie_root = Binary.fixed_length(32, allow_empty=True)


class BlockHeader(rlp.Serializable):
    # https://github.com/ethereum/pyethereum/blob/96342bd1febd6c9dca2e17bbba89d736588f6227/ethereum/block.py#L19
    fields = [
        ('prev_hash', hash32),
        ('uncles_hash', hash32),
        ('coinbase', address),
        ('state_root', trie_root),
        ('tx_list_root', trie_root),
        ('receipts_root', trie_root),
        ('bloom', int256),
        ('difficulty', big_endian_int),
        ('number', big_endian_int),
        ('gas_limit', big_endian_int),
        ('gas_used', big_endian_int),
        ('timestamp', big_endian_int),
        ('extra_data', binary),
        ('mix_hash', binary),
        ('nonce', binary)
    ]


header = rlp.decode(block_header_data, BlockHeader)

print("block hash: " , block_hash.hex())
print("coinbase address: ", header.coinbase.hex() )
print("prev block hash: ", header.prev_hash.hex() )
print("nonce: ", header.nonce.hex() )

# class Transaction(rlp.Serializable):
#     # https://github.com/ethereum/pyethereum/blob/develop/ethereum/transactions.py#L20

class BlockBody(rlp.Serializable):
    fields = [
        ('transactions', CountableList(Transaction)),
        ('uncles', CountableList(BlockHeader))
    ]

class Block(rlp.Serializable):
    # https://github.com/ethereum/pyethereum/blob/96342bd1febd6c9dca2e17bbba89d736588f6227/ethereum/block.py#L142

    fields = [
        ('header', BlockHeader),
        ('transactions', CountableList(Transaction)),
        ('uncles', CountableList(BlockHeader))
    ]

block_body_key = body_prefix + block_num_b + block_hash

block_body = db.get(block_body_key)

if block_body == b"\xc2\xc0\xc0": #block_body is none
    print("txs is None")
else:
    body = rlp.decode(block_body, BlockBody)

    for tx in body.transactions:
        sender = tx.sender.hex()
        tx_hash = tx.hash.hex()

        print("tx_hash: ", tx_hash)
        print("tx_from: ", sender)

        print("tx_nonce: ", tx.nonce)
        print("tx_gasprice: ", tx.gasprice)
        print("tx_startgas: ",tx.startgas)
        print("tx_to: ",  tx.to.hex())
        print("tx_value: ", tx.value)
        print("tx_data: ", tx.data)


db.close()
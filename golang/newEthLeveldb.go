package main

import (
	"fmt"
	"github.com/ethereum/go-ethereum/common"
	"github.com/ethereum/go-ethereum/core/rawdb"
)

// type Header struct {
// 	ParentHash  common.Hash    `json:"parentHash"       gencodec:"required"`
// 	UncleHash   common.Hash    `json:"sha3Uncles"       gencodec:"required"`
// 	Coinbase    common.Address `json:"miner"            gencodec:"required"`
// 	Root        common.Hash    `json:"stateRoot"        gencodec:"required"`
// 	TxHash      common.Hash    `json:"transactionsRoot" gencodec:"required"`
// 	ReceiptHash common.Hash    `json:"receiptsRoot"     gencodec:"required"`
// 	Bloom       Bloom          `json:"logsBloom"        gencodec:"required"`
// 	Difficulty  *big.Int       `json:"difficulty"       gencodec:"required"`
// 	Number      *big.Int       `json:"number"           gencodec:"required"`
// 	GasLimit    uint64         `json:"gasLimit"         gencodec:"required"`
// 	GasUsed     uint64         `json:"gasUsed"          gencodec:"required"`
// 	Time        uint64         `json:"timestamp"        gencodec:"required"`
// 	Extra       []byte         `json:"extraData"        gencodec:"required"`
// 	MixDigest   common.Hash    `json:"mixHash"`
// 	Nonce       BlockNonce     `json:"nonce"`
// }

// type Body struct {
// 	Transactions []*Transaction
// 	Uncles       []*Header
// }

// type Transaction struct {
// 	data txdata
// 	// caches
// 	hash atomic.Value
// 	size atomic.Value
// 	from atomic.Value
// }

// type txdata struct {
// 	AccountNonce uint64          `json:"nonce"    gencodec:"required"`
// 	Price        *big.Int        `json:"gasPrice" gencodec:"required"`
// 	GasLimit     uint64          `json:"gas"      gencodec:"required"`
// 	Recipient    *common.Address `json:"to"       rlp:"nil"` // nil means contract creation
// 	Amount       *big.Int        `json:"value"    gencodec:"required"`
// 	Payload      []byte          `json:"input"    gencodec:"required"`

// 	// Signature values
// 	V *big.Int `json:"v" gencodec:"required"`
// 	R *big.Int `json:"r" gencodec:"required"`
// 	S *big.Int `json:"s" gencodec:"required"`

// 	// This is only used when marshaling to JSON.
// 	Hash *common.Hash `json:"hash" rlp:"-"`
// }

var (
	// num    = 46147
	upNum       = 1
	endNum      = 3
	dbPath      = "/mnt/eth/geth/chaindata"
	ancientPath = dbPath + "/ancient" // 必须是绝对路径
)

func main() {
	ancientDb, err := rawdb.NewLevelDBDatabaseWithFreezer(dbPath, 16, 1, ancientPath, "")
	if err != nil {
		panic(err)
	}

	// ReadHeadHeaderHash retrieves the hash of the current canonical head header.
	currHeader := rawdb.ReadHeadHeaderHash(ancientDb)
	fmt.Printf("currHeader: %x\n", currHeader)

	// ReadHeaderNumber returns the header number assigned to a hash.
	currHiehgt := rawdb.ReadHeaderNumber(ancientDb, currHeader)
	fmt.Printf("currHiehgt: %d\n", currHiehgt)

	fmt.Println("----------------------------------------------------------------")

	for i := upNum; i <= endNum; i++ {
		// ReadCanonicalHash retrieves the hash assigned to a canonical block number.
		blkHash := rawdb.ReadCanonicalHash(ancientDb, uint64(i))

		// hash := rawdb.ReadAllHashes(ancientDb, uint64(i))

		fmt.Printf("etherscan url: https://etherscan.io/block/%v\n", i)

		if blkHash == (common.Hash{}) {
			fmt.Printf("i: %v\n", i)
		} else {
			fmt.Printf("blkHash: %x\n", blkHash)
		}

		// ReadBody retrieves the block body corresponding to the hash.
		blkHeader := rawdb.ReadHeader(ancientDb, blkHash, uint64(i))
		fmt.Printf("blkHeader Coinbase: 0x%x\n", blkHeader.Coinbase)
		fmt.Printf("blkHeader Time: %d\n", blkHeader.Time)

		// ReadBody retrieves the block body corresponding to the hash.
		blkBody := rawdb.ReadBody(ancientDb, blkHash, uint64(i))
		fmt.Printf("blkBody: %v\n", blkBody)
		fmt.Printf("blkBody Uncles size: %x\n", len(blkBody.Uncles))
		for _, uncle := range blkBody.Uncles {
			fmt.Printf("uncle Hash: 0x%x\n", uncle.Hash())
		}

		fmt.Printf("blkBody Tx size: %x\n", len(blkBody.Transactions))
		for _, tx := range blkBody.Transactions {
			fmt.Printf("tx Hash: 0x%x\n", tx.Hash())
			fmt.Printf("tx To: 0x%x\n", tx.To())
		}

		// ReadBlock retrieves an entire block corresponding to the hash
		block := rawdb.ReadBlock(ancientDb, blkHash, uint64(i))
		fmt.Printf("block hash: 0x%x\n", block.Hash())

		fmt.Println("----------------------------------------------------------------")
	}

}

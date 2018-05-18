package main

import (
	"bytes"
	"encoding/binary"
	"fmt"
	"github.com/ethereum/go-ethereum/core/types"
	"github.com/ethereum/go-ethereum/rlp"
	"github.com/syndtr/goleveldb/leveldb"
)

var (
	headerPrefix        = []byte("h") // headerPrefix + num (uint64 big endian) + hash -> header
	blockReceiptsPrefix = []byte("r") // blockReceiptsPrefix + num (uint64 big endian) + hash -> block receipts
	bodyPrefix          = []byte("b") // bodyPrefix   + num (uint64 big endian) + hash -> block body
	numSuffix           = []byte("n")
)

func main() {
	// Connection to leveldb
	db, _ := leveldb.OpenFile("/mnt/data/eth/geth/chaindata", nil)

	num := 3000003 // 区块高度
	blockNumber := make([]byte, 8)
	binary.BigEndian.PutUint64(blockNumber, uint64(num))

	fmt.Printf("Block number : %v \n", num)

	// create key to get hash (headerPrefix + num (uint64 big endian) + numSuffix)
	headerKey := append(headerPrefix, blockNumber...) // adding prefix
	headerKey = append(headerKey, numSuffix...)      // adding suffix

	// Getting hash using hashKey
	blockHash, _ := db.Get(headerKey, nil)
	fmt.Printf("Block hash: %x \n", blockHash)

	//get Block Header data from db
	blockHeaderData, _ := db.Get(headerKey, nil)

	//new Blockheader type
	blockHeader := new(types.Header)

	// Read blockHeaderData in a tmp variable
	tmpByteData := bytes.NewReader(blockHeaderData)

	//Decode tmpByteData to new blockHeader
	rlp.Decode(tmpByteData, blockHeader)

	fmt.Printf("ParentHash is %x \n", blockHeader.ParentHash)
	fmt.Printf("UncleHash is %x \n", blockHeader.UncleHash)
	fmt.Printf("Coinbase is %x \n", blockHeader.Coinbase.Hash())
	fmt.Printf("Difficulty is %s \n", blockHeader.Difficulty)
	fmt.Printf("Time is %s \n", blockHeader.Time)
	fmt.Printf("Nonce is %x \n", blockHeader.Nonce)

	fmt.Printf("\n")

	ReceiptsData, _ := db.Get(append(append(blockReceiptsPrefix, blockNumber...), blockHash...), nil)

	storageReceipts := []*types.ReceiptForStorage{}

	rlp.DecodeBytes(ReceiptsData, &storageReceipts)

	for _, receipt := range storageReceipts {
		fmt.Printf("-------------------------------- \n")

		fmt.Printf("PostState is %v \n", receipt.PostState)
		fmt.Printf("Status is %x \n", receipt.Status)
		fmt.Printf("CumulativeGasUsed is %x \n", receipt.CumulativeGasUsed)

		fmt.Printf("TxHash is %x \n", receipt.TxHash)
		fmt.Printf("ContractAddress is %x \n", receipt.ContractAddress)
		fmt.Printf("Logs length is %v \n", len(receipt.Logs))

		for _, log := range receipt.Logs {
			fmt.Printf("++++++++++++++++++++++++++++++ \n")

			for _, topic := range log.Topics {

				fmt.Printf("topic is %x \n", topic)
				// ddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef
			}

			fmt.Printf("++++++++++++++++++++++++++++++ \n")

		}
	}

}

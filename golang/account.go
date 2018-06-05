package main

import (
	"bytes"
	"encoding/binary"
	"encoding/hex"
	"fmt"
	"math/big"

	"github.com/ethereum/go-ethereum/common"
	"github.com/ethereum/go-ethereum/core/state"
	"github.com/ethereum/go-ethereum/core/types"
	"github.com/ethereum/go-ethereum/crypto/sha3"
	"github.com/ethereum/go-ethereum/ethdb"
	"github.com/ethereum/go-ethereum/rlp"
	"github.com/syndtr/goleveldb/leveldb"
)

var (
	headerPrefix = []byte("h")
	numSuffix    = []byte("n")
	address      = "0xb3e972762769ab537a7931e3871c04ecb34ac434"
	path         = "/mnt/eth/geth/chaindata"
)

func main() {
	db, _ := leveldb.OpenFile(path, nil)

	num := 2406803 // 区块高度

	blockNumber := make([]byte, 8)
	binary.BigEndian.PutUint64(blockNumber, uint64(num))

	hashKey := append(headerPrefix, blockNumber...)
	hashKey = append(hashKey, numSuffix...)

	blockHash, _ := db.Get(hashKey, nil)

	headerKey := append(headerPrefix, blockNumber...)
	headerKey = append(headerKey, blockHash...)

	blockHeaderData, _ := db.Get(headerKey, nil)

	blockHeader := new(types.Header)

	tmpByteData := bytes.NewReader(blockHeaderData)
	rlp.Decode(tmpByteData, blockHeader)

	fmt.Printf("Height is %d \n", blockHeader.Number)
	fmt.Printf("blockHeader Hash is 0x%x \n", blockHeader.Hash())
	fmt.Printf("block stateRoot is 0x%x \n", blockHeader.Root)
	fmt.Print("\n")
	db.Close()

	stateRoot := blockHeader.Root
	diskdb, _ := ethdb.NewLDBDatabase(path, 16, 16)

	statedb := state.NewDatabase(diskdb)
	account, _ := state.New(stateRoot, statedb)

	balance := big.NewInt(0)
	if account != nil {
		balance = account.GetBalance(common.HexToAddress(address))
	}

	fmt.Printf("balance is %v \n", balance)

}


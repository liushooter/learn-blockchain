package main

import (
  "fmt"
	"encoding/hex"
	"github.com/ethereum/go-ethereum/crypto/sha3"
)

func main() {
	hash := sha3.NewKeccak256()

	var buf []byte
	hash.Write([]byte("Transfer(address,address,uint256)"))
	buf = hash.Sum(buf)

	fmt.Printf("0x%s \n", hex.EncodeToString(buf))
	// 0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef
}

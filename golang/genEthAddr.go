package main

import (
	"encoding/hex"
	"fmt"

	"github.com/ethereum/go-ethereum/crypto"
)

func main() {
	genEthAddr()
}

func genEthAddr() {
	key, _ := crypto.GenerateKey()

	privateKey := hex.EncodeToString(key.D.Bytes())
	address := crypto.PubkeyToAddress(key.PublicKey).Hex()

	fmt.Printf("privateKey: 0x%s\n", privateKey)
	fmt.Printf("addr: %s\n", address)
}

// GOOS=linux GOARCH=amd64 go build -o main main.go && zip main.zip main

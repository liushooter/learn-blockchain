package main

import (
	"context"
	"crypto/ecdsa"
	"encoding/hex"
	"fmt"
	"log"
	"math/big"

	"github.com/ethereum/go-ethereum/common"
	"github.com/ethereum/go-ethereum/core/types"
	"github.com/ethereum/go-ethereum/crypto"
	"github.com/ethereum/go-ethereum/ethclient"
	"github.com/ethereum/go-ethereum/rlp"
)

var (
	p         = fmt.Printf
	client, _ = ethclient.Dial("https://ropsten.infura.io")
)

func main() {

	privateKey, err := crypto.HexToECDSA("<私钥>")

	if err != nil {
		log.Fatal(err)
	}

	publicKey := privateKey.Public()

	publicKeyECDSA, ok := publicKey.(*ecdsa.PublicKey)
	if !ok {
		log.Fatal("err casting public key to ECDSA")
	}

	fromAddress := crypto.PubkeyToAddress(*publicKeyECDSA)
	p("fromAddr: %x\n", fromAddress)

	nonce, err := client.PendingNonceAt(context.Background(), fromAddress)
	if err != nil {
		log.Fatal(err)
	}

	value := big.NewInt(1000000000000000000 / 1000) // in wei (1 eth)
	gasLimit := uint64(21000)                       // in units
	gasPrice, err := client.SuggestGasPrice(context.Background())
	if err != nil {
		log.Fatal(err)
	}

	p("nonce: %s, gasPrice %s \n", nonce, gasPrice)

	toAddress := common.HexToAddress("<addr>")

	var data []byte
	tx := types.NewTransaction(nonce, toAddress, value, gasLimit, gasPrice, data)

	chainID, err := client.NetworkID(context.Background())
	if err != nil {
		log.Fatal(err)
	}

	signedTx, err := types.SignTx(tx, types.NewEIP155Signer(chainID), privateKey)
	if err != nil {
		log.Fatal(err)
	}

	ts := types.Transactions{signedTx}
	rawTx := hex.EncodeToString(ts.GetRlp(0))

	p("rawTx: %s\n", rawTx)

	broadcasting(rawTx)
}

func broadcasting(rawTx string) {

	var tx *types.Transaction

	rawTxBytes, err := hex.DecodeString(rawTx)
	rlp.DecodeBytes(rawTxBytes, &tx)

	err = client.SendTransaction(context.Background(), tx)
	if err != nil {
		log.Fatal(err)
	}

	tx_hash := tx.Hash().Hex()
	p("https://ropsten.etherscan.io/tx/%s\n", tx_hash)
}

// https://ethereum.stackexchange.com/a/59316

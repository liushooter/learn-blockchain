package main

import (
	"context"
	"fmt"
	"log"
	"time"

	"github.com/ethereum/go-ethereum/ethclient"
)

func main() {
	client, err := ethclient.Dial("/mnt/data/eth/geth.ipc")

	if err != nil {
		log.Fatal(err)
	}

	for {

		now := time.Now()
		header, err := client.HeaderByNumber(context.Background(), nil)
		if err != nil {
			log.Fatal(err)
		}

		fmt.Printf("Time: %s, Eth block height: %d \n", now.Format("2006-01-02 15:04:05"), header.Number) // 5671744
		time.Sleep(3 * time.Second)
	}

}

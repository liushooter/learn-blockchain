package main

import (
	"bytes"
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
)

func main() {
	//设置访问路由
	http.HandleFunc("/", getBlockNumber)
	http.HandleFunc("/balance", getBalance)

	//设置监听端口
	err := http.ListenAndServe(":3000", nil)

	if err != nil {
		log.Fatal("ListenAndserve:", err)
	}

}

func getBalance(w http.ResponseWriter, r *http.Request) {

	url := "https://mainnet.infura.io/"
	// url := "https://mainnet.infura.io/<key>" // key

	payload := "{\"method\": \"eth_getBalance\", \"params\": [\"0x5ea98a34990f4d8fe38907cf24601d4011c6ec63\", \"latest\"], \"id\": 0 }"

	var jsonStr = []byte(payload)

	req, err := http.NewRequest("POST", url, bytes.NewBuffer(jsonStr))
	req.Header.Set("Content-Type", "application/json")
	client := &http.Client{}
	resp, err := client.Do(req)

	if err != nil {
		panic(err)
	}

	defer resp.Body.Close()

	body, _ := ioutil.ReadAll(resp.Body)

	w.Header().Set("Content-Type", "application/json; charset=utf-8")
	fmt.Fprintf(w, string(body))
}

func getBlockNumber(w http.ResponseWriter, r *http.Request) {
	url := "https://api.infura.io/v1/jsonrpc/mainnet/eth_blockNumber"

	req, err := http.NewRequest("GET", url, nil)
	req.Header.Set("Content-Type", "application/json")

	client := &http.Client{}
	resp, err := client.Do(req)

	if err != nil {
		panic(err)
	}

	defer resp.Body.Close()

	fmt.Println("response Status:", resp.Status, "\n")
	fmt.Println("response Headers:", resp.Header, "\n")

	body, _ := ioutil.ReadAll(resp.Body)

	w.Header().Set("Access-Control-Allow-Origin", "*")
	w.Header().Set("Access-Control-Allow-Headers", "X-PINGOTHER, Content-Type")
	w.Header().Set("Access-Control-Allow-Methods", "POST, GET, PUT, DELETE, OPTIONS")

	w.Header().Set("Content-Type", "application/json; charset=utf-8")
	fmt.Fprintf(w, string(body))
}

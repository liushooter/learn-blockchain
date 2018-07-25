package main

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"math/big"
	"net/http"
	"strings"
)

type rpcData struct {
	Jsonrpc string `json:"jsonrpc"`
	ID      int    `json:"id"`
	Result  string `json:"result"`
}

func main() {

	url := "http://localhost:8545/"

	payload := strings.NewReader("{\"method\":\"eth_getBalance\",\"params\":[\"0x6cafe7473925998db07a497ac3fd10405637a46d\", \"latest\"],\"id\":0}")

	req, _ := http.NewRequest("POST", url, payload)

	req.Header.Add("content-type", "application/json")

	res, _ := http.DefaultClient.Do(req)

	defer res.Body.Close()
	body, _ := ioutil.ReadAll(res.Body)

	fmt.Println(string(body))

	var obj rpcData
	json.Unmarshal([]byte(body), &obj)

	balance := obj.Result // 0x29d669390feebf072 超过20位 是bigInt类型

	n := new(big.Int)

	n, err := n.SetString(balance[2:], 16)

	if !err {
		fmt.Println("SetString: error")
		return
	}

	fmt.Printf("balance 十六进制: %s, 十进制: %d \n", balance, n)

}

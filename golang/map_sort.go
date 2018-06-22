package main

import (
	"fmt"
	"sort"
)

var (
	tokens = map[string]string{
		"EOS": "0x86fa049857e0209aa7d9e616f7eb3b3b78ecfdb0",
		"TRX": "0xf230b790e05390fc8295f4d3f60332c93bed42e2",
		"VEN": "0xd850942ef8811f2a866692a623011bde52a462c1",
		"BNB": "0xB8c77482e45F1F44dE1745F52C74426C631bDD52",
		"OMG": "0xd26114cd6EE289AccF82350c8d8487fedB8A0C07",
		"ICX": "0xb5a5f22694352c15b00323844ad545abb2b11028",
		"ZIL": "0x05f4a42e251f2d52b8ed15e9fedaacfcef1fad27",
		"AE":  "0x5ca9a71b1d01849c0a95490cc00559717fcf0d1d",
		"ZRX": "0xe41d2489571d322189246dafa5ebde1f4699f498",
		"BTM": "0xcb97e65f07da24d46bcdd078ebebd7c6e6e3d750",
	}

	blog = map[int]string{
		0: "CPP",
		1: "python",
		2: "go",
		3: "javascript",
		4: "testing",
		5: "philosophy",
		6: "startups",
		7: "productivity",
		8: "DevOps",
		9: "rust",
	}
)

func main() {
	for key, value := range tokens { //range遍历map时 每次打印顺序不一样
		fmt.Printf("%s addr is %s\n", key, value)
	}

	fmt.Printf("----- random ----- \n")
	for k, v := range blog {
		fmt.Printf("%v: %v\n", k, v)
	}

	//now let's create & sort an array with our map keys
	sortedKeys := make([]int, 0, len(blog))

	for k := range blog {
		sortedKeys = append(sortedKeys, k)
	}
	sort.Ints(sortedKeys)

	fmt.Printf("\n----- sorted ----- \n")
	for k := range sortedKeys {
		fmt.Printf("%v : %v\n", k, blog[k])
	}
}

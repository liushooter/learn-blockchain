package main

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"net/http"
)

type Tickers []struct {
	// https://mholt.github.io/json-to-go/

	// [
	//     {
	//         "id": "bitcoin",
	//         "name": "Bitcoin",
	//         "symbol": "BTC",
	//         "rank": "1",
	//         "price_usd": "6877.96",
	//         "price_btc": "1.0",
	//         "24h_volume_usd": "4240800000.0",
	//         "market_cap_usd": "116711415444",
	//         "available_supply": "16968900.0",
	//         "total_supply": "16968900.0",
	//         "max_supply": "21000000.0",
	//         "percent_change_1h": "0.22",
	//         "percent_change_24h": "1.97",
	//         "percent_change_7d": "-4.49",
	//         "last_updated": "1523441074"
	//     }
	// ]
	ID               string `json:"id"`
	Name             string `json:"name"`
	Symbol           string `json:"symbol"`
	Rank             string `json:"rank"`
	PriceUsd         string `json:"price_usd"`
	PriceBtc         string `json:"price_btc"`
	Two4HVolumeUsd   string `json:"24h_volume_usd"`
	MarketCapUsd     string `json:"market_cap_usd"`
	AvailableSupply  string `json:"available_supply"`
	TotalSupply      string `json:"total_supply"`
	MaxSupply        string `json:"max_supply"`
	PercentChange1H  string `json:"percent_change_1h"`
	PercentChange24H string `json:"percent_change_24h"`
	PercentChange7D  string `json:"percent_change_7d"`
	LastUpdated      string `json:"last_updated"`
}

func main() {

	fetch()
}

func fetch() {
	url := "https://api.coinmarketcap.com/v1/ticker/bitcoin/"

	resp, err := http.Get(url)

	if err != nil {
		fmt.Sprint(err)
	}

	data, err := ioutil.ReadAll(resp.Body)
	resp.Body.Close()

	fmt.Printf(" %s \t\n", data)

	var ticker Tickers

	err = json.Unmarshal([]byte(data), &ticker)

	fmt.Printf(ticker[0].ID)
	fmt.Printf(ticker[0].Name)
	fmt.Printf(ticker[0].Symbol)
	fmt.Printf(ticker[0].Rank)
	fmt.Printf(ticker[0].PriceUsd)

}

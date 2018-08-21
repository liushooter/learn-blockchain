package main

import (
	"fmt"
	"io/ioutil"
	"net/http"

	"github.com/tidwall/gjson"
)

func main() {

	/**
		{
			"disclaimer": "Usage subject to terms: https://openexchangerates.org/terms",
		    "license": "https://openexchangerates.org/license",
		    "timestamp": 1523400000,
		    "base": "USD",
		    "rates": {
		        "CNH": 6.833781,
		        "CNY": 6.8411,
				"EUR": 0.868466,
				"BTC": 0.000154657661
		    }
		}
	**/

	url := "https://openexchangerates.org/api/latest.json"

	req, _ := http.NewRequest("GET", url, nil)

	res, _ := http.DefaultClient.Do(req)

	defer res.Body.Close()
	body, _ := ioutil.ReadAll(res.Body)
	result := gjson.Get(string(body), "rates")

	result.ForEach(func(key, value gjson.Result) bool {
		fmt.Printf("%s: %s\n", key, value.String())
		return true // keep iterating
	})

}

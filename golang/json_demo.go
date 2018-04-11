package main

import (
	"encoding/json"
	"fmt"
)

type Account struct {
	Email    string  `json:"email"`
	Password string  `json:"password"`
	Money    float64 `json:"money"`
}

var jsonString string = `{
    "email":"rsj217@gmail.com",
    "password":"123",
    "money":100.5
}`

func main() {

	account := Account{}

	err := json.Unmarshal([]byte(jsonString), &account)
	if err != nil {
	}

	fmt.Printf("%+v\n", account)
}

// https://www.jianshu.com/p/31757e530144

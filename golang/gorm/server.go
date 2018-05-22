package main

import (
	"fmt"
	"github.com/gorilla/mux"
	"github.com/jinzhu/gorm"
	_ "github.com/lib/pq"
	"log"
	"model"
	"net/http"
	"time"
)

const (
	host     = "localhost"
	port     = 5432
	user     = "postgres"
	password = "postgres"
	dbname   = "eth"
)

var (
	db *gorm.DB
)

func main() {
	// setup the DB connection
	psqlInfo := fmt.Sprintf("host=%s port=%d user=%s "+
		"password=%s dbname=%s sslmode=disable",
		host, port, user, password, dbname)

	var err error
	db, err = gorm.Open("postgres", psqlInfo)

	if err != nil {
		panic(err)
	}

	defer db.Close()

	if err != nil {
		panic(err)
	}

	r := mux.NewRouter()
	r.Handle("/", http.RedirectHandler("/signin", http.StatusFound))
	r.HandleFunc("/signin", showSignin).Methods("GET")
	log.Fatal(http.ListenAndServe(":3000", r))
}

func createBlock() {
	now := time.Now()

	dbBlock := model.dbBlock{
		ID:         1,
		Height:     11,
		Timestamp:  int(now.Unix()),
		TxsNum:     23,
		Hash:       "0x8643348f0eeda372b3a53aa768c50c439ec6d99e4eccfd472bad03a2e20dbb51",
		ParentHash: "",
		UncleHash:  "",
		Coinbase:   "0xb2930B35844a230f00E51431aCAe96Fe543a0347",
		Difficulty: 975441,
		Size:       26,
		GasUsed:    315,
		GasLimit:   528,
		Nonce:      1329306,
		Reward:     7812,
		ExtraData:  "zqw",
		CreatedAt:  now,
		UpdatedAt:  now,
	}

	db.Create(&dbBlock)
}

func showSignin(w http.ResponseWriter, r *http.Request) {
	html := `
		<!DOCTYPE html>
		<html lang="en">
		<form action="/signin" method="POST">
			<label for="email">Email Address</label>
			<input type="email" id="email" name="email" placeholder="you@example.com">

			<label for="password">Password</label>
			<input type="password" id="password" name="password" placeholder="something-secret">

			<button type="submit">Sign in</button>
		</form>
		</html>`

	createBlock()
	fmt.Fprint(w, html)
}

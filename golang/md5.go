package main

import (
	"crypto/md5"
	"fmt"
	"io"
	"time"
)

func main() {
	p := fmt.Printf
	t := time.Now()
	text := t.Format("2006-01-02 15:04:00")
	p("%s\n", t.Format("2006-01-02 15:04:05"))
	p("%s\n", text)

	h := md5.New()
	io.WriteString(h, text)
	fmt.Printf("%x\n", h.Sum(nil))

	h2 := md5.New()
	h2.Write([]byte(text))
	fmt.Printf("%x\n", h2.Sum(nil))
}

// echo -n "2018-09-25 12:51:00" | md5
// echo 默认在末尾加上 "\n", echo -n 不会在加 \n了
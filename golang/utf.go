package main

import "fmt"
import "unicode/utf8"

func main() {
	char := "♥"

	fmt.Println(len(char)) // 3
	fmt.Println(utf8.RuneCountInString(char))
}

// https://github.com/wuYin/blog/blob/master/50-shades-of-golang-traps-gotchas-mistakes.md

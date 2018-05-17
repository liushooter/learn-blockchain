package main

import (
	"fmt"
	"sync"
)

func main() {
	var wg sync.WaitGroup
	for i := 0; i < 100; i++ {
		wg.Add(1)
	}

	for i := 0; i < 100; i++ {
		go wg.Done()
	}

	fmt.Println("exit")
	wg.Wait()
}

func add(wg sync.WaitGroup) {
	wg.Add(1)
}

func done(wg sync.WaitGroup) {
	wg.Done()
}

// http://www.cnblogs.com/getong/archive/2013/03/29/2988816.html

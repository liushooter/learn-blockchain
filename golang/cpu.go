package main

import (
	"fmt"
	"runtime"
	"sync"
)

func main() {
	num := runtime.NumCPU()
	runtime.GOMAXPROCS(num) //给每个cpu分配一个逻辑处理器
	fmt.Printf("cpu: %d\n", num)

	var wg sync.WaitGroup // wg用来等待程序完成
	wg.Add(2)             //计数加2 表示要等待2个goroutines

	fmt.Print("Start Goroutines \n")

	go func() { //创建一个 goroutines
		defer wg.Done()
		for i := 0; i < 3; i++ {
			for char := 'a'; char < 'a'+26; char++ {
				fmt.Printf("%c ", char)
			}
		}
	}() //匿名函数

	go func() { //创建一个 goroutines
		defer wg.Done()
		for i := 0; i < 3; i++ {
			for char := 'A'; char < 'A'+26; char++ {
				fmt.Printf("%c ", char)
			}
		}
	}() //匿名函数

	fmt.Printf("Wating To Finish \n")

	wg.Wait()

	fmt.Printf("\nTerminating Program")
}

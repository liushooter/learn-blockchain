package main

import "fmt"
import "time"

func main() {
	time1 := "2015-03-20 00:05:00"
	time2 := "2015-03-20 00:10:00"

	t1, _ := time.Parse("2006-01-02 15:04:05", time1)
	t2, _ := time.Parse("2006-01-02 15:04:05", time2)

	fmt.Println(t1.After(t2))

	fmt.Println(t1.Add(10 * time.Minute).Before(t2))

}

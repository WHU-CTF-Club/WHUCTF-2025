package main

import (
	"fmt"
	"os"
)

func main() {
	res, _ := os.ReadFile("/flag.txt")
	fmt.Print(string(res))
}

package main

import (
	"fmt"
	"os"
)

func main() {
	res, _ := os.ReadFile("/flag")
	fmt.Println("You become the legendary Dragon Slayer Knight, but you know that true victory isn't just about defeating the dragon, it's about overcoming your inner fear and doubt. Your name will be remembered forever, and your story will inspire countless followers to embark on their journey....");
	fmt.Print(string(res))
}

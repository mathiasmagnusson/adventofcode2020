package main

import (
	"bufio"
	"fmt"
	"os"
)

func main() {
	file, err := os.Open("in")
	if err != nil {
		fmt.Println(err)
		return
	}
	stdin := bufio.NewReader(file)

	var total int

outer:
	for true {
		yeses := make(map[rune]bool)
		for true {
			line, err := stdin.ReadString('\n')
			if err != nil {
				total += len(yeses)
				break outer
			}
			if line == "\n" {
				break
			}

			for _, char := range line {
				if 'a' <= char && char <= 'z' {
					yeses[char] = true
				}
			}
		}
		total += len(yeses)
	}

	fmt.Println(total)
}

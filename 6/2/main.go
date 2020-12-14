package main

import (
	"bufio"
	"fmt"
	"os"
	"strings"
)

const alphabet string = "abcdefghijklmnopqrstuvwxyz"

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
		for _, char := range alphabet {
			yeses[char] = true;
		}
		for true {
			line, err := stdin.ReadString('\n')
			if err != nil {
				for _, found := range yeses {
					if found {
						total += 1
					}
				}
				break outer
			}
			if line == "\n" {
				break
			}


			for _, char := range alphabet {
				if !strings.ContainsRune(line, char) {
					yeses[char] = false
				}
			}
		}
		for _, found := range yeses {
			if found {
				total += 1
			}
		}
	}

	fmt.Println(total)
}

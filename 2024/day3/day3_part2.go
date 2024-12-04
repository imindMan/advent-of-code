package main

import (
	"fmt"
	"os"
	"regexp"
	"strconv"
	"strings"
)

func main() {
	data, _ := os.ReadFile("day3.txt")

	r, _ := regexp.Compile(`mul\(\d+,\d+\)|don't\(\)|do\(\)`)
	commands := r.FindAllString(string(data), -1)

	sum := 0

	do := true

	for _, i := range commands {
		if i == "don't()" {
			do = false
			continue
		}
		if i == "do()" {
			do = true
			continue
		}
		if !do {
			continue
		}

		first, _ := strconv.Atoi(strings.Split(i, ",")[0][4:])
		secondstr := strings.Split(i, ",")[1]
		second, _ := strconv.Atoi(secondstr[:len(secondstr)-1])

		sum += first * second
	}

	fmt.Println(sum)
}

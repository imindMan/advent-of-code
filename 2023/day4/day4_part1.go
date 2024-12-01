package main

import (
    "bufio"
    "fmt"
    "log"
    "os"
    "strings"
    "strconv"
    "math"
)


func main() {
    file, err := os.Open("day4.txt")
    if err != nil {
        log.Fatal(err)
    }
    defer file.Close()

    sum := 0
    scanner := bufio.NewScanner(file)
    // optionally, resize scanner's capacity for lines over 64K, see next example
    for scanner.Scan() {
        value := parseLine(scanner.Text())
        sum += value 
    }
    fmt.Println(sum)
    if err := scanner.Err(); err != nil {
        log.Fatal(err)
    }
}

func itemExists(array []int, element_to_check int) bool {
    for i := 0; i < len(array); i++ {
		if array[i] == element_to_check {
			return true
		}
	}

	return false
}

// This is just basically parsing every single line and usng that data to return the value
func parseLine(data string) int {
    winning_scratchcard_string := strings.Split(strings.Split(data[10:len(data)], "|")[0], " ")
    scratchcard_string := strings.Split(strings.Split(data[10:len(data)], "|")[1], " ")
    var winning_scratchcard = []int{}
    for _, i := range winning_scratchcard_string {
        if len(i) != 0 {
            j, err := strconv.Atoi(i)
            if err != nil {
                panic(err)
            }
            winning_scratchcard = append(winning_scratchcard, j)
        }
    }
    
    var scratchcard = []int{}
    for _, i := range scratchcard_string {
        if len(i) != 0 {
            j, err := strconv.Atoi(i)
            if err != nil {
                panic(err)
            }
            scratchcard = append(scratchcard, j)
        }
    }

    sum := 0
    times := 0
    for i := 0; i < len(scratchcard); i++ {
        if itemExists(winning_scratchcard, scratchcard[i]) {
            if times == 0 {
                sum = 1
                
            } else {
                sum += int(math.Pow(2, float64(times - 1)))
            }
            times += 1
        }
    }
    return sum 

}


package main

import (
    "bufio"
    "fmt"
    "log"
    "os"
    "strings"
    "strconv"
)

const CHECKPOINT = 10;

func main() {
    file, err := os.Open("day4.txt")
    if err != nil {
        log.Fatal(err)
    }
    defer file.Close()

    scanner := bufio.NewScanner(file)
    // optionally, resize scanner's capacity for lines over 64K, see next example
    
    var arr [][]int;
    for scanner.Scan() {
        arr = append(arr, convertLineToArray(scanner.Text()))
    }
    
    sum := 0;
    for i := 0; i < len(arr); i++ {
        sum += counterCopies(arr[i], arr)
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

func counterCopies(scratchcard []int, data [][]int) (gain_copies int) {
    id := scratchcard[0]
    winning_scratchcards := scratchcard[1:CHECKPOINT + 1]
    scratchcard_to_check := scratchcard[CHECKPOINT + 1:len(scratchcard)]

    counter_check := validateArray(winning_scratchcards, scratchcard_to_check)
    gain_copies++
    if counter_check == 0 {
        return gain_copies;
    } else {
        for i := id; i < id + counter_check; i++ {
            gain_copies += counterCopies(data[i], data)
        }
    }
    return gain_copies;

}

func validateArray(winning_scratchcards []int, scratchcards []int) (counter int) {
    for i := 0; i < len(scratchcards); i++ {
        if itemExists(winning_scratchcards, scratchcards[i]) {
            counter++;
        } 
    }

    return counter;
}


func convertLineToArray(data string) (general_array []int){

    id := strings.Split(data[0:8], " "); 
    winning_scratchcard_string := strings.Split(strings.Split(data[10:len(data)], "|")[0], " ")
    scratchcard_string := strings.Split(strings.Split(data[10:len(data)], "|")[1], " ")
    
    id_num, err := strconv.Atoi(strings.Trim(id[len(id) - 1], " "))
    if err != nil {
        panic(err)
    }
    general_array = append(general_array, id_num)

    // convert everything to integer arrays
    for _, i := range winning_scratchcard_string {
        if len(i) != 0 {
            j, err := strconv.Atoi(i)
            if err != nil {
                panic(err)
            }
            general_array = append(general_array, j)
        }
    }
    
    for _, i := range scratchcard_string {
        if len(i) != 0 {
            j, err := strconv.Atoi(i)
            if err != nil {
                panic(err)
            }
            general_array = append(general_array, j)
        }
    }

    return general_array 
}


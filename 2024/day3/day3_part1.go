package main 

import (
    "fmt"
    "log"
    "os"
    "bufio"
    "regexp"
    "strconv"
)

func main() {
    file, err := os.Open("day3.txt")
    if err != nil {
        log.Fatal(err)
    }
    defer file.Close()

    scanner := bufio.NewScanner(file)
    sum := 0;
    for scanner.Scan() {
        value := scanner.Text();
        r, _ := regexp.Compile(`mul\(\d+,\d+\)`)
        for _, i := range r.FindAllString(value, -1) {
            d := regexp.MustCompile(`\d+`)
            u := d.FindAllString(i, -1);
            f, _ := strconv.Atoi(u[0]);
            s, _ := strconv.Atoi(u[1]);
            sum += f * s;

        }
    }
    fmt.Println(sum);
    if err := scanner.Err(); err != nil {
        log.Fatal(err)
    }
}


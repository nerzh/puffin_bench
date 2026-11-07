package main

import (
	"fmt"
	"os"
	"strconv"
	"strings"
	"time"
)

func argument(index int, fallback int) int {
	if len(os.Args) <= index {
		return fallback
	}
	value, err := strconv.Atoi(os.Args[index])
	if err != nil || value < 0 || value > 2147483647 {
		panic("Invalid count")
	}
	return value
}
func check(err error) {
	if err != nil {
		panic(err)
	}
}
func run(iterations int) int {
	const template = "test_text\n"
	var result strings.Builder
	count := 0
	for count < iterations {
		result.WriteString(template)
		count = count + 1
	}
	file, err := os.Create("./store/go.txt")
	check(err)
	_, err = file.WriteString(result.String())
	closeErr := file.Close()
	check(err)
	check(closeErr)
	return result.Len()
}
func main() {
	if len(os.Args) > 3 {
		panic("lines [warmup_lines]")
	}
	iterations := argument(1, 80000000)
	warmup := argument(2, 10000)
	warmupBytes := run(warmup)
	start := time.Now()
	size := run(iterations)
	elapsed := time.Since(start).Nanoseconds()
	fmt.Printf("elapsed_ns=%d bytes=%d warmup_bytes=%d\n", elapsed, size, warmupBytes)
}

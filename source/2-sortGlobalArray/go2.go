package main

import (
	"fmt"
	"os"
	"strconv"
	"time"
)

func argument(index int, fallback int64) int64 {
	if len(os.Args) <= index {
		return fallback
	}
	value, err := strconv.ParseInt(os.Args[index], 10, 64)
	if err != nil || value < 0 || value > 2147483647 {
		panic("Arguments must be in 0..2147483647")
	}
	return value
}

type Sorter struct{ arr []int64 }

func (s *Sorter) shellsSort() {
	gap := len(s.arr) / 2
	for gap > 0 {
		i := gap
		for i < len(s.arr) {
			temp := s.arr[i]
			j := i
			for j >= gap && s.arr[j-gap] > temp {
				s.arr[j] = s.arr[j-gap]
				j = j - gap
			}
			s.arr[j] = temp
			i = i + 1
		}
		gap = gap / 2
	}
}
func (s *Sorter) run(iterations, seed int64) int64 {
	state := seed
	var checksum int64
	c := int64(0)
	for c < iterations {
		k := 0
		for k < len(s.arr) {
			state = (state*1664525 + 1013904223) & 2147483647
			s.arr[k] = (state >> 8) & 65535
			k = k + 1
		}
		s.shellsSort()
		k = 0
		for k < len(s.arr) {
			checksum = (checksum*31 + s.arr[k]) & 2147483647
			k = k + 1
		}
		c = c + 1
	}
	return checksum
}
func main() {
	if len(os.Args) < 2 || len(os.Args) > 4 {
		panic("iterations [seed [warmup]]")
	}
	iterations := argument(1, 0)
	seed := argument(2, 12345)
	warmup := argument(3, 10000)
	s := Sorter{arr: make([]int64, 100)}
	warmupChecksum := s.run(warmup, seed)
	start := time.Now()
	checksum := s.run(iterations, seed)
	elapsed := time.Since(start).Nanoseconds()
	fmt.Printf("elapsed_ns=%d checksum=%d warmup_checksum=%d\n", elapsed, checksum, warmupChecksum)
}

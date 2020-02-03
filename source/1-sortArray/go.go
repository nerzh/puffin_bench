package main

import (
	"fmt"
	"os"
	"os/exec"
	"strconv"
)

func shellsSort(arr []int64) {
	var n int64 = int64(len(arr))
	var gap int64 = n / 2
	var i int64 = 0
	var j int64 = 0
	var temp int64 = 0

	for gap > 0 {
		i = gap
		for i < n {
			temp = arr[i]
			j = i
			for j >= gap && arr[j-gap] > temp {
				arr[j] = arr[j-gap]
				j = j - gap
			}
			arr[j] = temp
			i = i + 1
		}
		gap = gap / 2
	}
}

func goVersion() {
	output, err := exec.Command("go", "version").CombinedOutput()
	if err != nil {
		os.Stderr.WriteString(err.Error())
	}
	fmt.Println(string(output))
}

func main() {
	var c int64 = 0
	var c2 int64 = 0
	var iterationCount int64 = 0
	arr := [10]int64{0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
	if len(os.Args) > 1 {
		i, err := strconv.ParseInt(os.Args[1], 10, 64)
		if err != nil {
			os.Stderr.WriteString(err.Error())
		} else {
			iterationCount = i
		}
	}

	for c < iterationCount {
		for c2 < 10 {
			arr[c2] = 9 - c2
			c2 = c2 + 1
		}
		shellsSort(arr[:])
		c = c + 1
		c2 = 0
	}

	goVersion()
}

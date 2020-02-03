package main

import (
	"bytes"
	"fmt"
	"os"
	"os/exec"
)

func check(e error) {
	if e != nil {
		panic(e)
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

	count := 0
	path := "./store"
	fileName := "go.txt"
	templateString := "test_text\n"
	var resultString bytes.Buffer

	for count < 8000000 {
		resultString.WriteString(templateString)
		count = count + 1
	}

	if _, err := os.Stat(path); os.IsNotExist(err) {
		err := os.MkdirAll(path, os.ModePerm)
		check(err)
	}

	fo, err := os.Create(path + "/" + fileName)
	check(err)

	defer func() {
		err := fo.Close()
		check(err)
	}()
	length, err := fo.WriteString(resultString.String())
	check(err)
	fmt.Println(length, "bytes written successfully")

	goVersion()

}

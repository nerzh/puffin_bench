package main

import (
    // "bufio"
    "fmt"
    "io/ioutil"
    "os"
    "os/exec"
    "bytes"
)

func check(e error) {
    if e != nil {
        panic(e)
    }
}

func go_version() {
    output, err := exec.Command("go", "version").CombinedOutput()
    if err != nil {
        os.Stderr.WriteString(err.Error())
    }
    fmt.Println(string(output))
}

func main() {

    count             := 0
    path              := "./store/go.txt"
    template_string   := "test_text\n"
    // var result_string []string
    var result_string bytes.Buffer

    for count < 8000000 {
        // var strs []string
        // result_string = append(result_string, template_string)
        result_string.WriteString(template_string)
        count = count + 1;
    }

    // d1 := []byte(result_string)
    // err := ioutil.WriteFile(path, d1, 0775)
    // err := ioutil.WriteFile(path, []byte(result_string), 0775)
    // err := ioutil.WriteFile(path, result_string, 0775)
    // check(err)

    fo, err := os.Create(path)
    if err != nil {
        panic(err)
    }
    defer func() {
        if err := fo.Close(); err != nil {
            panic(err)
        }
    }()

    if _, err := fo.Write(result_string); err != nil {
        panic(err)
    }

    // f, err := os.Create("/tmp/dat2")
    // check(err)

    // w := bufio.NewWriter(f)
    // n4, err := w.WriteString(result_string)
    // fmt.Printf("wrote %d bytes\n", n4)

    // w.Flush()

    go_version()

}

package main
import "fmt"
import "os"
import "os/exec"

func shellsSort(arr [10]int) [10]int {
    n    := len(arr)
    gap  := n/2
    i    := 0
    j    := 0
    temp := 0
    
    for gap > 0 {
        i = gap
        for i < n {
            temp = arr[i]
            j = i
            for (j >= gap && arr[j - gap] > temp) {
                arr[j] = arr[j - gap]
                j = j - gap
            }
            arr[j] = temp
            i = i + 1
        }
        gap = gap/2
    }
    return arr
}

func pr(arr []int){
    for i := 0; i < len(arr); i++ {
        fmt.Println(arr[i])
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
    c   := 0
    arr := [10]int{0,0,0,0,0,0,0,0,0,0}

    for c < 15000000 {
        for i := 0; i < 10; i++ {
          arr[i] = 9 - i
        }
        shellsSort(arr)
        // shellsSort(&arr)
        // pr(arr)
        c++
    }

    go_version()
    fmt.Println("GO")
}
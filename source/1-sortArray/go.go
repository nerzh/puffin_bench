package main
import "fmt"
import "os"
import "os/exec"
import "strconv"

func shellsSort(arr [10]int64) {
    var n    int64 = int64(len(arr))
    var gap  int64 = n/2
    var i    int64 = 0
    var j    int64 = 0
    var temp int64 = 0
    
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
}

func pr(arr []int64){
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
    var c  int64 = 0
    var c2 int64 = 0
    arr         := [10]int64{0,0,0,0,0,0,0,0,0,0}
    i, err      := strconv.ParseInt(os.Args[1], 10, 64)
    if err != nil { os.Stderr.WriteString(err.Error()) }
    for c < i {
        for c2 < 10 {
            arr[c2] = 9 - c2
            c2 = c2 + 1
        }
        shellsSort(arr)
        // pr(arr)
        c  = c + 1
        c2 = 0
    }

    go_version()
    fmt.Println("GO")
}
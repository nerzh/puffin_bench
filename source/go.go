package main
import "fmt"

func shellsSort(arr []int) []int {
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

func main() {
    c := 0
    for c < 10000000 {
        arr := []int{9,8,7,6,5,4,3,2,1,0}
        // shellsSort(&arr)
        shellsSort(arr)
        // pr(arr)
        c++
    }

    fmt.Println("GO")
}
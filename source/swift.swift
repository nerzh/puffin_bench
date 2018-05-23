#!/usr/bin/env swift

func shellsSort<T : Comparable>(_ arr: inout [T]) {
    let n = arr.count
    var gap = n/2
    var i  = 0
    var j  = 0
    var temp : T
    
    while gap > 0 {
        i = gap
        while i < n {
            temp = arr[i]
            j = i
            while (j >= gap && arr[j - gap] > temp) {
                arr[j] = arr[j - gap]
                j = j - gap
            }
            arr[j] = temp
            i = i + 1
        }
        gap = gap/2
    }
}

var a = [9, 8, 7, 6, 5, 4, 3, 2, 1, 0]
var c = 0

while (c < 10000000) {
    shellsSort(&a)
    a = [9, 8, 7, 6, 5, 4, 3, 2, 1, 0]
    c = c + 1
}

print("Swift")

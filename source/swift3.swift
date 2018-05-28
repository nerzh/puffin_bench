#!/usr/bin/env swift

// import Foundation

func shellsSort<T : Comparable>(_ arr: inout [T]) {
    let n    : Int = arr.count
    var gap  : Int = n/2
    var i    : Int = 0
    var j    : Int = 0
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

func evenHundred(_ x: Int) -> Bool {
    return (((x - x%10) % 100)/10)%2 == 0 
}

func arc4random_uniform2(_ x: Int32) -> Int {
    // return Int(arc4random_uniform2(x))
    return 5
}

var a : [Int] = [9, 8, 7, 6, 5, 4, 3, 2, 1, 0]
var c : Int   = 0

while (c < 15000000) {
    shellsSort(&a)
    a = [9, 8, 7, 6, 5, 4, 3, 2, 1, 0]
    if evenHundred(c) {
        a.insert(c, at: arc4random_uniform2(9))
    } else {
        a.remove(at: arc4random_uniform2(9))
    }
    c = c + 1
}

print("Swift with remove and insert to middle of array and even % 2")

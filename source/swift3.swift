#!/usr/bin/env swift

import Foundation

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

func arc4random_uniform2(_ x: UInt32) -> Int {
    return Int(arc4random_uniform(x))
    // return 5
}

func makeRandomArray(_ x: Int) -> [Int] {
    var arr : [Int] = [Int]()
    var c   : Int   = 0
    while (c < x) {
        arr.append(arc4random_uniform2(9))
        c = c + 1
    }
    return arr
}

func revertArray<T>(_ a: inout [T]) {
    var c : Int = 0
    let l : Int = a.count
    var t : T
    while (c <= l/2) {
        t            = a[c]
        a[c]         = a[(l-1) - c]
        a[(l-1) - c] = t
        c            = c + 1
    }
}

func iterateArray<T>(_ a: inout [T]) {
    var c = 0
    let l = a.count
    while (c < l) {
        a.append(a.remove(at: 0))
        c = c + 1
    }
}

func clearFile(_ path: String) {
    do {
        try "".write(to: URL(fileURLWithPath: path), atomically: true, encoding: String.Encoding.utf8)
    } catch {
        print("FAIL")
    }
}

func writeString(_ path: String, _ text: String) {
    do {
        let fileHandle = try FileHandle(forWritingTo: URL(fileURLWithPath: path))
            fileHandle.seekToEndOfFile()
            fileHandle.write(text.data(using: .utf8)!)
            fileHandle.closeFile()
    } catch {
        print("FAIL")
    }
}


// var a : [Int] = [9, 8, 7, 6, 5, 4, 3, 2, 1, 0]
var a : [Int]  = makeRandomArray(10)
var c : Int    = 0
var p : String = "./store/swift.txt"
clearFile(p)

// while (c < 2000000) {
while (c < 20000) {
    shellsSort(&a)
    writeString(p, "\(a)\n")
    // a = makeRandomArray(10)
    revertArray(&a)
    writeString(p, "\(a)\n")
    // a = makeRandomArray(10)
    iterateArray(&a)
    writeString(p, "\(a)\n")

    if evenHundred(c) {
        a.insert(c, at: arc4random_uniform2(9))
    } else {
        a.remove(at: arc4random_uniform2(9))
    }
    c = c + 1
}

// @discardableResult
// func shell(_ args: [String]) -> Int32 {
func shell(_ args: [String]) {
    let task = Process()
    task.launchPath = "/usr/bin/env"
    task.arguments = args
    task.launch()
    // task.waitUntilExit()
    // return task.terminationStatus
    // return 1
}

shell(["bash", "-lc", "swift --version | grep version"])
print("Swift with remove and insert to array and write to file")

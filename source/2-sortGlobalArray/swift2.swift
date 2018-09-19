#!/usr/bin/env swift

import Foundation

class TestGlobalArr {
  var arr : [Int] = [9, 8, 7, 6, 5, 4, 3, 2, 1, 0]

  func shellsSort() {
    let n    : Int = arr.count
    var gap  : Int = n/2
    var i    : Int = 0
    var j    : Int = 0
    var temp : Int
    
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

  func main() {
    var c : Int = 0

    while (c < 15000000) {
        shellsSort()
        arr = [9, 8, 7, 6, 5, 4, 3, 2, 1, 0]
        c = c + 1
    }
  }
}

TestGlobalArr().main()

// print version
// @discardableResult
// func shell(_ args: [String]) -> Int32 {
func shell(_ args: [String]) {
    let task = Process()
    task.launchPath = "/usr/bin/env"
    task.arguments = args
    task.launch()
    // task.waitUntilExit()
    // return task.terminationStatus
}
shell(["bash", "-lc", "swift --version | grep version"])
print("Swift sort global array")
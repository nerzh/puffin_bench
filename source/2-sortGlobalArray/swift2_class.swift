#!/usr/bin/env swift

import Foundation

// PAYLOAD
class TestGlobalArr {
  var arr : [Int] = Array<Int>.init(repeating: 0, count: 10)

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
        for i in 0..<10 {
            arr[i] = 9 - i
        }
        shellsSort()
        c = c + 1
    }
  }
}

// TEST
TestGlobalArr().main()



// PRINT SWIFT VERSION
func shell(_ args: [String]) {
    let task = Process()
    task.arguments = args
    
    #if swift(>=5)
    task.executableURL = URL.init(fileURLWithPath: "/usr/bin/env")
    try? task.run()
    #else
    task.launchPath = "/usr/bin/env"
    task.launch()
    #endif
}
shell(["bash", "-lc", "swift --version | grep version"])
print("Swift sort global array. CLASS CALL")

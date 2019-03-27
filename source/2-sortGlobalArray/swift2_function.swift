#!/usr/bin/env swift

import Foundation

// PAYLOAD
func payload() {
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
    var c  : Int = 0
    var c2 : Int = 0
    let i  : Int   = Int(CommandLine.arguments[1])!

    while (c < i) {
        while (c2 < 10) {
            arr[c2] = 9 - c2
            c2 = c2 + 1
        }
        shellsSort()
        c  = c + 1
        c2 = 0
    }
  }

  main()
}

// TEST
payload()



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

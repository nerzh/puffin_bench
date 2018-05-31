#!/usr/bin/env swift

import Foundation

func clearFile(_ path: String) {
    do {
        try "".write(to: URL(fileURLWithPath: path), atomically: true, encoding: String.Encoding.utf8)
    } catch {
        print("FAIL")
    }
}

var count          : Int    = 0
var path           : String = "./store/swift.txt"
let templateString : String = "test_text\n"
var resultString   : String = ""
clearFile(path)

let fileHandl = try! FileHandle(forWritingTo: URL(fileURLWithPath: path))

while (count < 8000000) {
    resultString.append(templateString)
    count += 1
}
// fileHandl.seekToEndOfFile()
fileHandl.write(resultString.data(using: .utf8)!)
fileHandl.closeFile()

// print version
func shell(_ args: [String]) {
    let task = Process()
    task.launchPath = "/usr/bin/env"
    task.arguments = args
    task.launch()
}
shell(["bash", "-lc", "swift --version | grep version"])
print("Swift write to file")

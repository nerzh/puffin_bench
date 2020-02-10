#!/usr/bin/env swift

import Foundation

// PAYLOAD
func main() {
    var count          : Int         = 0
    let path           : String      = "./store/swift.txt"
    let templateString : String      = "test_text\n"
    var resultString   : String      = ""
    let fileManager    : FileManager = FileManager.default

    while (count < 8000000) {
        resultString.append(templateString)
        count += 1
    }

    if !fileManager.fileExists(atPath: path) {
      fileManager.createFile(atPath: path, contents: nil, attributes: nil) 
    }
    let fileHandl : FileHandle = try! FileHandle(forWritingTo: URL(fileURLWithPath: path))
    fileHandl.write(resultString.data(using: .utf8)!)
    fileHandl.closeFile()
}

// TEST
main()


// PRINT VERSION
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
//shell(["bash", "-lc", "swift --version | grep version"])

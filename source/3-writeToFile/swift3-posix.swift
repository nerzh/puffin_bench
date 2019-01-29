#!/usr/bin/env swift

import Foundation

func main() {
    var count          : Int    = 0
    let path           : String = "./store/swift.txt"
    let templateString : String = "test_text\n"
    var resultString   : String = ""

    let fileDescriptor = open(path, O_TRUNC | O_WRONLY | O_CREAT, 0o755)

    while (count < 8000000) {
        resultString.append(templateString)
        count += 1
    }

    if fileDescriptor < 0 {
        perror("could not open \(path)")
    } else {
        write(fileDescriptor, resultString, resultString.count)
        close(fileDescriptor)
    }
}

main()

// print version
func shell(_ args: [String]) {
    let task = Process()
    task.arguments = args
    
    #if swift(<5)
    task.launchPath = "/usr/bin/env"
    task.launch()
    #else
    task.executableURL = URL.init(fileURLWithPath: "/usr/bin/env")
    try? task.run()
    #endif
}
shell(["bash", "-lc", "swift --version | grep version"])
print("Swift POSIX write to file")

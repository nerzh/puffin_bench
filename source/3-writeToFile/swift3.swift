#if canImport(Darwin)
import Darwin
#else
import Glibc
#endif

func argument(_ index: Int, _ fallback: Int) -> Int {
    if CommandLine.arguments.count <= index { return fallback }
    guard let value = Int(CommandLine.arguments[index]), value >= 0, value <= 2147483647 else {
        fatalError("Arguments must be integers in 0...2147483647")
    }
    return value
}
func nowNS() -> Int64 {
    var value = timespec()
    guard clock_gettime(CLOCK_MONOTONIC, &value) == 0 else { fatalError("clock_gettime failed") }
    return Int64(value.tv_sec) * 1_000_000_000 + Int64(value.tv_nsec)
}

import Foundation

func run(_ iterations: Int) -> Int {
    let template = "test_text\n"
    var result = ""
    var count = 0
    while count < iterations {
        result.append(template)
        count = count + 1
    }
    let path = "./store/swift.txt"
    if !FileManager.default.fileExists(atPath: path) {
        guard FileManager.default.createFile(atPath: path, contents: nil) else { fatalError("createFile failed") }
    }
    let file = try! FileHandle(forWritingTo: URL(fileURLWithPath: path))
    try! file.truncate(atOffset: 0)
    try! file.write(contentsOf: Data(result.utf8))
    try! file.close()
    return result.utf8.count
}
func main() {
    guard CommandLine.arguments.count <= 3 else { fatalError("lines [warmup_lines]") }
    let iterations = argument(1, 80000000)
    let warmup = argument(2, 10000)
    let warmupBytes = run(warmup)
    let start = nowNS()
    let bytes = run(iterations)
    let elapsed = nowNS() - start
    print("elapsed_ns=\(elapsed) bytes=\(bytes) warmup_bytes=\(warmupBytes)")
}
main()

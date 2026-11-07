#if canImport(Darwin)
import Darwin
#else
import Glibc
#endif
import Foundation

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

func run(_ iterations: Int) -> Int {
    let template: StaticString = "test_text\n"
    let bufferType = UnsafeMutableBufferPointer<UInt8>.self
    var result = bufferType.init(start: nil, count: 0)
    var size = 0
    defer { result.deallocate() }

    template.withUTF8Buffer { bytes in
        var count = 0
        while count < iterations {
            let required = size + bytes.count
            if required > result.count {
                let doubled = result.count <= Int.max / 2 ? result.count * 2 : required
                let next = max(required, max(64, doubled))
                let grown = bufferType.allocate(capacity: next)
                _ = grown.moveInitialize(fromContentsOf: result[..<size])
                result.deallocate()
                result = grown
            }
            _ = result[size..<required].initialize(fromContentsOf: bytes)
            size = required
            count = count + 1
        }
    }

    let path = "./store/swift-optimized-foundation.txt"
    if !FileManager.default.fileExists(atPath: path) {
        guard FileManager.default.createFile(atPath: path, contents: nil) else { fatalError("createFile failed") }
    }
    let file = try! FileHandle(forWritingTo: URL(fileURLWithPath: path))
    try! file.truncate(atOffset: 0)
    // The buffer stays alive until the synchronous write and close finish.
    let data = size == 0 ? Data() : Data(bytesNoCopy: result.baseAddress!, count: size, deallocator: .none)
    try! file.write(contentsOf: data)
    try! file.close()
    return size
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

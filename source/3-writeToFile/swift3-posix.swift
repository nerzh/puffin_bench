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

func run(_ iterations: Int) -> Int {
    let template = "test_text\n"
    var result = ""
    var count = 0
    while count < iterations {
        result.append(template)
        count = count + 1
    }
    let fd = open("./store/swift.txt", O_TRUNC | O_WRONLY | O_CREAT, 0o666)
    guard fd >= 0 else { perror("open"); exit(1) }
    result.withUTF8 { bytes in
        var offset = 0
        while offset < bytes.count {
            let written = write(fd, bytes.baseAddress!.advanced(by: offset), bytes.count - offset)
            if written < 0 {
                if errno == EINTR { continue }
                perror("write")
                exit(1)
            }
            guard written > 0 else { fatalError("Write made no progress") }
            offset += written
        }
    }
    guard close(fd) == 0 else { perror("close"); exit(1) }
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

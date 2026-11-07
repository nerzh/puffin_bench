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
    let base = String(repeating: "x", count: 10_000)
    var results: [String] = []
    results.reserveCapacity(iterations)
    
    for i in 0..<iterations {
        var s = base
        if i % 1000 == 0 {
            s += "!"
        }
        results.append(consume s)
    }
    var total = 0
    for s in results {
        total += s.utf8.count
    }
    return total
}

func main() {
    guard CommandLine.arguments.count <= 3 else { fatalError("iterations [warmup]") }
    let iterations = argument(1, 5_000_000)
    let warmup = argument(2, 10_000)
    let warmupTotal = run(warmup)
    let start = nowNS()
    let total = run(iterations)
    let elapsed = nowNS() - start
    print("elapsed_ns=\(elapsed) checksum=\(total) warmup_checksum=\(warmupTotal)")
}
main()

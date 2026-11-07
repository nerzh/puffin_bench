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

final class Sorter {
    var arr = [Int64](repeating: 0, count: 100)
    func shellsSort() {
        var gap = arr.count / 2
        while gap > 0 {
            var i = gap
            while i < arr.count {
                let temp = arr[i]
                var j = i
                while j >= gap && arr[j - gap] > temp {
                    arr[j] = arr[j - gap]
                    j = j - gap
                }
                arr[j] = temp
                i = i + 1
            }
            gap = gap / 2
        }
    }
    func run(_ iterations: Int, _ seed: Int64) -> Int64 {
        var state = seed
        var checksum: Int64 = 0
        var c = 0
        while c < iterations {
            var k = 0
            while k < arr.count {
                state = (state * 1664525 + 1013904223) & 2147483647
                arr[k] = (state >> 8) & 65535
                k = k + 1
            }
            shellsSort()
            k = 0
            while k < arr.count {
                checksum = (checksum * 31 + arr[k]) & 2147483647
                k = k + 1
            }
            c = c + 1
        }
        return checksum
    }
}

func main() {
    guard (2...4).contains(CommandLine.arguments.count) else { fatalError("iterations [seed [warmup]]") }
    let iterations = argument(1, 0)
    let seed = Int64(argument(2, 12345))
    let warmup = argument(3, 10000)
    let sorter = Sorter()
    let warmupChecksum = sorter.run(warmup, seed)
    let start = nowNS()
    let checksum = sorter.run(iterations, seed)
    let elapsed = nowNS() - start
    print("elapsed_ns=\(elapsed) checksum=\(checksum) warmup_checksum=\(warmupChecksum)")
}
main()

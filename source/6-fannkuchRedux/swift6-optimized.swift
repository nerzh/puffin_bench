/* The Computer Language Benchmarks Game
 https://salsa.debian.org/benchmarksgame-team/benchmarksgame/
 contributed by Ralph Ganszky
 converted to Swift 3 by Daniel Muellenborn
 Source: https://benchmarksgame-team.pages.debian.net/benchmarksgame/program/fannkuchredux-swift-3.html
 See LICENSE for the upstream BSD-3-Clause license.
 The permutation order, flip algorithm and 150-chunk scheduling are unchanged.
 Local storage uses Swift 6.2+ inline arrays and a noncopyable worker.
 */

#if canImport(Darwin)
import Darwin
#else
import Glibc
#endif
import Dispatch

struct TaskResult: Sendable {
    var maxFlips = 0
    var checksum = 0
}

struct Fannkuch: ~Copyable {
    let n: Int
    // n is at most 16. Each worker owns its buffers directly, without ARC or COW.
    var p: [16 of Int] = .init(repeating: 0)
    var pp: [16 of Int] = .init(repeating: 0)
    var count: [16 of Int] = .init(repeating: 0)

    init(n: Int) {
        self.n = n
    }

    mutating func firstPermutation(_ idx: Int, factorials: borrowing Span<Int>) {
        for i in 0..<n {
            p[i] = i
        }

        var index = idx
        for i in stride(from: n - 1, to: 0, by: -1) {
            let d = index / factorials[i]
            count[i] = d
            index %= factorials[i]

            pp = p
            for j in 0...i {
                p[j] = j + d <= i ? pp[j + d] : pp[j + d - i - 1]
            }
        }
    }

    mutating func nextPermutation() {
        var first = p[1]
        p[1] = p[0]
        p[0] = first

        var i = 1
        count[i] += 1
        while count[i] > i {
            count[i] = 0
            i += 1
            p[0] = p[1]
            let next = p[0]
            for j in 1..<i {
                p[j] = p[j + 1]
            }
            p[i] = first
            first = next
            count[i] += 1
        }
    }

    mutating func countFlips() -> Int {
        var flips = 1
        var first = p[0]
        if p[first] != 0 {
            // This copy is required: flips must not modify the current permutation.
            pp = p
            repeat {
                flips += 1
                var lo = 1
                var hi = first - 1
                while lo < hi {
                    let t = pp[lo]
                    pp[lo] = pp[hi]
                    pp[hi] = t
                    lo += 1
                    hi -= 1
                }
                let t = pp[first]
                pp[first] = first
                first = t
            } while pp[first] != 0
        }
        return flips
    }

    consuming func runTask(
        _ task: Int,
        chunkSize: Int,
        factorials: borrowing Span<Int>
    ) -> TaskResult {
        var worker = consume self
        let idxMin = task * chunkSize
        let idxMax = min(factorials[worker.n], idxMin + chunkSize)
        worker.firstPermutation(idxMin, factorials: factorials)

        var result = TaskResult(maxFlips: 1)
        var i = idxMin
        while true {
            if worker.p[0] != 0 {
                let flips = worker.countFlips()
                if flips > result.maxFlips {
                    result.maxFlips = flips
                }
                result.checksum += i % 2 == 0 ? flips : -flips
            }
            i += 1
            if i == idxMax {
                break
            }
            worker.nextPermutation()
        }
        return result
    }
}

func main() {
    let n = CommandLine.arguments.count > 1 ? Int(CommandLine.arguments[1]) ?? 0 : 12
    guard CommandLine.arguments.count <= 2, (3...16).contains(n) else {
        fputs("Usage: fannkuch-redux [n], where n is an integer in 3...16\n", stderr)
        exit(2)
    }

    var fact: [17 of Int] = .init(repeating: 1)
    for i in 1...n {
        fact[i] = fact[i - 1] * i
    }
    let factorials = fact
    let nchunks = 150
    let chunkSize = (factorials[n] + nchunks - 1) / nchunks
    let taskCount = (factorials[n] + chunkSize - 1) / chunkSize
    var results: [150 of TaskResult] = .init(repeating: TaskResult())

    do {
        var outputSpan = results.mutableSpan
        outputSpan.withUnsafeMutableBufferPointer { buffer in
            // concurrentPerform joins before this borrow ends. Each task writes one
            // distinct element, and results are read only after all tasks finish.
            nonisolated(unsafe) let output = buffer
            DispatchQueue.concurrentPerform(iterations: taskCount) { i in
                let worker = Fannkuch(n: n)
                output[i] = worker.runTask(i, chunkSize: chunkSize, factorials: factorials.span)
            }
        }
    }

    var result = TaskResult()
    for i in 0..<taskCount {
        result.maxFlips = max(result.maxFlips, results[i].maxFlips)
        result.checksum += results[i].checksum
    }
    print("\(result.checksum)\nPfannkuchen(\(n)) = \(result.maxFlips)")
}

main()

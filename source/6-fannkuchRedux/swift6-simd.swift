/* The Computer Language Benchmarks Game
 https://salsa.debian.org/benchmarksgame-team/benchmarksgame/
 Rust #6 contributed by Henry Jayakusuma, inspired by Andrei Simion's C++ SIMD version.
 Source: https://benchmarksgame-team.pages.debian.net/benchmarksgame/program/fannkuchredux-rust-6.html
 See LICENSE for the upstream BSD-3-Clause license.
 Swift port: identical byte masks, permutation traversal, flip counting and checksum.
 Dispatch schedules the same n * (n - 1) work blocks instead of Rayon's nested loops.
 Hardware intrinsics come directly from the toolchain's internal Clang module.
 This is a single Swift source file; no custom C header or library is required.
 */

#if canImport(Darwin)
import Darwin
#else
import Glibc
#endif
import Dispatch

#if arch(arm64)
import _Builtin_intrinsics.arm.neon
#elseif arch(x86_64)
import _Builtin_intrinsics.intel
#else
#error("Fannkuch SIMD requires ARM64 NEON or x86_64 SSSE3.")
#endif

typealias Permutation = SIMD16<UInt8>

@inline(__always)
func shuffleBytes(_ value: Permutation, _ indices: Permutation) -> Permutation {
    // These toolchain modules are internal APIs; all mask indices are in 0...15.
    #if arch(arm64)
    return vqtbl1q_u8(value, indices)
    #elseif arch(x86_64)
    return unsafeBitCast(
        _mm_shuffle_epi8(
            unsafeBitCast(value, to: __m128i.self),
            unsafeBitCast(indices, to: __m128i.self)
        ),
        to: Permutation.self
    )
    #endif
}

struct TaskResult: Sendable {
    var checksum: Int32 = 0
    var maxFlips: Int32 = 0
}

struct Fannkuch: ~Copyable {
    var current: Permutation
    var count: [16 of UInt8] = .init(repeating: 0)
    let n: Int
    let innerRotation: UInt8

    init(current: Permutation, n: Int, outerRotation: Int, innerRotation: Int) {
        self.current = current
        self.n = n
        self.innerRotation = UInt8(innerRotation)
        count[n - 1] = UInt8(outerRotation)
        count[n - 2] = UInt8(innerRotation)
    }

    @inline(__always)
    mutating func advance(rotateMasks: borrowing Span<Permutation>) {
        for layer in 1..<16 {
            current = shuffleBytes(current, rotateMasks[layer])
            count[layer] += 1
            if count[layer] <= UInt8(layer) {
                break
            }
            count[layer] = 0
        }
    }

    consuming func runTask(
        reverseMasks: borrowing Span<Permutation>,
        rotateMasks: borrowing Span<Permutation>
    ) -> TaskResult {
        var worker = consume self
        var result = TaskResult()
        while worker.count[worker.n - 2] == worker.innerRotation {
            var permutation = worker.current
            var flips: Int32 = 0
            var first = permutation[0]
            if first > 0 {
                while first > 0 {
                    let next = permutation[Int(first)]
                    permutation = shuffleBytes(permutation, reverseMasks[Int(first)])
                    first = next
                    flips += 1
                }
                // Match Rust #6's branch-free checksum sign and Int32 arithmetic.
                let parity = Int32(worker.count[1])
                result.checksum &+= (flips ^ -parity) &+ parity
                result.maxFlips = max(result.maxFlips, flips)
            }
            worker.advance(rotateMasks: rotateMasks)
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

    let identity = Permutation(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15)
    let reverseMasks: [16 of Permutation] = .init { last in
        var mask = identity
        for i in 0...last {
            mask[i] = UInt8(last - i)
        }
        return mask
    }
    let rotateMasks: [16 of Permutation] = .init { last in
        var mask = identity
        for i in 0..<last {
            mask[i] = UInt8(i + 1)
        }
        mask[last] = 0
        return mask
    }

    // Precompute the same outer and inner rotations as Rust #6, without Vec allocations.
    let taskCount = n * (n - 1)
    var starts: [240 of Permutation] = .init(repeating: identity)
    var outer = identity
    for outerRotation in 0..<n {
        var inner = outer
        for innerRotation in 0..<(n - 1) {
            starts[outerRotation * (n - 1) + innerRotation] = inner
            inner = shuffleBytes(inner, rotateMasks[n - 2])
        }
        outer = shuffleBytes(outer, rotateMasks[n - 1])
    }
    let permutations = starts
    var results: [240 of TaskResult] = .init(repeating: TaskResult())
    do {
        var outputSpan = results.mutableSpan
        outputSpan.withUnsafeMutableBufferPointer { buffer in
            // Each task writes a distinct element; concurrentPerform joins before
            // this borrow ends and before the results are read.
            nonisolated(unsafe) let output = buffer
            DispatchQueue.concurrentPerform(iterations: taskCount) { task in
                let worker = Fannkuch(
                    current: permutations[task],
                    n: n,
                    outerRotation: task / (n - 1),
                    innerRotation: task % (n - 1)
                )
                output[task] = worker.runTask(
                    reverseMasks: reverseMasks.span,
                    rotateMasks: rotateMasks.span
                )
            }
        }
    }

    var result = TaskResult()
    for i in 0..<taskCount {
        result.checksum &+= results[i].checksum
        result.maxFlips = max(result.maxFlips, results[i].maxFlips)
    }
    print("\(result.checksum)\nPfannkuchen(\(n)) = \(result.maxFlips)")
}

main()

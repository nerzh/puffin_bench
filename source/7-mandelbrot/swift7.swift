/* The Computer Language Benchmarks Game
 https://salsa.debian.org/benchmarksgame-team/benchmarksgame/
 Based on Swift #7 by Isaac Gouy, David Turnbull and Patrick Stein,
 a transliteration of Greg Buchholz's C program.
 Source: https://benchmarksgame-team.pages.debian.net/benchmarksgame/program/mandelbrot-swift-7.html
 See LICENSE for the upstream BSD-3-Clause license.
 Keeps the Swift algorithm: 50 iterations, five-step escape checks and
 the previous byte controlling early exit. Requires Swift 6.4+.
 */

import Foundation
import Dispatch

typealias Points = SIMD8<Double>

struct Mandelbrot: ~Copyable {
    var zr: Points = .zero
    var zi: Points = .zero
    var tr: Points = .zero
    var ti: Points = .zero

    @inline(__always)
    mutating func step(cr: Points, ci: Double) {
        zi = 2.0 * zr * zi + ci
        zr = tr - ti + cr
        tr = zr * zr
        ti = zi * zi
    }

    @inline(__always)
    consuming func pixel(cr: Points, ci: Double, previous: UInt8) -> UInt8 {
        var state = consume self
        // Include the boundary |z|^2 == 4, matching the reference and Rust #4.
        let threshold = Points(repeating: 4)
        let empty = SIMDMask<SIMD8<Int64>>(repeating: false)
        if previous == 0 {
            for _ in 0..<10 {
                for _ in 0..<5 {
                    state.step(cr: cr, ci: ci)
                }
                if (state.tr + state.ti .<= threshold) == empty {
                    return 0
                }
            }
        } else {
            for _ in 0..<50 {
                state.step(cr: cr, ci: ci)
            }
        }
        let inside = state.tr + state.ti .<= threshold
        let weights = SIMD8<Int64>(128, 64, 32, 16, 8, 4, 2, 1)
        // Public SIMD selection replaces the original unsafeBitCast of a mask.
        return UInt8(SIMD8<Int64>.zero.replacing(with: weights, where: inside).wrappedSum())
    }
}

func render(size: Int) -> UniqueArray<UInt8> {
    let stride = size / 8
    let scale = 2.0 / Double(size)
    let real = UniqueArray<Points>(capacity: stride) { output in
        for x in 0..<stride {
            let first = x * 8
            // Evaluate each coordinate in the same order as Rust #4. Grouping
            // the additions as in upstream Swift can change boundary pixels.
            let indices = Points(Double(first), Double(first + 1),
                Double(first + 2), Double(first + 3), Double(first + 4),
                Double(first + 5), Double(first + 6), Double(first + 7))
            output.append(indices * scale - 1.5)
        }
    }
    var pixels = UniqueArray<UInt8>(repeating: 0, count: size * stride)
    real.span.withUnsafeBufferPointer { input in
        var outputSpan = pixels.mutableSpan
        outputSpan.withUnsafeMutableBufferPointer { buffer in
            // concurrentPerform joins within these borrows. Coordinates are
            // immutable; each task writes a distinct, fully initialized row.
            nonisolated(unsafe) let coordinates = input
            nonisolated(unsafe) let output = buffer
            DispatchQueue.concurrentPerform(iterations: size) { y in
                let cr = coordinates.span
                var row = UnsafeMutableBufferPointer(
                    start: output.baseAddress! + y * stride, count: stride).mutableSpan
                let ci = Double(y) * scale - 1.0
                var previous: UInt8 = 0
                for x in 0..<stride {
                    previous = Mandelbrot().pixel(cr: cr[x], ci: ci, previous: previous)
                    row[x] = previous
                }
            }
        }
    }
    return pixels
}

func writePBM(_ pixels: consuming UniqueArray<UInt8>, size: Int) throws {
    let stdout = FileHandle.standardOutput
    try stdout.write(contentsOf: Data("P4\n\(size) \(size)\n".utf8))
    try pixels.span.withUnsafeBufferPointer { buffer in
        // Data borrows the uniquely owned allocation only during the write.
        try stdout.write(contentsOf: Data(bytesNoCopy:
            UnsafeMutableRawPointer(mutating: buffer.baseAddress!),
            count: buffer.count, deallocator: .none))
    }
}

func main() throws {
    let size = CommandLine.arguments.count > 1 ? Int(CommandLine.arguments[1]) ?? 0 : 200
    guard CommandLine.arguments.count <= 2, size >= 8, size % 8 == 0,
          !size.multipliedReportingOverflow(by: size / 8).overflow else {
        fputs("Usage: mandelbrot [size], a positive multiple of 8\n", stderr)
        exit(2)
    }
    let pixels = render(size: size)
    try writePBM(consume pixels, size: size)
}

try main()

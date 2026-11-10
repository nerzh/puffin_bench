/* The Computer Language Benchmarks Game
 https://salsa.debian.org/benchmarksgame-team/benchmarksgame/
 Swift translation of Rust #4 by Matt Watson, TeXitoi,
 Volodymyr M. Lisivka, Michael Cicotti and Ryohei Machida.
 Source: https://benchmarksgame-team.pages.debian.net/benchmarksgame/program/mandelbrot-rust-4.html
 See LICENSE for the upstream BSD-3-Clause license.
 Uses ordinary elementwise arithmetic on InlineArray; vectorization is left
 to the compiler. Dispatch replaces Rayon. Requires Swift 6.4+.
 */

import Foundation
import Dispatch

struct F64x8 {
    var values: [8 of Double]

    init(_ values: consuming [8 of Double]) {
        self.values = consume values
    }

    init(repeating value: Double) {
        values = .init(repeating: value)
    }

    subscript(_ index: Int) -> Double { values[index] }

    @inline(__always)
    static func + (lhs: borrowing Self, rhs: borrowing Self) -> Self {
        Self([lhs[0] + rhs[0], lhs[1] + rhs[1], lhs[2] + rhs[2], lhs[3] + rhs[3],
              lhs[4] + rhs[4], lhs[5] + rhs[5], lhs[6] + rhs[6], lhs[7] + rhs[7]])
    }

    @inline(__always)
    static func - (lhs: borrowing Self, rhs: borrowing Self) -> Self {
        Self([lhs[0] - rhs[0], lhs[1] - rhs[1], lhs[2] - rhs[2], lhs[3] - rhs[3],
              lhs[4] - rhs[4], lhs[5] - rhs[5], lhs[6] - rhs[6], lhs[7] - rhs[7]])
    }

    @inline(__always)
    static func * (lhs: borrowing Self, rhs: borrowing Self) -> Self {
        Self([lhs[0] * rhs[0], lhs[1] * rhs[1], lhs[2] * rhs[2], lhs[3] * rhs[3],
              lhs[4] * rhs[4], lhs[5] * rhs[5], lhs[6] * rhs[6], lhs[7] * rhs[7]])
    }

    @inline(__always)
    static func + (lhs: borrowing Self, rhs: Double) -> Self {
        Self([lhs[0] + rhs, lhs[1] + rhs, lhs[2] + rhs, lhs[3] + rhs,
              lhs[4] + rhs, lhs[5] + rhs, lhs[6] + rhs, lhs[7] + rhs])
    }

    @inline(__always)
    static func - (lhs: borrowing Self, rhs: Double) -> Self {
        Self([lhs[0] - rhs, lhs[1] - rhs, lhs[2] - rhs, lhs[3] - rhs,
              lhs[4] - rhs, lhs[5] - rhs, lhs[6] - rhs, lhs[7] - rhs])
    }

    @inline(__always)
    static func * (lhs: borrowing Self, rhs: Double) -> Self {
        Self([lhs[0] * rhs, lhs[1] * rhs, lhs[2] * rhs, lhs[3] * rhs,
              lhs[4] * rhs, lhs[5] * rhs, lhs[6] * rhs, lhs[7] * rhs])
    }

    @inline(__always)
    func allEscaped() -> Bool {
        let low = (self[0] > 4 ? 1 : 0) & (self[1] > 4 ? 1 : 0)
                & (self[2] > 4 ? 1 : 0) & (self[3] > 4 ? 1 : 0)
        let high = (self[4] > 4 ? 1 : 0) & (self[5] > 4 ? 1 : 0)
                 & (self[6] > 4 ? 1 : 0) & (self[7] > 4 ? 1 : 0)
        return low != 0 && high != 0
    }

    @inline(__always)
    func packedBits() -> UInt8 {
        var bits: UInt8 = 0
        bits |= self[0] <= 4 ? 1 : 0
        bits |= self[1] <= 4 ? 2 : 0
        bits |= self[2] <= 4 ? 4 : 0
        bits |= self[3] <= 4 ? 8 : 0
        bits |= self[4] <= 4 ? 16 : 0
        bits |= self[5] <= 4 ? 32 : 0
        bits |= self[6] <= 4 ? 64 : 0
        bits |= self[7] <= 4 ? 128 : 0
        return bits
    }
}

struct Mandelbrot: ~Copyable {
    var zr: F64x8
    var zi: F64x8
    var tr: F64x8
    var ti: F64x8

    init(cr: borrowing F64x8, ci: Double) {
        zr = copy cr
        zi = F64x8(repeating: ci)
        tr = zr * zr
        ti = zi * zi
    }

    @inline(__always)
    mutating func step(cr: borrowing F64x8, ci: Double) {
        zi = (zr + zr) * zi + ci
        zr = tr - ti + cr
        tr = zr * zr
        ti = zi * zi
    }
}

@inline(never)
func mand8(cr: borrowing F64x8, ci: Double, previous: UInt8) -> UInt8 {
    var state = Mandelbrot(cr: cr, ci: ci)
    for _ in 0..<12 {
        for _ in 0..<4 {
            state.step(cr: cr, ci: ci)
        }
        if previous == 0 && (state.tr + state.ti).allEscaped() {
            return 0
        }
    }
    state.step(cr: cr, ci: ci)
    return (state.tr + state.ti).packedBits()
}

func render(size: Int) -> UniqueArray<UInt8> {
    let stride = size / 8
    let scale = 2.0 / Double(size)
    let real = UniqueArray<F64x8>(capacity: stride) { output in
        for x in 0..<stride {
            let first = x * 8
            let indices = F64x8([Double(first + 7), Double(first + 6),
                Double(first + 5), Double(first + 4), Double(first + 3),
                Double(first + 2), Double(first + 1), Double(first)])
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
                    previous = mand8(cr: cr[x], ci: ci, previous: previous)
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

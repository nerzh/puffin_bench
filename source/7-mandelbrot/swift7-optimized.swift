/* The Computer Language Benchmarks Game
 https://salsa.debian.org/benchmarksgame-team/benchmarksgame/
 Swift translation of Rust #4 by Matt Watson, TeXitoi,
 Volodymyr M. Lisivka, Michael Cicotti and Ryohei Machida.
 Source: https://benchmarksgame-team.pages.debian.net/benchmarksgame/program/mandelbrot-rust-4.html
 See LICENSE for the upstream BSD-3-Clause license.
 Uses public SIMD8 operations, keeping Rust's 50-iteration recurrence,
 four-step escape checks and previous-byte heuristic. Requires Swift 6.4+.
 ANALYTIC_INTERIOR enables an additional algorithmic optimization: skip
 groups entirely inside the main cardioid or period-two bulb. This changes
 the amount of work compared with the Benchmarks Game iterative algorithm.
 */

import Foundation
import Dispatch

typealias F64x8 = SIMD8<Double>

extension F64x8 {
    @inline(__always)
    func allEscaped() -> Bool {
        // Values may become NaN after escape. None of them can re-enter the
        // set; testing for no remaining inside lanes still exits such groups.
        (self .<= Self(repeating: 4)) == SIMDMask<SIMD8<Int64>>(repeating: false)
    }
    @inline(__always)
    func packedBits() -> UInt8 {
        let inside = self .<= Self(repeating: 4)
        let weights = SIMD8<Int64>(1, 2, 4, 8, 16, 32, 64, 128)
        return UInt8(SIMD8<Int64>.zero.replacing(with: weights, where: inside).wrappedSum())
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

@inline(__always)
func mand8(cr: borrowing F64x8, ci: Double, previous: UInt8) -> UInt8 {
#if ANALYTIC_INTERIOR
    // The main cardioid satisfies q(q + x - 1/4) < y^2/4, where
    // q = (x - 1/4)^2 + y^2. The period-two bulb is the disk
    // (x + 1)^2 + y^2 < 1/16. Leave a conservative gap at both boundaries:
    // uncertain and mixed groups use the ordinary iteration below.
    // https://mathworld.wolfram.com/MandelbrotSet.html
    let ciSquared = ci * ci
    let shifted = cr - 0.25
    let q = shifted * shifted + ciSquared
    let cardioid = q * (q + shifted) .< F64x8(repeating: 0.25 * ciSquared - 1e-12)
    let bulbX = cr + 1.0
    let bulb = bulbX * bulbX + ciSquared .< F64x8(repeating: 0.0625 - 1e-12)
    if (cardioid .| bulb) == SIMDMask<SIMD8<Int64>>(repeating: true) {
        return 255
    }
#endif
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
            let indices = F64x8(Double(first + 7), Double(first + 6),
                Double(first + 5), Double(first + 4), Double(first + 3),
                Double(first + 2), Double(first + 1), Double(first))
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

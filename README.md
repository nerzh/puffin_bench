# puffin_bench

Sorting, string and file-writing benchmarks for macOS and Linux, with implementations
in C, Swift, Rust, Go, Zig, Kotlin, Scala, JavaScript, Python, Ruby, PHP, Perl and
Elixir. Available implementations vary by suite.

## Running

The runner requires Bash 3.2+, `/usr/bin/time` (BSD on macOS, GNU on Linux), and the
compilers or runtimes for the selected languages. Missing tools are reported and
skipped. Swift sorting uses Swift 6.2+ features; Zig sources target the 0.17 API.

```bash
./run.sh
```

The current configuration runs only the append with base suite for Swift and
Rust. Compilation happens before measurement. Compiler commands and optimization
flags are defined in `scripts/benchmarks.sh`.

## Selecting benchmarks and execution order

Edit `run_all()` at the bottom of `run.sh` to enable suites and change their order.
For example, this runs all five suites with append with base first:

```bash
run_all() {
  appendWithBase
  smallStringPushBack
  writeToFile
  sortArray
  sortGlobalArray
}
```

Language order is controlled by the `*_BENCHMARKS` arrays in `run.sh`.
Comment out an entry to disable it or move it to change its position.

To run individual implementations:

```bash
source ./run.sh
swiftAppendWithBase
rustAppendWithBase
```

## Workloads

| Suite | Work |
| --- | --- |
| Array sort | Refill a 100-element array, Shell-sort it, and update an order-sensitive checksum. The array is passed to the sorting function. |
| Global array sort | The same workload with implementations that keep the array in an object, struct or shared state. Swift's enabled variant is a struct. |
| Buffer construction and file writing | Append `test_text\n` repeatedly, then open or truncate the output file, write the buffer and close it. |
| Small string push back | Create `"user-"` on every iteration, append the decimal loop index and add the string's UTF-8 byte length to a running total. |
| Append with base | Start each iteration from a 10,000-byte base string, append `!` every 1,000 iterations, retain all results in an array and sum their UTF-8 byte lengths. |

Sorting uses deterministic input from `BENCH_SEED`, with Shell-sort gaps of
50, 25, 12, 6, 3 and 1. The measured time includes input generation, sorting and
checksum updates. Seed and checksum are reset after warmup.

Writers append 10 UTF-8 bytes per iteration. The default workload produces
800,000,000 bytes per file. Warmup writes the same path before the measured run.
Buffers grow incrementally; the final size is not reserved in advance.

Swift's enabled writers are the optimized POSIX and Foundation variants. POSIX
uses `realloc`; Foundation uses `UnsafeMutableBufferPointer<UInt8>` with explicit
allocation and transfer when growing, and `Data(bytesNoCopy:)` for writing.
The ordinary `String` variants remain available as commented entries.

## Configuration

Settings can be overridden through environment variables:

| Variable | Default | Meaning |
| --- | --- | --- |
| `DEFAULT_ITERATIONS` | `1500000` | Default number of measured sorting iterations. |
| `SORT_ARRAY_ITR` | `DEFAULT_ITERATIONS` | Iterations for array sorting. |
| `SORT_GLOBAL_ARRAY_ITR` | `DEFAULT_ITERATIONS` | Iterations for global array sorting. |
| `BENCH_SEED` | `12345` | Input seed for sorting. |
| `SORT_WARMUP` | `10000` | Untimed sorting iterations per process. |
| `WRITE_FILE_LINES` | `80000000` | Lines written in the measured workload. |
| `WRITE_WARMUP_LINES` | `10000` | Lines written during warmup. |
| `SMALL_STRING_ITR` | `50000000` | Measured small string push back iterations. |
| `SMALL_STRING_WARMUP` | `10000` | Untimed small string push back iterations. |
| `APPEND_BASE_ITR` | `5000000` | Measured append with base iterations. |
| `APPEND_BASE_WARMUP` | `10000` | Untimed append with base iterations. |
| `BENCH_RUNS` | `1` | Separate process launches per implementation. |

```bash
APPEND_BASE_ITR=5000000 BENCH_RUNS=3 ./run.sh
```

`GCC`, `PHP` and `ZIG` select alternative executables. `ZIG_OPTIMIZE` defaults to
`safe`. Versions are printed before each benchmark.

## Measurements

- **Workload time:** elapsed seconds
  inside the program, excluding startup and warmup.
- **Total process time:** elapsed seconds from process start to exit, including
  startup, warmup and reporting.
- **CPU usage:** user plus system CPU time in milliseconds, followed by CPU time
  divided by total process time. 100% means one fully occupied logical core;
  multithreaded programs can exceed 100%.
- **CPU cycles:** reported when the operating system provides the counter.
- **Peak RAM:** maximum resident set size in MiB.
- **Context switches:** voluntary and involuntary switches for the whole process.

Repeated runs are reported individually. Compilation is excluded from all timing.
File writes do not request `fsync`, so results include filesystem-cache effects.
Storage types, allocation strategies and runtime behavior differ between languages;
compare results on the same machine with the same workload settings.

## Layout

- `run.sh`: workload settings, enabled implementations and suite order.
- `source/`: benchmark implementations grouped by suite.
- `scripts/`: build commands, measurement helpers and output formatting.
- `compiled/`: generated executables and compiler caches; ignored by Git.
- `store/`: generated benchmark files; ignored by Git.

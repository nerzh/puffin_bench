#!/usr/bin/env bash

# Workload sizes and number of measured runs. Override via environment variables.
DEFAULT_ITERATIONS=${DEFAULT_ITERATIONS:-1500000}
SORT_ARRAY_ITR=${SORT_ARRAY_ITR:-$DEFAULT_ITERATIONS}
SORT_GLOBAL_ARRAY_ITR=${SORT_GLOBAL_ARRAY_ITR:-$DEFAULT_ITERATIONS}
BENCH_RUNS=${BENCH_RUNS:-1}
BENCH_SEED=${BENCH_SEED:-12345}
SORT_WARMUP=${SORT_WARMUP:-10000}
WRITE_WARMUP_LINES=${WRITE_WARMUP_LINES:-10000}
WRITE_FILE_LINES=${WRITE_FILE_LINES:-80000000}
SMALL_STRING_ITR=${SMALL_STRING_ITR:-50000000}
SMALL_STRING_WARMUP=${SMALL_STRING_WARMUP:-10000}
APPEND_BASE_ITR=${APPEND_BASE_ITR:-5000000}
APPEND_BASE_WARMUP=${APPEND_BASE_WARMUP:-10000}
# Benchmarks Game uses n=12; n=7 is a quick correctness check.
FANNKUCH_N=${FANNKUCH_N:-12}
# Benchmarks Game uses 16000; 200 checks the published reference image.
MANDELBROT_SIZE=${MANDELBROT_SIZE:-16000}
PHP=${PHP:-php}
GCC=${GCC:-gcc}
ZIG=${ZIG:-zig}
ZIG_OPTIMIZE=${ZIG_OPTIMIZE:-safe}

# Compiled programs are enabled. Uncomment a disabled entry to opt in.
# Kotlin/Scala compile to JVM bytecode; Node/Elixir and interpreted scripts are disabled.
SORT_ARRAY_BENCHMARKS=(
  # perlSortArray
  # phpSortArray
  # nodejsSortArray
  # rubySortArray
  # pythonSortArray
  kotlinSortArray
  # elixirSortArray
  goSortArray
  scalaSortArray
  rustSortArray
  swiftSortArray
  zigSortArray
  gccSortArray
  clangSortArray
)

SORT_GLOBAL_ARRAY_BENCHMARKS=(
  # perlSortGlobalArray
  # phpSortGlobalArray
  # nodejsSortGlobalArray
  # rubySortGlobalArray
  # pythonSortGlobalArray
  goSortGlobalArray
  rustSortGlobalArray
  # swiftSortGlobalArrayClass
  # swiftSortGlobalArrayFinalClass
  # swiftSortGlobalArrayFunction
  swiftSortGlobalArrayStruct
  zigSortGlobalArray
  gccSortGlobalArray
  clangSortGlobalArray
)

WRITE_FILE_BENCHMARKS=(
  # nodejsWriteToFile
  # rubyWriteToFile
  kotlinWriteToFile
  goWriteToFile
  scalaWriteToFile
  rustWriteToFile
  # swiftWriteToFile
  # swiftPOSIXWriteToFile
  swiftOptimizedWriteToFile
  swiftOptimizedFoundationWriteToFile
  zigWriteToFile
  gccWriteToFile
  clangWriteToFile
)

SMALL_STRING_BENCHMARKS=(
  swiftSmallStringPushBack
  rustSmallStringPushBack
)

APPEND_BASE_BENCHMARKS=(
  rustAppendWithBase
  swiftAppendWithBase
  rustAppendWithBaseCow
  swiftAppendWithBaseOptimized
)

FANNKUCH_BENCHMARKS=(
  rustFannkuchRedux
  swiftFannkuchRedux
  swiftFannkuchReduxOptimized
  swiftFannkuchReduxSIMD
)

MANDELBROT_BENCHMARKS=(
  rustMandelbrot
  swiftMandelbrot
  swiftMandelbrotRust
  swiftMandelbrotOptimized
  swiftMandelbrotAnalytic
)

# Timing/output helpers and per-language compile + run functions.
BENCH_ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
SOURCE_DIR="$BENCH_ROOT/source"
BUILD_DIR="$BENCH_ROOT/compiled"
mkdir -p "$BUILD_DIR" "$BENCH_ROOT/store"
source "$BENCH_ROOT/scripts/runner.sh"
source "$BENCH_ROOT/scripts/benchmarks.sh"

sortArray() {
  run_suite "Test 1 — Array sort (by reference)" "${SORT_ARRAY_BENCHMARKS[@]}"
}

sortGlobalArray() {
  run_suite "Test 2 — Global array sort" "${SORT_GLOBAL_ARRAY_BENCHMARKS[@]}"
}

writeToFile() {
  run_suite "Test 3 — Buffer construction and file writing" "${WRITE_FILE_BENCHMARKS[@]}"
}

smallStringPushBack() {
  run_suite "Test 4 — Small string push back" "${SMALL_STRING_BENCHMARKS[@]}"
}

appendWithBase() {
  run_suite "Test 5 — Append with base" "${APPEND_BASE_BENCHMARKS[@]}"
}

fannkuchRedux() {
  run_suite "Test 6 — Fannkuch-redux (n=$FANNKUCH_N)" "${FANNKUCH_BENCHMARKS[@]}"
}

mandelbrot() (
  if [[ ! $MANDELBROT_SIZE =~ ^[1-9][0-9]{0,6}$ ]] || ((MANDELBROT_SIZE % 8 != 0)); then
    printf 'ERROR: MANDELBROT_SIZE must be a multiple of 8 in 8...9999992.\n' >&2
    return 1
  fi
  require_tools cmp cksum || return 1
  local reference_dir BENCH_REFERENCE_FILE
  reference_dir=$(mktemp -d "$BUILD_DIR/mandelbrot.XXXXXX") || return
  trap 'rm -rf "$reference_dir"' EXIT
  BENCH_REFERENCE_FILE="$reference_dir/reference.pbm"
  run_suite "Test 7 — Mandelbrot (${MANDELBROT_SIZE} x ${MANDELBROT_SIZE})" "${MANDELBROT_BENCHMARKS[@]}"
)

run_all() {
  sortArray
  sortGlobalArray
  writeToFile
  smallStringPushBack
  appendWithBase
  fannkuchRedux
  mandelbrot
}

# Sourcing defines the functions without starting the suites.
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  run_all
fi

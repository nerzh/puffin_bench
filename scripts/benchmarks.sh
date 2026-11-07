#!/usr/bin/env bash
# Each language keeps its compiler flags and measured command together.
# benchmark TITLE RUNS COMMAND [ARGS...] measures execution only, never compilation.

# Perl -------------------------------------------------------------------------
perlSortArray() {
  local BENCH_HEADER_TITLE
  local BENCH_WORK_KIND=sort
  benchmark_header "Perl — array sort (by reference)"
  require_tools perl || return 0
  perl -e 'printf "Perl %vd\n", $^V' || return
  benchmark "Perl — array sort (by reference)" "$BENCH_RUNS" \
    perl "$SOURCE_DIR/1-sortArray/perl.pl" "$SORT_ARRAY_ITR" "$BENCH_SEED" "$SORT_WARMUP"
}

perlSortGlobalArray() {
  local BENCH_HEADER_TITLE
  local BENCH_WORK_KIND=sort
  benchmark_header "Perl — global array sort"
  require_tools perl || return 0
  perl -e 'printf "Perl %vd\n", $^V' || return
  benchmark "Perl — global array sort" "$BENCH_RUNS" \
    perl "$SOURCE_DIR/2-sortGlobalArray/perl2.pl" "$SORT_GLOBAL_ARRAY_ITR" "$BENCH_SEED" "$SORT_WARMUP"
}


# PHP --------------------------------------------------------------------------
phpSortArray() {
  local BENCH_HEADER_TITLE
  local BENCH_WORK_KIND=sort
  benchmark_header "PHP — array sort (by reference)"
  require_tools "$PHP" || return 0
  "$PHP" -v || return
  benchmark "PHP — array sort (by reference)" "$BENCH_RUNS" \
    "$PHP" "$SOURCE_DIR/1-sortArray/php.php" "$SORT_ARRAY_ITR" "$BENCH_SEED" "$SORT_WARMUP"
}

phpSortGlobalArray() {
  local BENCH_HEADER_TITLE
  local BENCH_WORK_KIND=sort
  benchmark_header "PHP — global array sort"
  require_tools "$PHP" || return 0
  "$PHP" -v || return
  benchmark "PHP — global array sort" "$BENCH_RUNS" \
    "$PHP" "$SOURCE_DIR/2-sortGlobalArray/php2.php" "$SORT_GLOBAL_ARRAY_ITR" "$BENCH_SEED" "$SORT_WARMUP"
}


# NodeJS -----------------------------------------------------------------------
nodejsSortArray() {
  local BENCH_HEADER_TITLE
  local BENCH_WORK_KIND=sort
  benchmark_header "NodeJS — array sort (by reference)"
  require_tools node || return 0
  node --version || return
  benchmark "NodeJS — array sort (by reference)" "$BENCH_RUNS" \
    node "$SOURCE_DIR/1-sortArray/node.js" "$SORT_ARRAY_ITR" "$BENCH_SEED" "$SORT_WARMUP"
}

nodejsSortGlobalArray() {
  local BENCH_HEADER_TITLE
  local BENCH_WORK_KIND=sort
  benchmark_header "NodeJS — global array sort"
  require_tools node || return 0
  node --version || return
  benchmark "NodeJS — global array sort" "$BENCH_RUNS" \
    node "$SOURCE_DIR/2-sortGlobalArray/node2.js" "$SORT_GLOBAL_ARRAY_ITR" "$BENCH_SEED" "$SORT_WARMUP"
}

nodejsWriteToFile() {
  local BENCH_HEADER_TITLE
  local BENCH_WORK_KIND=write
  benchmark_header "NodeJS — buffer construction and file writing"
  require_tools node || return 0
  node --version || return
  benchmark "NodeJS — buffer construction and file writing" "$BENCH_RUNS" \
    node "$SOURCE_DIR/3-writeToFile/node3.js" "$WRITE_FILE_LINES" "$WRITE_WARMUP_LINES"
}


# Ruby -------------------------------------------------------------------------
rubySortArray() {
  local BENCH_HEADER_TITLE
  local BENCH_WORK_KIND=sort
  benchmark_header "Ruby — array sort (by reference)"
  require_tools ruby || return 0
  ruby --version || return
  benchmark "Ruby — array sort (by reference)" "$BENCH_RUNS" \
    ruby "$SOURCE_DIR/1-sortArray/ruby.rb" "$SORT_ARRAY_ITR" "$BENCH_SEED" "$SORT_WARMUP"
}

rubySortGlobalArray() {
  local BENCH_HEADER_TITLE
  local BENCH_WORK_KIND=sort
  benchmark_header "Ruby — global array sort"
  require_tools ruby || return 0
  ruby --version || return
  benchmark "Ruby — global array sort" "$BENCH_RUNS" \
    ruby "$SOURCE_DIR/2-sortGlobalArray/ruby2.rb" "$SORT_GLOBAL_ARRAY_ITR" "$BENCH_SEED" "$SORT_WARMUP"
}

rubyWriteToFile() {
  local BENCH_HEADER_TITLE
  local BENCH_WORK_KIND=write
  benchmark_header "Ruby — buffer construction and file writing"
  require_tools ruby || return 0
  ruby --version || return
  benchmark "Ruby — buffer construction and file writing" "$BENCH_RUNS" \
    ruby "$SOURCE_DIR/3-writeToFile/ruby3.rb" "$WRITE_FILE_LINES" "$WRITE_WARMUP_LINES"
}


# Python -----------------------------------------------------------------------
pythonSortArray() {
  local BENCH_HEADER_TITLE
  local BENCH_WORK_KIND=sort
  benchmark_header "Python — array sort (by reference)"
  require_tools python3 || return 0
  python3 --version || return
  benchmark "Python — array sort (by reference)" "$BENCH_RUNS" \
    python3 "$SOURCE_DIR/1-sortArray/python.py" "$SORT_ARRAY_ITR" "$BENCH_SEED" "$SORT_WARMUP"
}

pythonSortGlobalArray() {
  local BENCH_HEADER_TITLE
  local BENCH_WORK_KIND=sort
  benchmark_header "Python — global array sort"
  require_tools python3 || return 0
  python3 --version || return
  benchmark "Python — global array sort" "$BENCH_RUNS" \
    python3 "$SOURCE_DIR/2-sortGlobalArray/python2.py" "$SORT_GLOBAL_ARRAY_ITR" "$BENCH_SEED" "$SORT_WARMUP"
}


# Kotlin -----------------------------------------------------------------------
kotlinSortArray() {
  local BENCH_HEADER_TITLE
  local BENCH_WORK_KIND=sort
  benchmark_header "Kotlin — array sort (by reference)"
  require_tools kotlinc java || return 0
  kotlinc -version || return
  # This source declares main(args); compile it as .kt, not as a script.
  cp "$SOURCE_DIR/1-sortArray/kotlin.kts" "$BUILD_DIR/SortArray.kt" || return
  kotlinc "$BUILD_DIR/SortArray.kt" -include-runtime -d "$BUILD_DIR/kotlin.jar" || return
  benchmark "Kotlin — array sort (by reference)" "$BENCH_RUNS" \
    java -jar "$BUILD_DIR/kotlin.jar" "$SORT_ARRAY_ITR" "$BENCH_SEED" "$SORT_WARMUP"
}

kotlinWriteToFile() {
  local BENCH_HEADER_TITLE
  local BENCH_WORK_KIND=write
  benchmark_header "Kotlin — buffer construction and file writing"
  require_tools kotlinc java || return 0
  kotlinc -version || return
  kotlinc "$SOURCE_DIR/3-writeToFile/kotlin3.kt" -include-runtime -d "$BUILD_DIR/kotlin3.jar" || return
  benchmark "Kotlin — buffer construction and file writing" "$BENCH_RUNS" \
    java -jar "$BUILD_DIR/kotlin3.jar" "$WRITE_FILE_LINES" "$WRITE_WARMUP_LINES"
}


# Elixir -----------------------------------------------------------------------
elixirSortArray() {
  local BENCH_HEADER_TITLE
  local BENCH_WORK_KIND=sort
  benchmark_header "Elixir — immutable tuple sort"
  require_tools elixir || return 0
  elixir --version || return
  benchmark "Elixir — immutable tuple sort" "$BENCH_RUNS" \
    elixir "$SOURCE_DIR/1-sortArray/elixir.ex" "$SORT_ARRAY_ITR" "$BENCH_SEED" "$SORT_WARMUP"
}


# Swift ------------------------------------------------------------------------
swiftSortArray() {
  local BENCH_HEADER_TITLE
  local BENCH_WORK_KIND=sort
  benchmark_header "Swift — array sort (by reference)"
  require_tools swiftc || return 0
  swiftc --version || return
  swiftc -O -whole-module-optimization -module-cache-path "$BUILD_DIR/swift-cache" "$SOURCE_DIR/1-sortArray/swift.swift" -o "$BUILD_DIR/swift" || return
  benchmark "Swift — array sort (by reference)" "$BENCH_RUNS" \
    "$BUILD_DIR/swift" "$SORT_ARRAY_ITR" "$BENCH_SEED" "$SORT_WARMUP"
}

swiftSortGlobalArrayClass() {
  local BENCH_HEADER_TITLE
  local BENCH_WORK_KIND=sort
  benchmark_header "Swift — global array sort (class)"
  require_tools swiftc || return 0
  swiftc --version || return
  swiftc -O -whole-module-optimization -module-cache-path "$BUILD_DIR/swift-cache" "$SOURCE_DIR/2-sortGlobalArray/swift2_class.swift" -o "$BUILD_DIR/swift2_class" || return
  benchmark "Swift — global array sort (class)" "$BENCH_RUNS" \
    "$BUILD_DIR/swift2_class" "$SORT_GLOBAL_ARRAY_ITR" "$BENCH_SEED" "$SORT_WARMUP"
}

swiftSortGlobalArrayFinalClass() {
  local BENCH_HEADER_TITLE
  local BENCH_WORK_KIND=sort
  benchmark_header "Swift — global array sort (final class)"
  require_tools swiftc || return 0
  swiftc --version || return
  swiftc -O -whole-module-optimization -module-cache-path "$BUILD_DIR/swift-cache" "$SOURCE_DIR/2-sortGlobalArray/swift2_final_class.swift" -o "$BUILD_DIR/swift2_final_class" || return
  benchmark "Swift — global array sort (final class)" "$BENCH_RUNS" \
    "$BUILD_DIR/swift2_final_class" "$SORT_GLOBAL_ARRAY_ITR" "$BENCH_SEED" "$SORT_WARMUP"
}

swiftSortGlobalArrayFunction() {
  local BENCH_HEADER_TITLE
  local BENCH_WORK_KIND=sort
  benchmark_header "Swift — global array sort (function)"
  require_tools swiftc || return 0
  swiftc --version || return
  swiftc -O -whole-module-optimization -module-cache-path "$BUILD_DIR/swift-cache" "$SOURCE_DIR/2-sortGlobalArray/swift2_function.swift" -o "$BUILD_DIR/swift2_function" || return
  benchmark "Swift — global array sort (function)" "$BENCH_RUNS" \
    "$BUILD_DIR/swift2_function" "$SORT_GLOBAL_ARRAY_ITR" "$BENCH_SEED" "$SORT_WARMUP"
}

swiftSortGlobalArrayStruct() {
  local BENCH_HEADER_TITLE
  local BENCH_WORK_KIND=sort
  benchmark_header "Swift — global array sort (struct)"
  require_tools swiftc || return 0
  swiftc --version || return
  swiftc -O -whole-module-optimization -module-cache-path "$BUILD_DIR/swift-cache" "$SOURCE_DIR/2-sortGlobalArray/swift2_struct.swift" -o "$BUILD_DIR/swift2_struct" || return
  benchmark "Swift — global array sort (struct)" "$BENCH_RUNS" \
    "$BUILD_DIR/swift2_struct" "$SORT_GLOBAL_ARRAY_ITR" "$BENCH_SEED" "$SORT_WARMUP"
}

swiftWriteToFile() {
  local BENCH_HEADER_TITLE
  local BENCH_WORK_KIND=write
  benchmark_header "Swift — buffer construction and file writing"
  require_tools swiftc || return 0
  swiftc --version || return
  swiftc -O -whole-module-optimization -module-cache-path "$BUILD_DIR/swift-cache" "$SOURCE_DIR/3-writeToFile/swift3.swift" -o "$BUILD_DIR/swift3" || return
  benchmark "Swift — buffer construction and file writing" "$BENCH_RUNS" \
    "$BUILD_DIR/swift3" "$WRITE_FILE_LINES" "$WRITE_WARMUP_LINES"
}

swiftPOSIXWriteToFile() {
  local BENCH_HEADER_TITLE
  local BENCH_WORK_KIND=write
  benchmark_header "Swift POSIX — buffer construction and file writing"
  require_tools swiftc || return 0
  swiftc --version || return
  swiftc -O -whole-module-optimization -module-cache-path "$BUILD_DIR/swift-cache" "$SOURCE_DIR/3-writeToFile/swift3-posix.swift" -o "$BUILD_DIR/swift3-posix" || return
  benchmark "Swift POSIX — buffer construction and file writing" "$BENCH_RUNS" \
    "$BUILD_DIR/swift3-posix" "$WRITE_FILE_LINES" "$WRITE_WARMUP_LINES"
}

swiftOptimizedWriteToFile() {
  local BENCH_HEADER_TITLE
  local BENCH_WORK_KIND=write
  benchmark_header "Swift — buffer construction and file writing (optimized)"
  require_tools swiftc || return 0
  swiftc --version || return
  swiftc -O -whole-module-optimization -module-cache-path "$BUILD_DIR/swift-cache" "$SOURCE_DIR/3-writeToFile/swift3-optimized.swift" -o "$BUILD_DIR/swift3-optimized" || return
  benchmark "Swift — buffer construction and file writing (optimized)" "$BENCH_RUNS" \
    "$BUILD_DIR/swift3-optimized" "$WRITE_FILE_LINES" "$WRITE_WARMUP_LINES"
}

swiftOptimizedFoundationWriteToFile() {
  local BENCH_HEADER_TITLE
  local BENCH_WORK_KIND=write
  benchmark_header "Swift — buffer construction and file writing (optimized, Foundation)"
  require_tools swiftc || return 0
  swiftc --version || return
  swiftc -O -whole-module-optimization -module-cache-path "$BUILD_DIR/swift-cache" "$SOURCE_DIR/3-writeToFile/swift3-optimized-foundation.swift" -o "$BUILD_DIR/swift3-optimized-foundation" || return
  benchmark "Swift — buffer construction and file writing (optimized, Foundation)" "$BENCH_RUNS" \
    "$BUILD_DIR/swift3-optimized-foundation" "$WRITE_FILE_LINES" "$WRITE_WARMUP_LINES"
}


swiftSmallStringPushBack() {
  local BENCH_HEADER_TITLE
  local BENCH_WORK_KIND=small_string
  benchmark_header "Swift — small string push back"
  require_tools swiftc || return 0
  swiftc --version || return
  swiftc -O -whole-module-optimization -module-cache-path "$BUILD_DIR/swift-cache" "$SOURCE_DIR/4-smallStringPushBack/swift4.swift" -o "$BUILD_DIR/swift4" || return
  benchmark "Swift — small string push back" "$BENCH_RUNS" \
    "$BUILD_DIR/swift4" "$SMALL_STRING_ITR" "$SMALL_STRING_WARMUP"
}


swiftAppendWithBase() {
  local BENCH_HEADER_TITLE
  local BENCH_WORK_KIND=append_base
  benchmark_header "Swift — append with base"
  require_tools swiftc || return 0
  swiftc --version || return
  swiftc -O -whole-module-optimization -module-cache-path "$BUILD_DIR/swift-cache" "$SOURCE_DIR/5-appendWithBase/swift5.swift" -o "$BUILD_DIR/swift5" || return
  benchmark "Swift — append with base" "$BENCH_RUNS" \
    "$BUILD_DIR/swift5" "$APPEND_BASE_ITR" "$APPEND_BASE_WARMUP"
}


# Go ---------------------------------------------------------------------------
goSortArray() {
  local BENCH_HEADER_TITLE
  local BENCH_WORK_KIND=sort
  benchmark_header "Go — array sort (by reference)"
  require_tools go || return 0
  go version || return
  GOCACHE="$BUILD_DIR/go-cache" go build -pgo=off -trimpath -o "$BUILD_DIR/go" "$SOURCE_DIR/1-sortArray/go.go" || return
  benchmark "Go — array sort (by reference)" "$BENCH_RUNS" \
    "$BUILD_DIR/go" "$SORT_ARRAY_ITR" "$BENCH_SEED" "$SORT_WARMUP"
}

goSortGlobalArray() {
  local BENCH_HEADER_TITLE
  local BENCH_WORK_KIND=sort
  benchmark_header "Go — global array sort"
  require_tools go || return 0
  go version || return
  GOCACHE="$BUILD_DIR/go-cache" go build -pgo=off -trimpath -o "$BUILD_DIR/go2" "$SOURCE_DIR/2-sortGlobalArray/go2.go" || return
  benchmark "Go — global array sort" "$BENCH_RUNS" \
    "$BUILD_DIR/go2" "$SORT_GLOBAL_ARRAY_ITR" "$BENCH_SEED" "$SORT_WARMUP"
}

goWriteToFile() {
  local BENCH_HEADER_TITLE
  local BENCH_WORK_KIND=write
  benchmark_header "Go — buffer construction and file writing"
  require_tools go || return 0
  go version || return
  GOCACHE="$BUILD_DIR/go-cache" go build -pgo=off -trimpath -o "$BUILD_DIR/go3" "$SOURCE_DIR/3-writeToFile/go3.go" || return
  benchmark "Go — buffer construction and file writing" "$BENCH_RUNS" \
    "$BUILD_DIR/go3" "$WRITE_FILE_LINES" "$WRITE_WARMUP_LINES"
}


# Scala ------------------------------------------------------------------------
scalaSortArray() {
  local BENCH_HEADER_TITLE
  local BENCH_WORK_KIND=sort
  benchmark_header "Scala — array sort (by reference)"
  require_tools scalac scala || return 0
  scalac -version || return
  local help
  local options=(-deprecation)
  help=$(scalac -help 2>&1) || return
  # Scala 2 and recent Scala 3 use different optimizer option names.
  # Inline our own sources only; leave runtime/library linkage intact.
  case "$help" in
    *-opt-inline-from*) options+=(-opt:l:inline '-opt-inline-from:<sources>') ;;
    *-opt-inline*) options+=(-opt '-opt-inline:<sources>') ;;
    *-optimise*) options+=(-optimise) ;;
    *) printf 'Scala: this compiler has no supported bytecode optimizer; using the JVM JIT.\n' ;;
  esac
  scalac "${options[@]}" "$SOURCE_DIR/1-sortArray/scala.scala" -d "$BUILD_DIR" || return
  benchmark "Scala — array sort (by reference)" "$BENCH_RUNS" \
    scala -classpath "$BUILD_DIR" SortArray "$SORT_ARRAY_ITR" "$BENCH_SEED" "$SORT_WARMUP"
}

scalaWriteToFile() {
  local BENCH_HEADER_TITLE
  local BENCH_WORK_KIND=write
  benchmark_header "Scala — buffer construction and file writing"
  require_tools scalac scala || return 0
  scalac -version || return
  local help
  local options=(-deprecation)
  help=$(scalac -help 2>&1) || return
  # Scala 2 and recent Scala 3 use different optimizer option names.
  # Inline our own sources only; leave runtime/library linkage intact.
  case "$help" in
    *-opt-inline-from*) options+=(-opt:l:inline '-opt-inline-from:<sources>') ;;
    *-opt-inline*) options+=(-opt '-opt-inline:<sources>') ;;
    *-optimise*) options+=(-optimise) ;;
    *) printf 'Scala: this compiler has no supported bytecode optimizer; using the JVM JIT.\n' ;;
  esac
  scalac "${options[@]}" "$SOURCE_DIR/3-writeToFile/scala3.scala" -d "$BUILD_DIR" || return
  benchmark "Scala — buffer construction and file writing" "$BENCH_RUNS" \
    scala -classpath "$BUILD_DIR" WriteToFile "$WRITE_FILE_LINES" "$WRITE_WARMUP_LINES"
}


# Rust -------------------------------------------------------------------------
rustSortArray() {
  local BENCH_HEADER_TITLE
  local BENCH_WORK_KIND=sort
  benchmark_header "Rust — array sort (by reference)"
  require_tools rustc || return 0
  rustc -V || return
  rustc -O -C overflow-checks=yes -C codegen-units=1 "$SOURCE_DIR/1-sortArray/rust.rs" -o "$BUILD_DIR/rust" || return
  benchmark "Rust — array sort (by reference)" "$BENCH_RUNS" \
    "$BUILD_DIR/rust" "$SORT_ARRAY_ITR" "$BENCH_SEED" "$SORT_WARMUP"
}

rustSortGlobalArray() {
  local BENCH_HEADER_TITLE
  local BENCH_WORK_KIND=sort
  benchmark_header "Rust — global array sort"
  require_tools rustc || return 0
  rustc -V || return
  rustc -O -C overflow-checks=yes -C codegen-units=1 "$SOURCE_DIR/2-sortGlobalArray/rust2.rs" -o "$BUILD_DIR/rust2" || return
  benchmark "Rust — global array sort" "$BENCH_RUNS" \
    "$BUILD_DIR/rust2" "$SORT_GLOBAL_ARRAY_ITR" "$BENCH_SEED" "$SORT_WARMUP"
}

rustWriteToFile() {
  local BENCH_HEADER_TITLE
  local BENCH_WORK_KIND=write
  benchmark_header "Rust — buffer construction and file writing"
  require_tools rustc || return 0
  rustc -V || return
  rustc -O -C overflow-checks=yes -C codegen-units=1 "$SOURCE_DIR/3-writeToFile/rust3.rs" -o "$BUILD_DIR/rust3" || return
  benchmark "Rust — buffer construction and file writing" "$BENCH_RUNS" \
    "$BUILD_DIR/rust3" "$WRITE_FILE_LINES" "$WRITE_WARMUP_LINES"
}


rustSmallStringPushBack() {
  local BENCH_HEADER_TITLE
  local BENCH_WORK_KIND=small_string
  benchmark_header "Rust — small string push back"
  require_tools rustc || return 0
  rustc -V || return
  rustc -O -C overflow-checks=yes -C codegen-units=1 "$SOURCE_DIR/4-smallStringPushBack/rust4.rs" -o "$BUILD_DIR/rust4" || return
  benchmark "Rust — small string push back" "$BENCH_RUNS" \
    "$BUILD_DIR/rust4" "$SMALL_STRING_ITR" "$SMALL_STRING_WARMUP"
}


rustAppendWithBase() {
  local BENCH_HEADER_TITLE
  local BENCH_WORK_KIND=append_base
  benchmark_header "Rust — append with base"
  require_tools rustc || return 0
  rustc -V || return
  rustc -O -C overflow-checks=yes -C codegen-units=1 "$SOURCE_DIR/5-appendWithBase/rust5.rs" -o "$BUILD_DIR/rust5" || return
  benchmark "Rust — append with base" "$BENCH_RUNS" \
    "$BUILD_DIR/rust5" "$APPEND_BASE_ITR" "$APPEND_BASE_WARMUP"
}


rustAppendWithBaseCow() {
  local BENCH_HEADER_TITLE
  local BENCH_WORK_KIND=append_base
  benchmark_header "Rust — append with base (Cow)"
  require_tools rustc || return 0
  rustc -V || return
  rustc -O -C overflow-checks=yes -C codegen-units=1 "$SOURCE_DIR/5-appendWithBase/rust5-cow.rs" -o "$BUILD_DIR/rust5-cow" || return
  benchmark "Rust — append with base (Cow)" "$BENCH_RUNS" \
    "$BUILD_DIR/rust5-cow" "$APPEND_BASE_ITR" "$APPEND_BASE_WARMUP"
}


# Zig --------------------------------------------------------------------------
# Zig 0.17.x: LLVM backend and libc allocator; caches stay with compiled artifacts.
buildZig() {
  "$ZIG" build-exe "$1" -O "$ZIG_OPTIMIZE" -fllvm -lc \
    --cache-dir "$BUILD_DIR/zig-cache" --global-cache-dir "$BUILD_DIR/zig-global-cache" \
    "-femit-bin=$2"
}

zigSortArray() {
  local BENCH_HEADER_TITLE
  local BENCH_WORK_KIND=sort
  benchmark_header "Zig — array sort (by reference) ($ZIG_OPTIMIZE)"
  require_tools "$ZIG" || return 0
  "$ZIG" version || return
  buildZig "$SOURCE_DIR/1-sortArray/zig.zig" "$BUILD_DIR/zig" || return
  benchmark "Zig — array sort (by reference) ($ZIG_OPTIMIZE)" "$BENCH_RUNS" \
    "$BUILD_DIR/zig" "$SORT_ARRAY_ITR" "$BENCH_SEED" "$SORT_WARMUP"
}

zigSortGlobalArray() {
  local BENCH_HEADER_TITLE
  local BENCH_WORK_KIND=sort
  benchmark_header "Zig — global array sort ($ZIG_OPTIMIZE)"
  require_tools "$ZIG" || return 0
  "$ZIG" version || return
  buildZig "$SOURCE_DIR/2-sortGlobalArray/zig2.zig" "$BUILD_DIR/zig2" || return
  benchmark "Zig — global array sort ($ZIG_OPTIMIZE)" "$BENCH_RUNS" \
    "$BUILD_DIR/zig2" "$SORT_GLOBAL_ARRAY_ITR" "$BENCH_SEED" "$SORT_WARMUP"
}

zigWriteToFile() {
  local BENCH_HEADER_TITLE
  local BENCH_WORK_KIND=write
  benchmark_header "Zig — buffer construction and file writing ($ZIG_OPTIMIZE)"
  require_tools "$ZIG" || return 0
  "$ZIG" version || return
  buildZig "$SOURCE_DIR/3-writeToFile/zig3.zig" "$BUILD_DIR/zig3" || return
  benchmark "Zig — buffer construction and file writing ($ZIG_OPTIMIZE)" "$BENCH_RUNS" \
    "$BUILD_DIR/zig3" "$WRITE_FILE_LINES" "$WRITE_WARMUP_LINES"
}


# GCC --------------------------------------------------------------------------
gccSortArray() {
  local BENCH_HEADER_TITLE
  local BENCH_WORK_KIND=sort
  benchmark_header "C / $GCC — array sort (by reference)"
  require_tools "$GCC" || return 0
  local version label=GCC
  version=$("$GCC" --version) || return
  printf '%s\n' "$version"
  case "$version" in *clang*) label="Clang ($GCC driver)" ;; esac
  "$GCC" -O3 -std=c11 "$SOURCE_DIR/1-sortArray/c.c" -o "$BUILD_DIR/c.out" || return
  benchmark "$label — array sort (by reference)" "$BENCH_RUNS" \
    "$BUILD_DIR/c.out" "$SORT_ARRAY_ITR" "$BENCH_SEED" "$SORT_WARMUP"
}

gccWriteToFile() {
  local BENCH_HEADER_TITLE
  local BENCH_WORK_KIND=write
  benchmark_header "C / $GCC — buffer construction and file writing"
  require_tools "$GCC" || return 0
  local version label=GCC
  version=$("$GCC" --version) || return
  printf '%s\n' "$version"
  case "$version" in *clang*) label="Clang ($GCC driver)" ;; esac
  "$GCC" -O3 -std=c11 "$SOURCE_DIR/3-writeToFile/c3.c" -o "$BUILD_DIR/c3.out" || return
  benchmark "$label — buffer construction and file writing" "$BENCH_RUNS" \
    "$BUILD_DIR/c3.out" "$WRITE_FILE_LINES" "$WRITE_WARMUP_LINES"
}

gccSortGlobalArray() {
  local BENCH_HEADER_TITLE
  local BENCH_WORK_KIND=sort
  benchmark_header "C / $GCC — global array sort"
  require_tools "$GCC" || return 0
  local version label=GCC
  version=$("$GCC" --version) || return
  printf '%s\n' "$version"
  case "$version" in *clang*) label="Clang ($GCC driver)" ;; esac
  "$GCC" -O3 -std=c11 "$SOURCE_DIR/2-sortGlobalArray/c2.c" -o "$BUILD_DIR/c2.out" || return
  benchmark "$label — global array sort" "$BENCH_RUNS" \
    "$BUILD_DIR/c2.out" "$SORT_GLOBAL_ARRAY_ITR" "$BENCH_SEED" "$SORT_WARMUP"
}


# Clang ------------------------------------------------------------------------
clangSortArray() {
  local BENCH_HEADER_TITLE
  local BENCH_WORK_KIND=sort
  benchmark_header "Clang — array sort (by reference)"
  require_tools clang || return 0
  clang --version || return
  clang -O3 -std=c11 -Wall "$SOURCE_DIR/1-sortArray/clang.c" -o "$BUILD_DIR/clang.out" || return
  benchmark "Clang — array sort (by reference)" "$BENCH_RUNS" \
    "$BUILD_DIR/clang.out" "$SORT_ARRAY_ITR" "$BENCH_SEED" "$SORT_WARMUP"
}

clangWriteToFile() {
  local BENCH_HEADER_TITLE
  local BENCH_WORK_KIND=write
  benchmark_header "Clang — buffer construction and file writing"
  require_tools clang || return 0
  clang --version || return
  clang -O3 -std=c11 -Wall "$SOURCE_DIR/3-writeToFile/c3.c" -o "$BUILD_DIR/clang3.out" || return
  benchmark "Clang — buffer construction and file writing" "$BENCH_RUNS" \
    "$BUILD_DIR/clang3.out" "$WRITE_FILE_LINES" "$WRITE_WARMUP_LINES"
}

clangSortGlobalArray() {
  local BENCH_HEADER_TITLE
  local BENCH_WORK_KIND=sort
  benchmark_header "Clang — global array sort"
  require_tools clang || return 0
  clang --version || return
  clang -O3 -std=c11 -Wall "$SOURCE_DIR/2-sortGlobalArray/clang2.c" -o "$BUILD_DIR/clang2.out" || return
  benchmark "Clang — global array sort" "$BENCH_RUNS" \
    "$BUILD_DIR/clang2.out" "$SORT_GLOBAL_ARRAY_ITR" "$BENCH_SEED" "$SORT_WARMUP"
}

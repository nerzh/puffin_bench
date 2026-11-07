#!/usr/bin/env bash
# Shared runner mechanics. Language-specific build/run commands live in benchmarks.sh.

require_tools() {
  local tool
  for tool in "$@"; do
    if ! command -v "$tool" > /dev/null 2>&1; then
      printf 'SKIP: %s is not installed.\n' "$tool"
      return 1
    fi
  done
}

print_result() {
  if [[ -t 1 && -z ${NO_COLOR:-} && ${TERM:-dumb} != dumb ]]; then
    printf '\033[1m%s\033[0m\n' "$1"
  else
    printf '%s\n' "$1"
  fi
}

benchmark_header() {
  BENCH_HEADER_TITLE=$1
  printf '\n============================================================\n%s\n' "$1"
}

run_time() {
  /usr/bin/time "$@"
}

measure_run() {
  local platform=$1 timing_file=$2 format
  shift 2
  case "$platform" in
    Darwin)
      run_time -l -p -o "$timing_file" "$@"
      ;;
    Linux)
      format='real %e\nuser %U\nsys %S\n%M maximum resident set size'
      format+='\n%I block input operations\n%O block output operations'
      format+='\n%R page reclaims\n%F page faults\n%W swaps'
      format+='\n%w voluntary context switches\n%c involuntary context switches'
      run_time -f "$format" -o "$timing_file" "$@"
      ;;
  esac
}

resource_report() {
  local platform=$1 repeats=$2 rss_divisor
  shift 2
  case "$platform" in
    Darwin) rss_divisor=1048576 ;;
    Linux) rss_divisor=1024 ;;
    *) printf 'ERROR: unsupported platform: %s\n' "$platform" >&2; return 1 ;;
  esac
  LC_ALL=C awk -v expected="$repeats" -v rss_divisor="$rss_divisor" \
    -f "$BENCH_ROOT/scripts/resource-report.awk" "$@"
}

benchmark() (
  # A subshell keeps cwd, locale and cleanup traps out of the caller's shell.
  local title=$1 repeats=$2 timings workload report platform i status run_file
  shift 2
  if [[ ! $repeats =~ ^[1-9][0-9]*$ ]]; then
    printf 'ERROR: number of runs must be a positive integer: %s\n' "$repeats" >&2
    return 1
  fi

  cd "$BENCH_ROOT" || return
  export LC_ALL=C
  platform=$(uname -s) || return
  case "$platform" in
    Darwin|Linux) ;;
    *) printf 'ERROR: resource measurements require macOS or Linux.\n' >&2; return 1 ;;
  esac
  if [[ ! -x /usr/bin/time ]]; then
    printf 'ERROR: /usr/bin/time is required (Ubuntu/Debian: sudo apt install time).\n' >&2
    return 1
  fi
  timings=$(mktemp -d "${TMPDIR:-/tmp}/puffin-bench.XXXXXX") || return
  trap 'rm -rf "$timings"' EXIT
  mkdir "$timings/resources" "$timings/workloads" || return
  if [[ -z ${BENCH_HEADER_TITLE:-} ]]; then benchmark_header "$title"; fi

  for ((i = 0; i < repeats; i++)); do
    printf -v run_file "%012d" "$i"
    if measure_run "$platform" "$timings/resources/$run_file" "$@" > "$timings/workloads/$run_file"; then
      :
    else
      status=$?
      cat "$timings/workloads/$run_file" >&2
      printf 'ERROR: command or resource measurement for %s failed on run %s (exit %s).\n' "$title" "$((i + 1))" "$status" >&2
      return "$status"
    fi
  done

  if ! workload=$(LC_ALL=C awk -v expected="$repeats" -v work_kind="${BENCH_WORK_KIND:-}" -f "$BENCH_ROOT/scripts/workload-report.awk" "$timings/workloads/"*); then
    printf 'ERROR: invalid workload output or inconsistent checksums for %s.\n' "$title" >&2
    return 1
  fi
  if ! report=$(resource_report "$platform" "$repeats" "$timings/resources/"*); then
    printf 'ERROR: incomplete or invalid resource statistics for %s.\n' "$title" >&2
    return 1
  fi
  print_result "$workload"
  print_result "$report"
)

run_suite() {
  local title=$1 entry
  shift
  printf '\n\n############################################################\n%s\n############################################################\n' "$title"
  for entry in "$@"; do
    "$entry" || return
  done
}


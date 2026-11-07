# Parse BSD time -l -p and the matching GNU time format used by the runner.
# Validate every report before printing; missing counters must not become zeros.
BEGIN {
    required_count = split("real user sys rss input output minor major voluntary involuntary swaps", required, " ")
    names["maximum resident set size"] = "rss"
    names["block input operations"] = "input"
    names["block output operations"] = "output"
    names["page reclaims"] = "minor"
    names["page faults"] = "major"
    names["voluntary context switches"] = "voluntary"
    names["involuntary context switches"] = "involuntary"
    names["swaps"] = "swaps"
    names["instructions retired"] = "instructions"
    names["cycles elapsed"] = "cycles"
    names["peak memory footprint"] = "footprint"
}
FNR == 1 { files++ }
{
    if ($1 == "real" || $1 == "user" || $1 == "sys") {
        key = $1
        value = $2
        if (NF != 2 || value !~ /^[0-9]+([.][0-9]+)?$/) invalid = 1
    } else {
        label = $0
        sub(/^[[:space:]]*[^[:space:]]+[[:space:]]+/, "", label)
        sub(/[[:space:]]+$/, "", label)
        if (!(label in names)) next
        key = names[label]
        value = $1
        if (value !~ /^[0-9]+$/) invalid = 1
    }
    if (seen[files, key]++) invalid = 1
    values[files, key] = value + 0
}
END {
    if (files != expected || rss_divisor <= 0) invalid = 1
    for (i = 1; i <= files; i++) {
        for (j = 1; j <= required_count; j++) {
            if (!seen[i, required[j]]) invalid = 1
        }
    }
    if (invalid) exit 1

    for (i = 1; i <= files; i++) {
        if (files > 1) printf "Process statistics (run %d):\n", i
        elapsed = values[i, "real"]
        user = values[i, "user"]
        system_time = values[i, "sys"]
        cpu = user + system_time
        printf "Total process time: %.3f s.\n", elapsed
        if (elapsed > 0)
            printf "CPU usage: %.0f ms (%.1f%% of one core).\n", cpu * 1000, cpu / elapsed * 100
        else
            printf "CPU usage: %.0f ms (percentage unavailable: elapsed time rounded to zero).\n", cpu * 1000
        if (seen[i, "cycles"]) printf "CPU cycles: %.0f.\n", values[i, "cycles"]
        printf "Peak RAM: %.2f MiB.\n", values[i, "rss"] / rss_divisor
        printf "Context switches: %.0f voluntary; %.0f involuntary.\n", values[i, "voluntary"], values[i, "involuntary"]
    }
}

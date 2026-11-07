# Strict, portable awk parser for the one-line payload protocol.
# No GNU awk extensions: macOS ships a different awk.
FNR == 1 { files++ }
{
    if (FNR != 1 || NF != 3) { invalid = 1; next }
    split($1, timing, "="); split($2, result, "="); split($3, warmup, "=")
    if ($1 !~ /^elapsed_ns=[0-9]+$/ ||
        $2 !~ /^(checksum|bytes)=[0-9]+$/ ||
        $3 !~ /^(warmup_checksum|warmup_bytes)=[0-9]+$/ ||
        warmup[1] != "warmup_" result[1]) { invalid = 1; next }
    if (NR == 1) { kind = result[1]; check = result[2]; warm = warmup[2] }
    if (kind != result[1] || check != result[2] || warm != warmup[2]) invalid = 1
    value = timing[2] / 1000000000
    samples[++n] = value
}
END {
    if (invalid || files != expected || n != expected) exit 1
    if (work_kind == "sort")
        label = "Total sorting time"
    else if (work_kind == "small_string")
        label = "Total small string push back time"
    else if (work_kind == "append_base")
        label = "Total append with base time"
    else
        label = "Total buffer and file writing time"
    if (n == 1) {
        printf "%s: %.6f s.\n", label, samples[1]
    } else {
        for (i = 1; i <= n; i++) printf "%s (run %d): %.6f s.\n", label, i, samples[i]
    }
}

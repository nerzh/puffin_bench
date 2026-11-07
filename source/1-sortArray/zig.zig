const std = @import("std");
const libc = std.c;

fn nowNS() !i64 {
    var ts: libc.timespec = undefined;
    if (libc.clock_gettime(.MONOTONIC, &ts) != 0) return error.ClockFailed;
    return @as(i64, @intCast(ts.sec)) * 1000000000 + @as(i64, @intCast(ts.nsec));
}
fn argument(args: []const [:0]const u8, index: usize, fallback: i64) !i64 {
    if (args.len <= index) return fallback;
    const value = try std.fmt.parseInt(i64, args[index], 10);
    if (value < 0 or value > 2147483647) return error.InvalidArgument;
    return value;
}
fn shellsSort(arr: []i64) void {
    var gap: usize = arr.len / 2;
    while (gap > 0) {
        var i = gap;
        while (i < arr.len) {
            const temp = arr[i];
            var j = i;
            while (j >= gap and arr[j - gap] > temp) {
                arr[j] = arr[j - gap];
                j = j - gap;
            }
            arr[j] = temp;
            i = i + 1;
        }
        gap = gap / 2;
    }
}
fn run(arr: *[100]i64, iterations: i64, seed: i64) i64 {
    var state = seed;
    var checksum: i64 = 0;
    var c: i64 = 0;
    while (c < iterations) {
        var k: usize = 0;
        while (k < arr.len) {
            state = (state * 1664525 + 1013904223) & 2147483647;
            arr[k] = (state >> 8) & 65535;
            k = k + 1;
        }
        shellsSort(arr);
        k = 0;
        while (k < arr.len) {
            checksum = (checksum * 31 + arr[k]) & 2147483647;
            k = k + 1;
        }
        c = c + 1;
    }
    return checksum;
}
pub fn main(init: std.process.Init) !void {
    const args = try init.minimal.args.toSlice(init.arena.allocator());
    if (args.len < 2 or args.len > 4) return error.ExpectedIterationsSeedWarmup;
    const iterations = try argument(args, 1, 0);
    const seed = try argument(args, 2, 12345);
    const warmup = try argument(args, 3, 10000);
    var arr: [100]i64 = @splat(0);
    const warmup_checksum = run(&arr, warmup, seed);
    const start = try nowNS();
    const checksum = run(&arr, iterations, seed);
    const elapsed = (try nowNS()) - start;
    _ = libc.printf("elapsed_ns=%lld checksum=%lld warmup_checksum=%lld\n", @as(c_longlong, elapsed), @as(c_longlong, checksum), @as(c_longlong, warmup_checksum));
}

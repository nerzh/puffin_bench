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
fn buildBuffer(allocator: std.mem.Allocator, iterations: usize) !std.ArrayList(u8) {
    const template = "test_text\n";
    var result: std.ArrayList(u8) = .empty;
    errdefer result.deinit(allocator);
    var count: usize = 0;
    while (count < iterations) {
        try result.appendSlice(allocator, template);
        count = count + 1;
    }
    return result;
}
fn run(io: std.Io, iterations: usize) !usize {
    const allocator = std.heap.c_allocator;
    var result = try buildBuffer(allocator, iterations);
    defer result.deinit(allocator);
    const file = try std.Io.Dir.cwd().createFile(io, "./store/zig.txt", .{ .truncate = true });
    defer file.close(io);
    try file.writeStreamingAll(io, result.items);
    return result.items.len;
}
pub fn main(init: std.process.Init) !void {
    const args = try init.minimal.args.toSlice(init.arena.allocator());
    if (args.len > 3) return error.ExpectedLinesWarmup;
    const iterations: usize = @intCast(try argument(args, 1, 80000000));
    const warmup: usize = @intCast(try argument(args, 2, 10000));
    const warmup_bytes = try run(init.io, warmup);
    const start = try nowNS();
    const bytes = try run(init.io, iterations);
    const elapsed = (try nowNS()) - start;
    _ = libc.printf("elapsed_ns=%lld bytes=%llu warmup_bytes=%llu\n", @as(c_longlong, elapsed), @as(c_ulonglong, bytes), @as(c_ulonglong, warmup_bytes));
}

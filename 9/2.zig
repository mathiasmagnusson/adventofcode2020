const std = @import("std");

fn print(comptime format: []const u8, args: anytype) !void {
    try std.io.getStdOut().writer().print(format, args);
}

fn nextInt(reader: std.io.Reader(std.fs.File, std.os.ReadError, std.fs.File.read)) !?u64 {
    var line: [64]u8 = undefined;
    var sub: ?[]u8 = null;
    for (line) |*byte, j| {
        byte.* = reader.readByte() catch |err| switch (err) {
            error.EndOfStream => return null,
            else => return err,
        };
        if (byte.* == '\n') {
            sub = line[0..j];
            break;
        }
    }

    if (sub) |sub_| {
        return try std.fmt.parseUnsigned(u64, sub_, 10);
    } else {
        return null;
    }
}

pub fn main() !void {
    const allocator = std.heap.page_allocator;

    const wantedSum = 18_272_118; // answer from part 1

    const file = try std.fs.cwd().openFile("in", .{ .read = true });
    const reader = file.reader();
    defer file.close();

    var i: u64 = 0;
    var values = [_]u64{0} ** 1000;
    while (try nextInt(reader)) |val| {
        values[i] = val;
        i += 1;
    }

    for (values) |start, startI| {
        var endI = startI + 1;
        while (endI < values.len) {
            var end = values[endI];
            // try print("{} .. {}\n", .{ startI, endI + 1 });
            var sum: u64 = 0;
            for (values[startI .. endI + 1]) |v| {
                sum += v;
            }
            if (sum == wantedSum) {
                var smallest: u64 = std.mem.min(u64, values[startI .. endI + 1]);
                var biggest: u64 = std.mem.max(u64, values[startI .. endI + 1]);
                try print("{}\n", .{smallest + biggest});
            }
            endI += 1;
        }
    }
}

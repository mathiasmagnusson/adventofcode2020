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

    const length = 25;

    var current = [_]u64{0} ** length;
    var sums = std.AutoHashMap(u64, u64).init(allocator);
    defer sums.deinit();

    const file = try std.fs.cwd().openFile("in", .{ .read = true });
    const reader = file.reader();
    defer file.close();

    var i: u64 = 0;
    while (i < length) {
        current[i] = (try nextInt(reader)) orelse return;
        var j: u64 = 0;
        while (j < i) {
            var sum = current[i] + current[j];
            if (sums.remove(sum)) |old| {
                try sums.put(sum, old.value + 1);
            } else {
                try sums.put(sum, 1);
            }
            j += 1;
        }
        i += 1;
    }

    // var iter = sums.iterator();
    // while (iter.next()) |sum| {
    //     try print("{}\n", .{sum});
    // }

    i = 0;
    while (try nextInt(reader)) |curr| {
        if (sums.get(curr) == null) {
            // var sumsIter = sums.iterator();
            // while (sumsIter.next()) |sum| {
            //     try print("{}\n", .{sum});
            // }
            try print("{}\n", .{curr});
            return;
        }

        var j: u64 = 0;
        while (j < length) {
            if (i == j) {
                j += 1;
                continue;
            }

            const sum = current[i] + current[j];
            // try print("- {} at curr = {} because its {} + ({} = current[{}])\n", .{ sum, curr, current[i], current[j], j });
            if (sums.getEntry(sum)) |entry| {
                entry.value -= 1;
                if (entry.value == 0) {
                    sums.removeAssertDiscard(sum);
                }
            } else {
                // try print("tried removing non existent {} at curr = {}\n", .{ sum, curr });
            }

            const newSum = curr + current[j];
            // try print("+ {} at curr = {} because its {} + ({} = current[{}])\n", .{ newSum, curr, curr, current[j], j });
            if (sums.getEntry(newSum)) |entry| {
                entry.value += 1;
            } else {
                try sums.put(newSum, 1);
            }

            j += 1;
        }

        current[i] = curr;

        i += 1;
        if (i == length) i = 0;
    }
}

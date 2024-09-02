const std = @import("std");
const ArrayList = std.ArrayList;

pub fn main() !void {
    var file = try std.fs.cwd().openFile("day12.txt", .{});
    defer file.close();

    var buf_reader = std.io.bufferedReader(file.reader());
    var in_stream = buf_reader.reader();

    var buf: [1024]u8 = undefined;
    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        try traceCounter(line);
    }
}

pub fn traceCounter(line: []const u8) !void {
    var it = std.mem.split(u8, line, " ");
    var machines: []const u8 = undefined;
    var criterias: []const u8 = undefined;

    var x:u8 = 0;
    while (it.next()) |data| {
        if (x == 0) {
            machines = data;
        } else if (x == 1) {
            criterias = data;
        }
        x += 1;
    }
    const criterias_final = criteriasMaker(criterias);

    std.debug.print("{s}\n", .{machines});
    const stdout = std.io.getStdOut().writer();
    try stdout.print("{any}\n", .{criterias_final});
}

fn criteriasMaker(criterias: []const u8) ![]i32 {
    var allocator = std.heap.page_allocator;
    var it = std.mem.split(u8, criterias, ",");
    var len:u8 = 0;
    while (it.next() != null) {
        len += 1;
    }
    var result = try allocator.alloc(i32, len);
    it.index = 0;
    // Fill the result array with parsed integers
    var index: usize = 0;
    while (it.next()) |token| {
        const maybe_num = try std.fmt.parseInt(i32, token, 10);
        result[index] = maybe_num;
        index += 1;
    }
    return result; 
}

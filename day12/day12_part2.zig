const std = @import("std");
const ArrayList = std.ArrayList;

pub fn main() !void {
    var file = try std.fs.cwd().openFile("day12.txt", .{});
    defer file.close();

    var buf_reader = std.io.bufferedReader(file.reader());
    var in_stream = buf_reader.reader();

    var buf: [1024]u8 = undefined;
    var counter: i32 = 0;
    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        const value = try traceCounter(line);
        counter += value;
    }
    std.debug.print("{any}\n", .{counter});
}

fn traceCounter(line: []const u8) !i32 {
    var it = std.mem.split(u8, line, " ");
    var allocator = std.heap.page_allocator;

    var machines: []u8 = undefined;
    var criterias: []const u8 = undefined;

    var x: u8 = 0;
    while (it.next()) |data| {
        if (x == 0) {
            machines = try allocator.alloc(u8, data.len * 5 + 5);
            var literal_index: u8 = 0;
            for (0..5) |_| {
                for (0..data.len) |i| {
                    machines[literal_index] = data[i];
                    literal_index += 1;
                }
                machines[literal_index] = '?'; 
                literal_index += 1;
            }
            machines = machines[0..machines.len - 1];
        } else if (x == 1) {
            criterias = data;
        }
        x += 1;
    }
    const criterias_final = criteriasMaker(criterias);
    std.debug.print("{s} {any}\n", .{machines, criterias_final});
    const counter: i32 = 0;
    return counter;
}
fn array_contains(comptime T: type, haystack: []const T, needle: T) bool {
    for (haystack) |element|
        if (element == needle)
            return true;
    return false;
}
fn checkValidate(machines: []const u8) !bool {
    var list_check = ArrayList(u8).init(std.heap.page_allocator);
    defer list_check.deinit();
    var index: u8 = 0;
    while (index < machines.len) : (index += 1) {
        if (machines[index] == '#') {
            return false;
        }
    }

    return true;
}

fn criteriasMaker(criterias: []const u8) ![]u8 {
    var allocator = std.heap.page_allocator;
    var it = std.mem.split(u8, criterias, ",");
    var len: u8 = 0;
    while (it.next() != null) {
        len += 1;
    }
    var result = try allocator.alloc(u8, len * 5);
    it.index = 0;
    // Fill the result array with parsed integers
    var index: usize = 0;
    for (0..5) |_| {
        while (it.next()) |token| {
            const maybe_num = try std.fmt.parseInt(u8, token, 10);
            result[index] = maybe_num;
            index += 1;
        }
        it.index = 0;
    }
    return result;
}

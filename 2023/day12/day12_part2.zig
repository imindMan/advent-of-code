const std = @import("std");
const ArrayList = std.ArrayList;

const CacheKey = struct {
    start: u8,
    s: usize,
    c: usize,
};

var cache: std.AutoHashMap(CacheKey, usize) = undefined;

pub fn main() !void {
    var file = try std.fs.cwd().openFile("day12.txt", .{});
    const allocator = std.heap.page_allocator;
    defer file.close();

    var buf_reader = std.io.bufferedReader(file.reader());
    var in_stream = buf_reader.reader();

    var buf: [1024]u8 = undefined;
    var counter: usize = 0;
    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        var it = std.mem.split(u8, line, " ");

        var machines: []const u8 = undefined;
        var criterias: []const u8 = undefined;

        var x: u8 = 0;
        while (it.next()) |data| {
            if (x == 0) {
                machines = data;
            } else if (x == 1) {
                criterias = data;
            }
            x += 1;
        }
        const machines_final = try machinesMaker(machines);
        const criterias_final = try criteriasMaker(criterias);

        cache = std.AutoHashMap(CacheKey, usize).init(allocator);
        defer cache.deinit();
        counter += try count(machines_final, criterias_final);
    }
    std.debug.print("{any}\n", .{counter});
}

fn count(spring: []const u8, config: []usize) !usize {
    if (spring.len == 0) {
        if (config.len == 0) {
            return 1;
        }
        return 0;
    }
    if (config.len == 0) {
        if (contains('#', spring) == true) {
            return 0;
        }
        return 1;
    }

    var result: usize = 0;

    const key = CacheKey{
        .start = spring[0],
        .s = spring.len,
        .c = config.len,
    };

    const cached = cache.get(key);
    if (cached != null) {
        return cached.?;
    }

    if (spring[0] == '.' or spring[0] == '?') {
        result += try count(spring[1..], config);
    }

    if (spring[0] == '#' or spring[0] == '?') {
        if (config[0] <= spring.len and contains('.', spring[0..config[0]]) == false and (config[0] == spring.len or spring[config[0]] != '#')) {
            if (config[0] == spring.len) {
                result += try count(spring[config[0]..], config[1..]);
            } else {
                result += try count(spring[config[0] + 1 ..], config[1..]);
            }
        }
    }
    cache.put(key, result) catch unreachable;

    return result;
}

fn contains(needle: u8, haystack: []const u8) bool {
    for (haystack) |c| {
        if (c == needle) {
            return true;
        }
    }
    return false;
}


fn criteriasMaker(criterias: []const u8) ![]usize {
    var allocator = std.heap.page_allocator;
    var it = std.mem.split(u8, criterias, ",");
    var len: u8 = 0;
    while (it.next() != null) {
        len += 1;
    }
    var result = try allocator.alloc(usize, len * 5);
    it.index = 0;
    // Fill the result array with parsed integers
    var index: usize = 0;
    for (0..5) |_| {
        while (it.next()) |token| {
            const maybe_num = try std.fmt.parseInt(usize, token, 10);
            result[index] = maybe_num;
            index += 1;
        }
        it.index = 0;
    }
    return result;
}

fn machinesMaker(machines: []const u8) ![]const u8 {
    const allocator = std.heap.page_allocator;
    var new_machines = try allocator.alloc(u8, machines.len * 5 + 5);
    var literal_index: u8 = 0;
    for (0..5) |_| {
        for (0..machines.len) |i| {
            new_machines[literal_index] = machines[i];
            literal_index += 1;
        }
        new_machines[literal_index] = '?';
        literal_index += 1;
    }

    const return_machines: []const u8 = new_machines[0 .. new_machines.len - 1];

    return return_machines;
}

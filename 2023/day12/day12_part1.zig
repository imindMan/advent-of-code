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
    const criterias_final = criteriasMaker(criterias);
    var counter: i32 = 0;
    try possibleCase(try criterias_final, machines, 0, 0, &counter);
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

fn possibleCase(criterias: []u8, current_machine: []const u8, index_criteria: u8, index_machine: i8, counter: *i32) !void {
    const index_parse: u8 = @bitCast(index_machine);
    if (index_parse >= current_machine.len) {
        return;
    }
    var list_check = ArrayList(i8).init(std.heap.page_allocator);
    defer list_check.deinit();

    for (index_parse..current_machine.len) |track_index| {
        var pass_: bool = true;
        const track_index_parse: i8 = @intCast(track_index);
        const pos = try move(track_index_parse, criterias[index_criteria], current_machine);

        if (array_contains(i8, list_check.items, pos) == false) {
            if (index_criteria == criterias.len -% 1 and pos != -1) {
                const pos_parse: u8 = @bitCast(pos);
                const pos_parse_check: u8 = @bitCast(pos - 1);
                pass_ = try checkValidate(current_machine[index_parse .. pos_parse_check -% criterias[index_criteria]]);
                if (pass_ == true) {
                    if (pos_parse < current_machine.len) {
                        const chunks = try checkValidate(current_machine[pos_parse..current_machine.len]);
                        if (chunks == true) {
                            try list_check.append(pos);
                            counter.* += 1;
                        }
                    } else {
                        try list_check.append(pos);
                        counter.* += 1;
                    }
                }
            } else if (pos != -1) {
                const pos_parse: u8 = @bitCast(pos - 1);

                pass_ = try checkValidate(current_machine[index_parse .. pos_parse -% criterias[index_criteria]]);
                if (pass_ == true) {
                    try list_check.append(pos);
                    try possibleCase(criterias, current_machine, index_criteria +% 1, pos, counter);
                }
            }
        }
    }
    return;
}

fn move(position: i8, chars: u8, line: []const u8) !i8 {
    var pos_check: u8 = @bitCast(position);
    if (pos_check >= line.len) {
        return -1;
    }
    while (line[pos_check] == '.') {
        if (pos_check == line.len - 1) {
            return -1;
        }
        pos_check += 1;
    }

    var counter_check: u8 = 0;
    // move backward
    if (line[pos_check] != '.' and pos_check > 0) {
        if (line[pos_check -% 1] == '#') {
            pos_check -%= 1;
            while (pos_check != 255) {
                if (line[pos_check] == '#') {
                    pos_check -%= 1;
                } else {
                    break;
                }
            }
            if (pos_check == 255) {
                pos_check = 0;
            } else {
                pos_check +%= 1;
            }
        }
    }

    if (pos_check +% chars - 1 >= line.len) {
        return -1;
    }

    var pass_hash = false;
    while (counter_check != chars) : (pos_check += 1) {
        if (pos_check == line.len) {
            break;
        }
        if (line[pos_check] == '#') {
            pass_hash = true;
        }

        if (line[pos_check] == '.' and pass_hash == false) {
            counter_check = 0;
        } else if (line[pos_check] == '.' and pass_hash == true) {
            return -1;
        } else {
            counter_check += 1;
        }
    }
    if (counter_check == chars) {
        if (pos_check < line.len) {
            if (line[pos_check] == '#') {
                if (counter_check == 1) {
                    return -1;
                }
                if (pos_check + 1 >= line.len) {
                    return @intCast(line.len +% 1);
                } else {
                    var counter_hash: u8 = 0;
                    pos_check += 1;
                    while (pos_check < line.len) : (pos_check += 1) {
                        if (line[pos_check] == '#') {
                            counter_hash += 1;
                        } else if (line[pos_check] == '.' or line[pos_check] == '?') {
                            break;
                        }
                    }
                    if (counter_hash <= chars and pos_check + 1 <= line.len + 1) {
                        return @intCast(pos_check + 1);
                    } else {
                        return -1;
                    }
                }
            }
        }
        if (pos_check + 1 > line.len + 1) {
            return -1;
        } else {
            return @intCast(pos_check + 1);
        }
    }
    return -1;
}

fn criteriasMaker(criterias: []const u8) ![]u8 {
    var allocator = std.heap.page_allocator;
    var it = std.mem.split(u8, criterias, ",");
    var len: u8 = 0;
    while (it.next() != null) {
        len += 1;
    }
    var result = try allocator.alloc(u8, len);
    it.index = 0;
    // Fill the result array with parsed integers
    var index: usize = 0;
    while (it.next()) |token| {
        const maybe_num = try std.fmt.parseInt(u8, token, 10);
        result[index] = maybe_num;
        index += 1;
    }
    return result;
}

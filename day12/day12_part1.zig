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

fn traceCounter(line: []const u8) !void {
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
    std.debug.print("{any}\n", .{criterias_final}); 
    
    var value: i32 = 0;
    for (try criterias_final) |chars| {
        const char_int: i32 = @as(i32, chars);
        value = move(value, char_int, machines);
    }

    std.debug.print("{any}\n", .{value});
}

fn move(position: i32, chars: i32, line: []const u8) i32 {
   if (position + chars - 1 >= line.len) {
        return -1;
   }
   var pos_check: u8 = @as(usize, position - 1);
   // check if there's any prev trailing characters
   if (pos_check >= 0 and line[pos_check] == '#') {
       while (position >= 0 and line[position] != '.') {
          pos_check -= 1;
       }
       pos_check += 1;
   } else {
        pos_check = @as(usize, position);
   }
   for (pos_check..(pos_check + chars - 1)) |index| {
       if (line[index] == '.') {
            return -1;
       }
   }
   // check if there's any behind trailing characters
   if (pos_check + chars < line.len and line[pos_check + chars] == '#') {
      return -1;
   }
   
   return position + chars;
}

fn criteriasMaker(criterias: []const u8) ![]u8 {
    var allocator = std.heap.page_allocator;
    var it = std.mem.split(u8, criterias, ",");
    var len:u8 = 0;
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

const std = @import("std");

const Vector = struct {
    capacity: usize,
    size: usize,
    data: []i64,
};

pub fn create_vec() !Vector {
    var vec: Vector = undefined;
    vec.capacity = 10;
    vec.size = 0;
    vec.data = try std.heap.page_allocator.alloc(i64, vec.capacity);

    return vec;
}

pub fn push(vec: *Vector, num: i64) !void {
    if (vec.size >= vec.capacity) {
        const new_capacity = vec.capacity * 2;
        const new_data = try std.heap.page_allocator.alloc(i64, new_capacity);

        for (0..vec.size) |i| {
            new_data[i] = vec.data[i];
        }

        std.heap.page_allocator.free(vec.data);

        vec.data = new_data;
        vec.capacity = new_capacity;
    }
    vec.data[vec.size] = num;
    vec.size += 1;
}

pub fn main() !void {
    var vec: Vector = try create_vec();
    defer std.heap.page_allocator.free(vec.data);
    var i: i64 = 1;

    while (i <= 50) {
        try push(&vec, i * i);
        i += 1;
    }

    std.debug.print("{}\n", .{vec.data[49]});
}

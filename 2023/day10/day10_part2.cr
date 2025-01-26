file = File.read_lines("day10.txt")

def move(instruction, map, x, y)
  check_length = map[0].size
  if instruction == "left" && y - 1 < 0 ||
     instruction == "right" && y + 1 > check_length - 1 ||
     instruction == "top" && x - 1 < 0 ||
     instruction == "bottom" && x + 1 > map.size - 1
    {-1, -1}
  elsif instruction == "left" && ['-', 'J', '7', 'S'].includes?(map[x][y]) && ['-', 'F', 'L'].includes?(map[x][y - 1])
    {x, y - 1}
  elsif instruction == "right" && ['-', 'F', 'L', 'S'].includes?(map[x][y]) && ['-', 'J', '7'].includes?(map[x][y + 1])
    {x, y + 1}
  elsif instruction == "top" && ['|', 'L', 'S', 'J'].includes?(map[x][y]) && ['|', 'F', '7'].includes?(map[x - 1][y])
    {x - 1, y}
  elsif instruction == "bottom" && ['|', '7', 'F', 'S'].includes?(map[x][y]) && ['|', 'L', 'J'].includes?(map[x + 1][y])
    {x + 1, y}
  else
    {-1, -1}
  end
end

def can_still_move(map, x, y)
  left_pos = move("left", map, x, y)
  right_pos = move("right", map, x, y)
  top_pos = move("top", map, x, y)
  bottom_pos = move("bottom", map, x, y)
  return left_pos != {-1, -1} || right_pos != {-1, -1} || top_pos != {-1, -1} || bottom_pos != {-1, -1}
end

# Now come the backtracking part

def check_animal_position(map)
  col = 0
  row = 0
  while row < map.size
    while col < map[0].size
      if map[row][col] == 'S'
        ["left", "right", "top", "bottom"].each do |instruction|
          input = move(instruction, map, row, col)
          if input != {-1, -1}
            row = input[0]
            col = input[1]
            break
          end
        end
        return {row, col}
      end
      col += 1
    end
    col = 0
    row += 1
  end
  # it's still possible to check if the position doesn't change, but this function is based on the input so :)
  return {row, col}
end

def step_to_s(map, path_records, x, y)
  if map[x][y] == 'S' || !can_still_move(map, x, y)
    return path_records
  end
  ["left", "right", "top", "bottom"].each do |instruction|
    step = move(instruction, map, x, y)
    if step != {-1, -1} && !path_records.includes?(step)
      path_records << step
      step_two = step_to_s(map, path_records, step[0], step[1])
      path_records + step_two
    end
  end
  return path_records
end

pos_to_check = check_animal_position(file)
path_records = [pos_to_check] of Tuple(Int32, Int32)
final = step_to_s(file, path_records, pos_to_check[0], pos_to_check[1])

# plan: even-odd rule or maybe a simple hack like Pick's theorem and Shoelace formula
# but seems like even-odd rule would be easier to implement so I picked it

def is_point_in_path(x, y, poly)
  c = false
  i = 0
  while i < poly.size
    ax, ay = poly[i]
    bx, by = poly[i - 1]
    if (x == ax) && (y == ay)
      return true
    end
    if (ay > y) != (by > y)
      slope = (x - ax) * (by - ay) - (bx - ax) * (y - ay)
      if slope == 0
        # point is on boundary
        return true
      end
      if (slope < 0) != (by < ay)
        c = !c
      end
    end
    i += 1
  end
  return c
end

def counter_inner_position(map, poly)
  col = 0
  row = 0
  str_to_print = ""
  counter = 0
  while row < map.size
    while col < map[0].size
      if is_point_in_path(row, col, poly) && !poly.includes?({row, col}) && map[row][col] != 'S'
        counter += 1
        str_to_print += 'I'
      else
        str_to_print += map[row][col]
      end
      col += 1
    end
    str_to_print += '\n'
    col = 0
    row += 1
  end
  return counter
end

p! counter_inner_position(file, final)

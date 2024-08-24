# the plan is to use some backtracking to solve
# | is a vertical pipe connecting north and south.
# - is a horizontal pipe connecting east and west.
# L is a 90-degree bend connecting north and east.
# J is a 90-degree bend connecting north and west.
# 7 is a 90-degree bend connecting south and west.
# F is a 90-degree bend connecting south and east.
# . is ground; there is no pipe in this tile.
# S is the starting position of the animal; there is a pipe on this tile, but your sketch doesn't show what shape the pipe has.

file = File.read_lines("day10.txt")

def move(instruction, map, x, y)
  check_length = map[0].size
  if instruction == "left" && y - 1 < 0
    {-1, -1}
  elsif instruction == "right" && y + 1 > check_length - 1
    {-1, -1}
  elsif instruction == "top" && x - 1 < 0
    {-1, -1}
  elsif instruction == "bottom" && x + 1 > map.size - 1
    {-1, -1}
  end
  case instruction
  when "left"
    case map[x][y]
    when '-', 'J', '7', 'S'
      if map[x][y - 1] == '-' || map[x][y - 1] == 'F' || map[x][y - 1] == 'L'
        {x, y - 1}
      else
        {-1, -1}
      end
    else
      {-1, -1}
    end
  when "right"
    case map[x][y]
    when '-', 'F', 'L', 'S'
      if map[x][y + 1] == '-' || map[x][y + 1] == 'J' || map[x][y + 1] == '7'
        {x, y + 1}
      else
        {-1, -1}
      end
    else
      {-1, -1}
    end
  when "top"
    case map[x][y]
    when '|', 'L', 'S', 'J'
      if map[x - 1][y] == '|' || map[x - 1][y] == 'F' || map[x - 1][y] == '7'
        {x - 1, y}
      else
        {-1, -1}
      end
    else
      {-1, -1}
    end
  when "bottom"
    case map[x][y]
    when '|', '7', 'F', 'S'
      if map[x + 1][y] == '|' || map[x + 1][y] == 'L' || map[x + 1][y] == 'J'
        {x + 1, y}
      else
        {-1, -1}
      end
    else
      {-1, -1}
    end
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
  while row != map.size - 1
    while col != map[0].size - 1
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
  # it's still possible to check if the position doesn't change, but this function is based on the input so :9)
  return {row, col}
end

def step_to_s(map, path_records, x, y)
  if map[x][y] == 'S'
    return path_records
  elsif !can_still_move(map, x, y)
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
p! (step_to_s(file, path_records, pos_to_check[0], pos_to_check[1]).size + 1) / 2

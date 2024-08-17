
file = File.open("day8.txt")

instructions = file.readline
patterns = file.read.scan(/([A-Z]+) = \(([A-Z]+), ([A-Z]+)\)/)

places_hash = Hash.new

places_start = Array.new

patterns.each do |pattern|
  if pattern[0][2] == 'A'
    places_start.append(pattern[0])
  end
  places_hash[pattern[0]] = [pattern[1], pattern[2]]


end

step = 0
place_path_records = Array.new 

places_start.each do |place|
  final = place
  while final[2] != 'Z' 
   instructions.chop.split("").each do |instruction|
     case instruction
     when "R"
       final = places_hash[final][1]
     when "L"
       final = places_hash[final][0]
     end
     step += 1
   end
  end 
  place_path_records.append(step)
  step = 0
end

puts place_path_records.reduce(1, :lcm)

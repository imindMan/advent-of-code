function parseLine(line)
	local table_record = {}
	local i = 1
	for token in string.gmatch(string.sub(line, 12, string.len(line)), "[^%s]+") do
		table_record[i] = tonumber(token)
		i = i + 1
	end
	return table_record
end

-- A very weird way to parse everything into a tables to do stuff
data = {}
file = io.open("day6.txt", "r")
i = 1
for line in file:lines() do
	data[i] = parseLine(line)
	i = i + 1
end

raw_data = {}
index = 1
while index <= #data[1] do
	raw_data[data[1][index]] = data[2][index]
	index = index + 1
end

-- (Quite happy about this solution)
-- What's crazy about this solution is here. The problem description tend to let
-- you think that you have to parse each every single instances, but it's not in the case
-- that approach will cost a lot of time and space (approx. O(n^2) time complexity)
-- that's not good, so to cost down into O(n) (which is amazingly O(1) for each every instance)
-- we just need to solve the simple inequality to get the range
-- call t is time, d is record distance, x is the difference between the goal checking value and the t,
-- based on the description of the problem
-- we'll have the equation: x(t - x) > d
-- turns out, it's x^2 - xt + d < 0. Solve this, we have t - delta / 2 < x < t + delta / 2.
-- with some smart rounding, we will have the final solution
res = 1
index = 1
while index <= #data[1] do
	t = data[1][index]
	d = raw_data[t]
	delta = t * t - 4 * d
	low = (t - math.sqrt(delta)) / 2
	if math.floor(low) == low then
		-- integer
		low = math.ceil(low + 1)
	else
		low = math.floor(low)
	end
	res = res * (math.floor((t + math.sqrt(delta)) / 2) - low)
	index = index + 1
end
print(res)

file:close()

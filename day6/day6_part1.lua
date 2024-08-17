function parseLine(line)
	local table_record = {}
	local i = 1
	for token in string.gmatch(string.sub(line, 12, string.len(line)), "[^%s]+") do
		table_record[i] = tonumber(token)
		i = i + 1
	end
	return table_record
end

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

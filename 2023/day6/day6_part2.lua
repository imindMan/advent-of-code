function parseLine(line)
	local table_record = {}
	local i = 1
	for token in string.gmatch(string.sub(line, 12, string.len(line)), "[^%s]+") do
		table_record[i] = tonumber(token)
		i = i + 1
	end
	return table_record
end

-- same thing, but O(1) only

data = {}
file = io.open("day6.txt", "r")
i = 1
for line in file:lines() do
	data[i] = parseLine(line)
	i = i + 1
end

index = 1
time = ""
distance = ""
while index <= #data[1] do
	time = time .. data[1][index]
	distance = distance .. data[2][index]
	index = index + 1
end
t = tonumber(time)
d = tonumber(distance)

delta = t * t - 4 * d
low = (t - math.sqrt(delta)) / 2
if math.floor(low) == low then
	-- integer
	low = math.ceil(low + 1)
else
	low = math.floor(low)
end
res = math.floor((t + math.sqrt(delta)) / 2) - low
print(res)

file:close()

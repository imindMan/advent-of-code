f = open("day1.txt")

left_list = []
right_list = []

for line in f:
    l = list(map(int, line.split("   ")))
    left_list.append(l[0])
    right_list.append(l[1])

count = 0

for i in left_list:
    count += i * right_list.count(i)

print(count)

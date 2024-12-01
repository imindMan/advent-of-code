f = open("day1.txt")

left_list = []
right_list = []

for line in f:
    l = list(map(int, line.split("   ")))
    left_list.append(l[0])
    right_list.append(l[1])

left_list.sort()
right_list.sort()

count = 0

while len(left_list) > 0 and len(right_list) > 0:
    count += abs(min(left_list) - min(right_list))
    left_list.remove(min(left_list))
    right_list.remove(min(right_list))


print(count)

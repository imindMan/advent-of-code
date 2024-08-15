def smallest_bounding(data_input, node):
    title_list = [
            "seed-to-soil map:\n", 
            "soil-to-fertilizer map:\n", 
            "fertilizer-to-water map:\n", 
            "water-to-light map:\n", 
            "light-to-temperature map:\n", 
            "temperature-to-humidity map:\n", 
            "humidity-to-location map:\n"
        ]

    last_check_map = ""
    current_map = ""
    bound = None 

    check_range = []

    last_des = 0
    des = node
    for i in range(len(data_input) - 1):
        if data_input[i] == '\n':
            continue
        if data_input[i] in title_list:
            current_map = data_input[i]
        else:
            data = list(map(int, data_input[i].split(" ")))
            destination_source = data[0]

            range_source= data[1]
            range_ = data[2]
            if (range_source <= des <= range_source + range_ - 1) and (current_map != last_check_map):
                check_range.clear()
                if bound is None:
                    bound = range_source + range_ - 1 - des
                else:
                    bound = min(bound, range_source + range_ - 1 - des)
                last_des = des
                last_check_map = current_map
                check_range.append(range_source)
                check_range.append(range_source + range_ - 1)
                des = destination_source + (des - range_source)
            elif i + 2 < len(data_input) and data_input[i] in title_list and last_des == des:
                check_range.append(des)
                check_range.sort()
                if bound is None:
                    bound = check_range[check_range.index(des) + 1] - check_range[check_range.index(des)]
                else:
                    bound = min(bound, check_range[check_range.index(des) + 1] - check_range[check_range.index(des)])
                check_range.clear()

    if bound is None or bound == 0:
        bound = 1
    return des, bound

with open("day5.txt", encoding="utf-8") as f:
    seeds = list(map(int, f.readline()[7:].split(" ")))
    data_parsing = f.readlines()[1:]

    i = 0
    des_res = None 

    while i < len(seeds):
        tracing_value, min_bounding = smallest_bounding(data_parsing, seeds[i])
        if des_res is None:
            des_res = tracing_value
        else:
            des_res = min(des_res, tracing_value)
        seeds[i] = seeds[i] + min_bounding
        seeds[i + 1] = seeds[i + 1] - min_bounding
        if seeds[i + 1] <= 0:
            i += 2

    print(des_res)

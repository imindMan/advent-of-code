with open("day5.txt", encoding="utf-8") as f:
    seed_information = list(map(int, f.readline()[7:].split(" ")))

    data_parsing = f.readlines()[1:]
    current_map = ""
    last_check_map = ""
    
    title_list = ["seed-to-soil map:\n", "soil-to-fertilizer map:\n", "fertilizer-to-water map:\n", "water-to-light map:\n", "light-to-temperature map:\n", "temperature-to-humidity map:\n", "humidity-to-location map:\n"]
    
    des_records = []
    for j in seed_information:
        
        des = j

        for i in range(len(data_parsing) - 1):
            if data_parsing[i] == '\n':
                continue 
            if data_parsing[i] in title_list:
                current_map = data_parsing[i]
            else:

                data = list(map(int, data_parsing[i].split(" ")))

                destination_source = data[0]
                range_source = data[1]
                range_ = data[2]
                if range_source <= des <= range_source + range_ - 1:
                    if current_map != last_check_map:
                        last_check_map = current_map
                        des = destination_source + (des - range_source)


    
        des_records.append(des)
    print(min(des_records))


            

        


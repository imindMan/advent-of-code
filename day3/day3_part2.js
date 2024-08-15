let fs = require('fs');

const data = fs.readFileSync("day3.txt", "utf-8").split("\n");
parseLine(data)
function arraysEqual(a, b) {
    if (a === b) return true;
    if (a == null || b == null) return false;
    if (a.length !== b.length) return false;

    for (let i = 0; i < a.length; i++) {
        if (a[i] !== b[i]) return false;
    }
    return true;
}

function checkAsterisk(pos_start, pos_end, data) {
    
    if (pos_start[1] - 1 >= 0 && data[pos_start[0]][pos_start[1] - 1] == '*') {
        return [pos_start[0], pos_start[1] - 1];
    }
    else if (pos_end[1] + 1 <= data[0].length - 1 && data[pos_end[0]][pos_end[1] + 1] == '*') {
        return [pos_end[0], pos_end[1] + 1];
    }
    let start = 0; let limit = 0;
            if (pos_start[1] - 1 < 0) {
                start = 0;
                limit = pos_end[1] + 1;
            } 
            else if (pos_end[1] + 1 >= data[0].length) {
                start = pos_start[1] - 1;
                limit = data[0].length - 1; 
            }
            else {
                start = pos_start[1] - 1;
                limit = pos_end[1] + 1;
            }
        
            
    if (pos_start[0] == 0) {
        for (let i = start; i <= limit; i++)
        {
            if (data[1][i] == '*') {
                return [1, i];
            }
        }
    }
    else if (pos_start[0] == data.length - 2) {
            for (let i = start; i <= limit; i++)
            {
                if (data[data.length - 3][i] == '*') {
                    return [data.length - 3, i];
                }
            }
    }
    else {
        for (let i = start; i <= limit; i++) {
            if (data[pos_start[0] - 1][i] == '*') { 
                return [pos_start[0] - 1, i];
            }
            else if (data[pos_start[0] + 1][i] == '*') { 
                return [pos_start[0] + 1, i];
            }
        }
    }
    return [];
}


function parseLine(data) {
    // quick implementation goes here
    
    // first solution poped up to my mind is a quick brute force solution
    let sum = 0;
    
    let asterisk_records = [];
    let position_records = [];
    let pos_start = [0, 0];
    let pos_end = [0, 0];
    for (let i = 0; i < data.length - 1; i++) {
        let check = false;
        for (let j = 0; j < data[i].length; j++ )
        {
            if (/^\d+$/.test(data[i][j])) {
                // this number isn't checked yet
                if (check == false && j + 1 < data[i].length) {
                    check = true;
                    pos_start = [i, j];
                }
                else if (check == false && j + 1 >= data[i].length) {
                    pos_start = [i, j];
                    pos_end = [i, j];
                    let record = checkAsterisk(pos_start, pos_end, data);
                    if (!asterisk_records.some(subArray => arraysEqual(subArray, record)) && record.length != 0) {
                        asterisk_records.push(record);
                        position_records.push([pos_start, pos_end]);
                    }
                    else if (record.length != 0){
                       let position_extract = position_records[asterisk_records.findIndex(subrecord => arraysEqual(subrecord, record))];
                       let num_gen = Number(data[position_extract[0][0]].slice(position_extract[0][1], position_extract[1][1] + 1));
                       let original_num = Number(data[i].slice(pos_start[1], pos_end[1] + 1));
                       let res = num_gen * original_num;
                       sum += res;
                    }

                }
                else if (j + 1 >= data[i].length) {
                    check = false;
                    pos_end = [i, j];
                    let record = checkAsterisk(pos_start, pos_end, data);
                    if (!asterisk_records.some(subArray => arraysEqual(subArray, record)) && record.length != 0) {
                        asterisk_records.push(record);
                        position_records.push([pos_start, pos_end]);
                    }
                    else if (record.length != 0){
                        let position_extract = position_records[asterisk_records.findIndex(subrecord => arraysEqual(subrecord, record))];
                       let num_gen = Number(data[position_extract[0][0]].slice(position_extract[0][1], position_extract[1][1] + 1));
                       let original_num = Number(data[i].slice(pos_start[1], pos_end[1] + 1));
                       let res = num_gen * original_num;
                       sum += res;                    
                    }

                }
                continue;
            }
            else if (check == true) {
                check = false;
                pos_end = [i, j - 1];
                let record = checkAsterisk(pos_start, pos_end, data);

                    if (!asterisk_records.some(subArray => arraysEqual(subArray, record)) && record.length != 0) {
                        asterisk_records.push(record);
                        position_records.push([pos_start, pos_end]);
                    }
                    else if (record.length != 0){
                        let position_extract = position_records[asterisk_records.findIndex(subrecord => arraysEqual(subrecord, record))];
                       let num_gen = Number(data[position_extract[0][0]].slice(position_extract[0][1], position_extract[1][1] + 1));
                       let original_num = Number(data[i].slice(pos_start[1], pos_end[1] + 1));
                       let res = num_gen * original_num;
                       sum += res;   
                    }
            }
        }
    }

    console.log(sum);
}

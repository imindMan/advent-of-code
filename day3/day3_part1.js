// This is also parsing characters while also "smart" checking positions and symbols

let fs = require('fs');

const data = fs.readFileSync("day3.txt", "utf-8").split("\n");
parseLine(data)


function checkIfItsASymbol(symbol) {
    if (!/^\d+$/.test(symbol) && symbol != '.') {
        return true;
    }
    else {
        return false;
    }
}

function checkPosValid(pos_start, pos_end, data) {
    if (pos_start[1] - 1 >= 0 && checkIfItsASymbol(data[pos_start[0]][pos_start[1] - 1])) {
        return true;
    }
    else if (pos_end[1] + 1 <= data[0].length - 1 && checkIfItsASymbol(data[pos_end[0]][pos_end[1] + 1])) {
        return true;
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
            if (checkIfItsASymbol(data[1][i])) {
                return true;
            }
        }
    }
    else if (pos_start[0] == data.length - 2) {
            for (let i = start; i <= limit; i++)
            {
                if (checkIfItsASymbol(data[data.length - 3][i])) {
                    return true;
                }
            }
    }
    else {
        for (let i = start; i <= limit; i++) {
            if (checkIfItsASymbol(data[pos_start[0] - 1][i]) || checkIfItsASymbol(data[pos_start[0] + 1][i])) {
                return true;
            }
        }
    }
    return false;
}


function parseLine(data) {
    // quick implementation goes here
    
    // first solution poped up to my mind is a quick brute force solution
    let sum = 0;
    
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
                    if (checkPosValid(pos_start, pos_end, data)) {
                        sum += Number(data[i].slice(pos_start[1], pos_end[1] + 1));
                    }

                }
                else if (j + 1 >= data[i].length) {
                    check = false;
                    pos_end = [i, j];
                    if (checkPosValid(pos_start, pos_end, data)) {
                        sum += Number(data[i].slice(pos_start[1], pos_end[1] + 1));
                    }

                }
                continue;
            }
            else if (check == true) {
                check = false;
                pos_end = [i, j - 1];
                if (checkPosValid(pos_start, pos_end, data)) {
                    sum += Number(data[i].slice(pos_start[1], pos_end[1] + 1));
                }
            }
        }
    }

    console.log(sum);
}

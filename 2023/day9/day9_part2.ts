import * as readline from 'readline';
import * as fs from "fs";

const lineReader = readline.createInterface({
    input: fs.createReadStream('./day9.txt'),
    terminal: false,
});

let sum = 0;

lineReader.on('line', (line) => {

    const listOfElements: number[] = line.split(" ").map(val => Number(val))
    const tracing_history: number[][] = [listOfElements]
    parsingDifferences(listOfElements).forEach(element => {
        tracing_history.push(element)
    });
    extrapolate(tracing_history);
    sum += tracing_history[0][0];
    
}).on('close', () => {
    console.log(sum)
});


function allZero(array): boolean {
    let allzero: boolean = true;
    array.forEach(element => {
        if (element != 0) {
            allzero = false; 
        }
    });
    return allzero

}
// just a little small change
function extrapolate(tracing_history: number[][]) {
    if (tracing_history.length == 1) {
        return;
    } else if (allZero(tracing_history[tracing_history.length - 1])) {
        tracing_history[tracing_history.length - 1].unshift(0)
        let next_array = tracing_history[tracing_history.length - 2];
        let end_array = tracing_history[tracing_history.length - 1];
        tracing_history[tracing_history.length - 2].unshift(
            next_array[0] - end_array[0]
        )
        extrapolate(tracing_history.slice(0, tracing_history.length - 1))
    } else {
        let next_array = tracing_history[tracing_history.length - 2];
        let end_array = tracing_history[tracing_history.length - 1];
        tracing_history[tracing_history.length - 2].unshift(
            next_array[0] - end_array[0]
        )
        extrapolate(tracing_history.slice(0, tracing_history.length - 1))

    }
}

function parsingDifferences(listOfElements: number[]): number[][] {
    let differences: number[] = []
    let counter_zero = 0;
    for (let i: number = 0; i < listOfElements.length - 1; i++) {
        differences.push(listOfElements[i + 1] - listOfElements[i])
        if (listOfElements[i + 1] - listOfElements[i] == 0) {
            counter_zero += 1
        }
    }
    if (counter_zero == differences.length) {
        let return_arr: number[][] = [differences]
        return return_arr
    } 
    else {
        let return_arr: number[][] = [differences]
        parsingDifferences(differences).forEach(element => {
            return_arr.push(element)
        });
        return return_arr
    }
}

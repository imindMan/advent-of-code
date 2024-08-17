use std::cmp::Ordering;
use std::collections::HashMap;
use std::fs::File;
use std::io::{self, BufRead};
use std::path::Path;

#[derive(Debug)]
enum HandTypes {
    FiveOfAKind,
    FourOfAKind,
    FullHouse,
    ThreeOfAKind,
    TwoPair,
    OnePair,
    HighCard,
}

fn main() -> Result<(), String> {
    let mut fiveofakinds: Vec<(String, i32)> = Vec::new();
    let mut fourofakinds: Vec<(String, i32)> = Vec::new();
    let mut fullhouses: Vec<(String, i32)> = Vec::new();
    let mut threeofakinds: Vec<(String, i32)> = Vec::new();
    let mut twopairs: Vec<(String, i32)> = Vec::new();
    let mut onepairs: Vec<(String, i32)> = Vec::new();
    let mut highcards: Vec<(String, i32)> = Vec::new();

    if let Ok(lines) = read_lines("./day7.txt") {
        for line in lines.map_while(Result::ok) {
            let (card_name, type_of, value) = handle_line(line);
            match type_of {
                HandTypes::FiveOfAKind => fiveofakinds.push((card_name, value)),
                HandTypes::FourOfAKind => fourofakinds.push((card_name, value)),
                HandTypes::FullHouse => fullhouses.push((card_name, value)),
                HandTypes::ThreeOfAKind => threeofakinds.push((card_name, value)),
                HandTypes::TwoPair => twopairs.push((card_name, value)),
                HandTypes::OnePair => onepairs.push((card_name, value)),
                HandTypes::HighCard => highcards.push((card_name, value)),
            };
        }
    }

    sort(&mut highcards);
    sort(&mut onepairs);
    sort(&mut twopairs);
    sort(&mut threeofakinds);
    sort(&mut fullhouses);
    sort(&mut fourofakinds);
    sort(&mut fiveofakinds);
    highcards.append(&mut onepairs);
    highcards.append(&mut twopairs);
    highcards.append(&mut threeofakinds);
    highcards.append(&mut fullhouses);
    highcards.append(&mut fourofakinds);
    highcards.append(&mut fiveofakinds);
    let mut res = 0;

    let values = highcards;

    for (i, j) in values.iter().enumerate() {
        res += (i + 1) as i32 * j.1;
    }
    println!("{}", res);
    Ok(())
}

fn handle_line(line: String) -> (String, HandTypes, i32) {
    let arr: Vec<String> = line
        .clone()
        .split_whitespace()
        .map(|x| x.to_string())
        .collect();
    let rough_value = arr[1].parse::<i32>().unwrap();

    let mut counters: HashMap<char, i32> = HashMap::new();
    for i in arr[0].chars() {
        counters.entry(i).and_modify(|x| *x += 1).or_insert(1);
    }
    let mut counter_three: i32 = 0;
    let mut counter_two: i32 = 0;
    let mut counter_one: i32 = 0;

    for ele in &counters {
        match *ele.1 {
            5 => return (arr[0].clone(), HandTypes::FiveOfAKind, rough_value),
            4 => return (arr[0].clone(), HandTypes::FourOfAKind, rough_value),
            3 => counter_three += 1,
            2 => counter_two += 1,
            1 => counter_one += 1,
            _ => continue,
        }
    }
    if counter_three == 1 && counter_two == 1 {
        (arr[0].clone(), HandTypes::FullHouse, rough_value)
    } else if counter_three == 1 && counter_one == 2 {
        (arr[0].clone(), HandTypes::ThreeOfAKind, rough_value)
    } else if counter_two == 2 {
        (arr[0].clone(), HandTypes::TwoPair, rough_value)
    } else if counter_two == 1 {
        (arr[0].clone(), HandTypes::OnePair, rough_value)
    } else {
        (arr[0].clone(), HandTypes::HighCard, rough_value)
    }
}

fn read_lines<P>(filename: P) -> io::Result<io::Lines<io::BufReader<File>>>
where
    P: AsRef<Path>,
{
    let file = File::open(filename)?;
    Ok(io::BufReader::new(file).lines())
}

fn sort(vec_to_be_sort: &mut [(String, i32)]) {
    let order = [
        '2', '3', '4', '5', '6', '7', '8', '9', 'T', 'J', 'Q', 'K', 'A',
    ];

    // Create a hash map for quick lookup of the order index
    let order_map: std::collections::HashMap<_, _> =
        order.iter().enumerate().map(|(i, &c)| (c, i)).collect();

    // Sort the array using the custom comparator
    vec_to_be_sort.sort_by(|a, b| {
        for (ca, cb) in a.0.chars().zip(b.0.chars()) {
            let idx_a = *order_map.get(&ca).unwrap_or(&usize::MAX); // Use usize::MAX for characters not in order
            let idx_b = *order_map.get(&cb).unwrap_or(&usize::MAX);
            match idx_a.cmp(&idx_b) {
                Ordering::Equal => continue,
                other => return other,
            }
        }
        a.0.len().cmp(&b.0.len())
    });
}

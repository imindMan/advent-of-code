use std::fs::File;
use std::io::{self, BufRead};
use std::path::Path;

fn read_lines<P>(filename: P) -> io::Result<io::Lines<io::BufReader<File>>>
where
    P: AsRef<Path>,
{
    let file = File::open(filename)?;
    Ok(io::BufReader::new(file).lines())
}

fn main() -> Result<(), String> {
    let mut count: i32 = 0;
    if let Ok(lines) = read_lines("./day2.txt") {
        for line in lines.map_while(Result::ok) {
            let parts: Vec<i32> = line
                .split(" ")
                .filter_map(|c| c.trim().parse::<i32>().ok())
                .collect();
            let mut decreasing = false;
            if parts[0] == parts[parts.len() - 1] {
                continue;
            } else if parts[0] > parts[parts.len() - 1] {
                decreasing = true;
            }

            let mut index: usize = 0;
            while index < parts.len() {
                let first_ins = parts[index];
                let mut second_ins = -1;
                if index + 1 < parts.len() {
                    second_ins = parts[index + 1];
                }

                if second_ins == -1 {
                    break;
                } else if (first_ins < second_ins && decreasing == true)
                    || (first_ins == second_ins)
                    || (first_ins > second_ins && decreasing == false)
                {
                    break;
                } else if ((first_ins - second_ins).abs() < 1)
                    || ((first_ins - second_ins).abs() > 3)
                {
                    break;
                }

                index += 1;
            }
            if index == parts.len() - 1 {
                count += 1;
            }
        }
    }
    println!("{}", count);
    Ok(())
}
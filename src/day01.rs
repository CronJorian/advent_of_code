use super::util;

pub fn run() {
    task01();
    task02();
}

fn find_first_digit(text: &str, reverse: bool) -> Option<u32> {
    let mut iter: Vec<char> = text.chars().collect();

    if reverse {
        iter.reverse();
    }

    for character in iter {
        if character.is_numeric() {
            return character.to_digit(10);
        }
    }

    None
}

fn task01() {
    let content = util::read_file("./inputs/day01.txt");
    let mut buffer: Vec<u32> = Vec::new();

    for line in content.lines() {
        let left: Option<u32> = find_first_digit(line, false);
        let right: Option<u32> = find_first_digit(line, true);

        if left.is_some() && right.is_some() {
            buffer.push(left.unwrap() * 10 + right.unwrap());
        }
    }

    println!("The sum of task 01 is: {}", buffer.iter().sum::<u32>());
}

fn task02() {
    let content = util::read_file("./inputs/day01.txt");
    let mut buffer: Vec<u32> = Vec::new();

    for line in content.lines() {
        let mut line_buffer: Vec<u32> = Vec::new();

        for (i, character) in line.char_indices() {
            let digit = character.to_digit(10);
            match digit {
                Some(x) => line_buffer.push(x),
                None => {
                    if i + 3 <= line.len() {
                        for j in i + 3..=line.len().min(i + 5) {
                            let word = &line[i..j];
                            match to_numeric(word) {
                                Some(y) => line_buffer.push(y),
                                None => {}
                            }
                        }
                    }
                }
            }
        }
        buffer.push(line_buffer.first().unwrap() * 10 + line_buffer.last().unwrap());
    }

    println!("The sum of task 02 is: {}", buffer.iter().sum::<u32>());
}

fn to_numeric(text: &str) -> Option<u32> {
    match text {
        "one" => Some(1),
        "two" => Some(2),
        "three" => Some(3),
        "four" => Some(4),
        "five" => Some(5),
        "six" => Some(6),
        "seven" => Some(7),
        "eight" => Some(8),
        "nine" => Some(9),
        _ => None,
    }
}

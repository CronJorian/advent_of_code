use super::util;

pub fn run() {
    task01();
    task02();
}

const _TASK01_EXAMPLE: &str = "Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11";

const _TASK02_EXAMPLE: &str = "Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11";

fn task01() {
    let data = util::read_file("./inputs/day04.txt");
    let mut total_points = 0;

    for row in data.lines() {
        if let Some((winning_numbers, chosen_numbers)) = parse_row(row) {
            let mut counter: i32 = -1;
            for chosen_number in chosen_numbers.iter() {
                if winning_numbers.contains(chosen_number) {
                    counter += 1;
                }
            }

            if counter >= 0 {
                let points = 2_i32.pow(counter as u32);
                total_points += points;
            };
        };
    }

    println!("Total points are: {}", total_points);
}

fn parse_row(row: &str) -> Option<(Vec<u32>, Vec<u32>)> {
    if let Some((_card, numbers_string)) = row.split_once(": ") {
        if let Some((win_string, chosen_string)) = numbers_string.split_once(" | ") {
            let winning_numbers: Vec<u32> = win_string
                .split_whitespace()
                .map(|number| number.trim().parse::<u32>().unwrap_or(0))
                .filter(|number| number > &0)
                .collect();
            let chosen_numbers: Vec<u32> = chosen_string
                .split_whitespace()
                .map(|number| number.trim().parse::<u32>().unwrap_or(0))
                .filter(|number| number > &0)
                .collect();

            return Some((winning_numbers, chosen_numbers));
        };
    };
    None
}

fn task02() {
    let data = util::read_file("./inputs/day04.txt");
    let mut scratchcards: Vec<u32> = vec![1; data.lines().count()];
    for (i, row) in data.lines().enumerate() {
        if let Some((winning_numbers, chosen_numbers)) = parse_row(row) {
            let matching_count = chosen_numbers
                .iter()
                .filter(|number| winning_numbers.contains(number))
                .count();

            for count in i + 1..=i + matching_count {
                scratchcards[count] += 1 * scratchcards[i];
            }
        }
    }

    println!("Total scratchcards: {}", scratchcards.iter().sum::<u32>());
}

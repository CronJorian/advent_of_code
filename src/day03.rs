use core::panic;
use std::collections::{HashMap, HashSet};

use super::util;

pub fn run() {
    task01();
    task02();
}

fn task01() {
    let input = util::read_file("./inputs/day03.txt");
    let data_matrix: Vec<Vec<char>> = input.lines().map(|line| line.chars().collect()).collect();
    let mut part_numbers: Vec<u32> = Vec::new();
    let window: [isize; 3] = [-1, 0, 1];

    for (row, line) in data_matrix.iter().enumerate() {
        let mut number_buffer = String::new();
        let mut has_adjacent_tile = false;

        for (col, character) in line.iter().enumerate() {
            if character.is_digit(10) {
                number_buffer.push(*character);

                if has_adjacent_tile {
                    continue;
                }

                for window_row in window {
                    let (i, i_overflow) = row.overflowing_add_signed(window_row);
                    if i_overflow || i >= data_matrix.len() {
                        continue;
                    }

                    for window_col in window {
                        let (j, j_overflow) = col.overflowing_add_signed(window_col);
                        if j_overflow || j >= data_matrix[i].len() {
                            continue;
                        }

                        if data_matrix[i][j] != '.' && !data_matrix[i][j].is_digit(10) {
                            has_adjacent_tile = true;
                        }
                    }
                }
            } else if !number_buffer.is_empty() {
                let Ok(number) = number_buffer.parse::<u32>() else {
                    panic!("{}", number_buffer)
                };

                if has_adjacent_tile {
                    part_numbers.push(number);
                }

                number_buffer = String::new();
                has_adjacent_tile = false;
            }
        }

        if !number_buffer.is_empty() {
            let Ok(number) = number_buffer.parse::<u32>() else {
                panic!("{}", number_buffer)
            };

            if has_adjacent_tile {
                part_numbers.push(number);
            }
        }
    }

    println!(
        "The sum of all part numbers is {}",
        part_numbers.iter().sum::<u32>()
    )
}

fn task02() {
    let input = util::read_file("./inputs/day03.txt");
    let data_matrix: Vec<Vec<char>> = input.lines().map(|line| line.chars().collect()).collect();
    let window: [isize; 3] = [-1, 0, 1];
    let mut gears: HashMap<(usize, usize), Vec<u32>> = HashMap::new();

    for (row, line) in data_matrix.iter().enumerate() {
        let mut number_buffer = String::new();
        let mut gear_indices: HashSet<(usize, usize)> = HashSet::new();

        for (col, character) in line.iter().enumerate() {
            if character.is_digit(10) {
                number_buffer.push(*character);

                for row_window in window {
                    let (i, row_overflow) = row.overflowing_add_signed(row_window);
                    if row_overflow || i >= data_matrix.len() {
                        continue;
                    }

                    for col_window in window {
                        let (j, col_overflow) = col.overflowing_add_signed(col_window);
                        if col_overflow || j >= data_matrix[i].len() {
                            continue;
                        }

                        if data_matrix[i][j] == '*' {
                            gear_indices.insert((i, j));
                        }
                    }
                }
            } else if !number_buffer.is_empty() {
                let Ok(number) = number_buffer.parse::<u32>() else {
                    panic!()
                };

                for index in gear_indices.iter() {
                    match gears.get_mut(index) {
                        Some(v) => v.push(number),
                        None => {
                            gears.insert(*index, vec![number]);
                        }
                    };
                }

                number_buffer = String::new();
                gear_indices = HashSet::new();
            }
        }

        if !number_buffer.is_empty() {
            let Ok(number) = number_buffer.parse::<u32>() else {
                panic!()
            };

            for index in gear_indices.iter() {
                match gears.get_mut(index) {
                    Some(v) => v.push(number),
                    None => {
                        gears.insert(*index, vec![number]);
                    }
                };
            }
        }
    }

    println!(
        "Sum of all gear ratios is: {}",
        gears
            .values()
            .filter(|parts| parts.len() == 2)
            .map(|parts| parts.iter().product::<u32>())
            .sum::<u32>()
    )
}

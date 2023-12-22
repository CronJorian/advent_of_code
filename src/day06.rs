use super::util;

const _TASK01_EXAMPLE: &str = "Time:      7  15   30
Distance:  9  40  200";

pub fn run() {
    task01();
    task02();
}

fn task01() {
    let data = parse_input(util::read_file("./inputs/day06.txt"));
    let ways_to_win_product: u64 = data
        .iter()
        .map(|(time, distance)| ways_to_win(time, distance))
        .product();

    println!("The product of all ways to win is {}", ways_to_win_product)
}

fn task02() {
    let data = parse_input(util::read_file("./inputs/day06.txt"));
    let single_race = data
        .into_iter()
        .fold((0, 0), |(acc_time, acc_dest), (time, dest)| {
            (
                acc_time * 10u64.pow(time.to_string().len() as u32) + time,
                acc_dest * 10u64.pow(dest.to_string().len() as u32) + dest,
            )
        });

    let ways_to_win_product: u64 = vec![single_race]
        .iter()
        .map(|(time, distance)| ways_to_win(time, distance))
        .product();

    println!("The product of all ways to win is {}", ways_to_win_product)
}

fn parse_input(input: String) -> Vec<(u64, u64)> {
    if let Some((time, distance)) = input.split_once("\n") {
        let time = time
            .split_whitespace()
            .filter_map(|word| word.parse::<u64>().ok())
            .collect::<Vec<u64>>();
        let distance = distance
            .split_whitespace()
            .filter_map(|word| word.parse::<u64>().ok())
            .collect::<Vec<u64>>();

        time.into_iter()
            .zip(distance.into_iter())
            .map(|(t, d)| (t, d))
            .collect()
    } else {
        vec![]
    }
}

fn ways_to_win(time: &u64, distance: &u64) -> u64 {
    // good old pq formula
    // from the example (time 7, distance 9)
    // x * (7 - x) > 9
    // <=> x^2 - 7x + (9+1) (to morph > into >=)
    // results in (time / 2) +- sqrt((time / 2)^2 - (distance + 1))
    // x_1 and x_2 are the lower and upper bounds

    let t = *time as f64;
    let d = *distance as f64;

    let lower_bound = ((t / 2.) - ((t / 2.).powi(2) - (d + 1.)).sqrt()).ceil() as u64;
    let upper_bound = ((t / 2.) + ((t / 2.).powi(2) - (d + 1.)).sqrt()).floor() as u64;
    upper_bound - lower_bound + 1
}

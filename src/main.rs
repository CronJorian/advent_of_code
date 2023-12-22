use std::env;

mod day01;
mod day02;
mod day03;
mod day04;
mod day05;
mod day06;
mod day07;
mod util;

fn main() {
    for arg in env::args().skip(1) {
        match arg.as_str() {
            "day01" => day01::run(),
            "day02" => day02::run(),
            "day03" => day03::run(),
            "day04" => day04::run(),
            "day05" => day05::run(),
            "day06" => day06::run(),
            "day07" => day07::run(),
            _ => println!("Exercise \"{arg}\" not found")
        }
    }

}

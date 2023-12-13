use std::env;

mod day01;
mod day02;
mod day03;
mod util;

fn main() {
    for arg in env::args().skip(1) {
        match arg.as_str() {
            "day01" => day01::run(),
            "day02" => day02::run(),
            "day03" => day03::run(),
            _ => println!("Exercise \"{arg}\" not found")
        }
    }

}

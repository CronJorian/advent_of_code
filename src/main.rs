use std::env;

mod day01;
mod util;

fn main() {
    for arg in env::args().skip(1) {
        match arg.as_str() {
            "day01" => day01::run(),
            _ => println!("Exercise \"{arg}\" not found")
        }
    }

}

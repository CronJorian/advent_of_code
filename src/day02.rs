use core::fmt;
use super::util;
use regex::Regex;

struct Cubes {
    red: Option<u32>,
    green: Option<u32>,
    blue: Option<u32>,
}

impl fmt::Display for Cubes {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(
            f,
            "R: {}, G: {}, B: {}",
            if let Some(red) = self.red { red.to_string() } else { "None".to_string() },
            if let Some(green) = self.green { green.to_string() } else { "None".to_string() },
            if let Some(blue) = self.blue { blue.to_string() } else { "None".to_string() }
        )
    }
}

pub fn run() {
    task01();
    task02();
}

fn task01() {
    let lines = util::read_file("./inputs/day02.txt");
    let mut id_sum = 0;
    for game in lines.lines() {
        if let Some((game_id, draws)) = game.split_once(": ") {
            if is_game_possible(draws) {
                match game_id[5..].parse::<u32>() {
                    Ok(x) => id_sum += x,
                    _ => {}
                };
            }
        }
    }

    println!("Sum of possible Game IDs is: {}", id_sum);
}

fn is_game_possible(sets: &str) -> bool {
    for set in sets.split("; ") {
        if !check_cubes(set) {
            return false;
        };
    }
    true
}

fn check_cubes(set: &str) -> bool {
    for cube in set.split(", ") {
        if !is_below_limit(cube) {
            return false;
        };
    }
    true
}

fn is_below_limit(cubes: &str) -> bool {
    let re = Regex::new(r"(?<number>\d+) (?<color>\w+)").unwrap();
    let Some(groups) = re.captures(cubes) else {
        return false;
    };
    let limit = match &groups["color"] {
        "red" => 12,
        "green" => 13,
        "blue" => 14,
        _ => 0,
    };

    match groups["number"].parse::<u32>() {
        Ok(x) => x <= limit,
        _ => false,
    }
}

fn task02() {
    let lines = util::read_file("./inputs/day02.txt");
    let mut sum_power: u32 = 0;
    for game in lines.lines() {
        let Some((_game_id, set)) = game.split_once(": ") else {
            continue;
        };
        let mut minimum = Cubes {
            red: None,
            green: None,
            blue: None,
        };

        for cubes in set.split("; ") {
            let cube = get_rgb_cubes(cubes);

            minimum.red = max(minimum.red, cube.red);
            minimum.green = max(minimum.green, cube.green);
            minimum.blue = max(minimum.blue, cube.blue);
        }

        let fields = [minimum.red, minimum.green, minimum.blue];
        if fields.iter().any(|field| field.is_none()) {
            println!("skipping");
            continue;
        }

        let mut power: u32 = 1;
        for field in [minimum.red, minimum.green, minimum.blue] {
            if let Some(f) = field {
                power *= f;
            }
        }
        sum_power += power;
    }

    println!("The minimum power is: {}", sum_power);
}

fn max(a: Option<u32>, b: Option<u32>) -> Option<u32> {
    match (a, b) {
        (Some(a_), Some(b_)) => Some(a_.max(b_)),
        (Some(_), None) => a,
        (None, Some(_)) => b,
        (None, None) => None,
    }
}

fn get_rgb_cubes(cubes: &str) -> Cubes {
    let re = Regex::new(r"(?<number>\d+) (?<color>\w+)").unwrap();
    let mut rgb = Cubes {
        red: None,
        green: None,
        blue: None,
    };
    for cube in cubes.split(", ") {
        let Some(groups) = re.captures(cube) else {
            continue;
        };

        let Ok(n) = groups["number"].parse() else {
            continue;
        };

        match &groups["color"] {
            "red" => rgb.red = Some(n),
            "green" => rgb.green = Some(n),
            "blue" => rgb.blue = Some(n),
            _ => {}
        };
    }
    rgb
}

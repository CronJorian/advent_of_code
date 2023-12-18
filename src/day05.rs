use super::util;

pub fn run() {
    task01();
    task02();
}

const _TASK01_EXAMPLE: &str = "seeds: 79 14 55 13

seed-to-soil map:
50 98 2
52 50 48

soil-to-fertilizer map:
0 15 37
37 52 2
39 0 15

fertilizer-to-water map:
49 53 8
0 11 42
42 0 7
57 7 4

water-to-light map:
88 18 7
18 25 70

light-to-temperature map:
45 77 23
81 45 19
68 64 13

temperature-to-humidity map:
0 69 1
1 0 69

humidity-to-location map:
60 56 37
56 93 4";

struct Range {
    start: i64,
    end: i64,
}

impl Range {
    // assume sorted maps
    fn update_with_maps(&self, maps: &Vec<Map>) -> Vec<Range> {
        let mut ranges: Vec<Range> = Vec::new();
        let mut current_start = self.start;

        for map in maps {
            let map_end = map.source + map.length;
            let shift = map.destination - map.source;
            if current_start >= self.end {
                break;
            } else if current_start >= map_end {
                continue;
            }

            if current_start < map.source {
                // not modified
                ranges.push(Range {
                    start: current_start,
                    end: map.source.min(self.end),
                });

                current_start = map.source.min(self.end);
            }
            if self.end > map.source {
                ranges.push(Range {
                    start: current_start + shift,
                    end: map_end.min(self.end) + shift,
                });

                current_start = map_end.min(self.end);
            }
        }

        ranges
    }
}

struct Map {
    source: i64,
    destination: i64,
    length: i64,
}

fn task01() {
    _run(false);
}

fn task02() {
    _run(true);
}

fn _run(length_included: bool) {
    let input = util::read_file("./inputs/day05.txt");
    let data: Vec<&str> = input.split("\n\n").collect();

    let mut seeds = parse_seeds(data[0], length_included);

    for map_string in data.iter().skip(1) {
        let mut maps = parse_map(map_string);
        let mut seed_buffer: Vec<Range> = Vec::new();
        maps.sort_by(|a, b| a.source.cmp(&b.source));
        for seed in seeds.iter() {
            let mut new_seeds = seed.update_with_maps(&maps);
            seed_buffer.append(&mut new_seeds);
        }

        seeds = seed_buffer;
    }

    let min = seeds
        .iter()
        .map(|seed| seed.start)
        .min()
        .unwrap_or(i64::MAX);

    println!("Closest seed is at {}", min)
}

fn parse_seeds(seed_string: &str, length_included: bool) -> Vec<Range> {
    let seeds = seed_string
        .split_whitespace()
        .filter_map(|number| number.parse::<i64>().ok())
        .collect::<Vec<i64>>();

    if !length_included {
        seeds
            .iter()
            .map(|number| Range {
                start: *number,
                end: number + 1,
            })
            .collect()
    } else {
        seeds
            .chunks_exact(2)
            .into_iter()
            .map(|pair| {
                let start = pair[0];
                let end = pair[0] + pair[1];
                return Range { start, end };
            })
            .collect()
    }
}

fn parse_map(map_string: &str) -> Vec<Map> {
    let mut map_vec: Vec<Map> = Vec::new();

    for map in map_string.split("\n").skip(1) {
        let raw: Vec<i64> = map
            .split_whitespace()
            .filter_map(|number| number.parse::<i64>().ok())
            .collect();

        map_vec.push(Map {
            destination: raw[0],
            source: raw[1],
            length: raw[2],
        })
    }

    map_vec
}

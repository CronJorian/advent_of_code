use super::util;
use std::{cmp::Ordering, collections::HashMap, iter::zip};

const _TASK01_EXAMPLE: &str = "32T3K 765
T55J5 684
KK677 28
KTJJT 220
QQQJA 483";

#[derive(Debug)]
struct Hand {
    hand: String,
    bid: u64,
    use_joker: bool,
}

impl Hand {
    /// Types:
    /// 7 FiveOfAKind  
    /// 6 FourOfAKind  
    /// 5 FullHouse  
    /// 4 ThreeOfAKind  
    /// 3 TwoPair  
    /// 2 OnePair  
    /// 1 HighCard  
    fn get_type(&self) -> usize {
        let mut map: HashMap<char, usize> = HashMap::new();

        for card in self.hand.chars() {
            map.entry(card)
                .and_modify(|counter| *counter += 1)
                .or_insert(1);
        }

        let mut vals: Vec<&usize> = map.values().collect();
        vals.sort();
        self.get_type_from_values(vals)
    }

    /// use_joker tier table
    /// | types | 1j  | 2j  | 3j  | 4j  | 5j  |
    /// | ----- | --- | --- | --- | --- | --- |
    /// | 5     | 4   | 3   | 2   | 1   | -   |
    /// | 4     | 3   | 2   | 1   | -   | -   |
    /// | 32    | 22  | -   | -   | -   | -   |
    /// | 3     | 2   | 1   | -   | -   | -   |
    /// | 22    | -   | -   | -   | -   | -   |
    /// | 2     | 1   | -   | -   | -   | -   |
    /// | 1     | -   | -   | -   | -   | -   |
    fn get_type_from_values(&self, vals: Vec<&usize>) -> usize {
        match vals[..] {
            [.., 5] => 7,
            [.., 4] => 6,
            [.., 2, 3] => 5,
            [.., 3] => 4,
            [.., 2, 2] => 3,
            [.., 2] => 2,
            [.., 1] => 1,
            _ => 0,
        }
    }

    fn get_card_value(&self, card: char) -> usize {
        match card {
            'A' => 14,
            'K' => 13,
            'Q' => 12,
            'J' if !self.use_joker => 11,
            'T' => 10,
            '9' => 9,
            '8' => 8,
            '7' => 7,
            '6' => 6,
            '5' => 5,
            '4' => 4,
            '3' => 3,
            '2' => 2,
            'J' if self.use_joker => 1,
            _ => 0,
        }
    }

    fn cmp_on_equal(&self, other: &Self) -> Ordering {
        for (self_card, other_card) in zip(self.hand.chars(), other.hand.chars()) {
            let order = self
                .get_card_value(self_card)
                .cmp(&self.get_card_value(other_card));
            if order != Ordering::Equal {
                return order;
            }
        }
        Ordering::Equal
    }

    fn cmp(&self, other: &Self) -> Ordering {
        let order = self.get_type().cmp(&other.get_type());
        if order == Ordering::Equal {
            return self.cmp_on_equal(other);
        }
        order
    }
}

pub fn run() {
    task01();
    task02();
}

fn task01() {
    let data = util::read_file("./inputs/day07.txt");
    let mut hands: Vec<Hand> = Vec::new();
    let mut total_winnings: u64 = 0;

    for row in data.split("\n") {
        if let Some((hand, bid)) = row.split_once(" ") {
            if let Ok(bid) = bid.parse::<u64>() {
                hands.push(Hand {
                    hand: hand.to_string(),
                    bid,
                    use_joker: false,
                })
            }
        }
    }

    hands.sort_by(|a, b| a.cmp(b));

    for (rank, hand) in hands.iter().enumerate() {
        total_winnings += (rank + 1) as u64 * hand.bid;
    }

    println!("Total winnings are {}", total_winnings);
}

fn task02() {
    let data = _TASK01_EXAMPLE.to_string();
    let mut hands: Vec<Hand> = Vec::new();
    let mut total_winnings: u64 = 0;

    for row in data.split("\n") {
        if let Some((hand, bid)) = row.split_once(" ") {
            if let Ok(bid) = bid.parse::<u64>() {
                hands.push(Hand {
                    hand: hand.to_string(),
                    bid,
                    use_joker: true,
                })
            }
        }
    }

    hands.sort_by(|a, b| a.cmp(b));

    for (rank, hand) in hands.iter().enumerate() {
        total_winnings += (rank + 1) as u64 * hand.bid;
    }

    println!("Total winnings are {}", total_winnings);
}

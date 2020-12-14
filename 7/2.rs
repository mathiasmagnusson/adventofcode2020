#![feature(split_inclusive)]

use std::collections::{HashMap};
use std::fs;
use std::io::{BufRead, BufReader, Error};

fn main() -> Result<(), Error> {
    let lines = {
        let file = fs::File::open("in")?;

        let file = BufReader::new(file);

        file.lines().filter_map(|l| l.ok()).collect::<Vec<String>>()
    };

    let mut bag_names = HashMap::<String, usize>::with_capacity(lines.len());

    for (i, line) in lines.iter().enumerate() {
        let name: String = line.split_inclusive(' ').take(2).collect();
        bag_names.insert(name, i);
    }

    let bag_contains: Vec<Vec<(usize, usize)>> = lines
        .iter()
        .map(|line| {
            let mut iter = line.split_whitespace().skip(4);
            let mut done = false;
            std::iter::from_fn(|| {
                if done {
                    return None;
                }
                let amount = match iter.next().unwrap().parse::<usize>() {
                    Ok(amount) => amount,
                    Err(_) => {
                        return None;
                    }
                };
                let name = format!("{} {} ", iter.next().unwrap(), iter.next().unwrap());
                let next = iter.next().unwrap();
                if next.ends_with('.') {
                    done = true;
                }
                Some((amount, bag_names[&name]))
            })
            .collect()
        })
        .collect();

    let mut answer = 0;

    let mut current = vec![(1, bag_names["shiny gold "])];
    let mut next = vec![];
    while current.len() > 0 {
        for (amount, bag) in current.drain(..) {
            answer += amount;

            next.append(&mut bag_contains[bag].iter().map(|(a, c)| (a * amount, *c)).collect());
        }
        let tmp = current;
        current = next;
        next = tmp;
    }

    println!("{}", answer - 1);

    Ok(())
}

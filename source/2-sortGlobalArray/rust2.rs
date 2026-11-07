use std::{env, time::Instant};

fn argument(args: &[String], index: usize, fallback: i64) -> i64 {
    let value = args
        .get(index)
        .map(|s| s.parse::<i64>().expect("Invalid integer"))
        .unwrap_or(fallback);
    assert!(
        (0..=2147483647).contains(&value),
        "Arguments must be in 0..2147483647"
    );
    value
}

struct Sorter {
    arr: Vec<i64>,
}
impl Sorter {
    fn shells_sort(&mut self) {
        let mut gap = self.arr.len() / 2;
        while gap > 0 {
            let mut i = gap;
            while i < self.arr.len() {
                let temp = self.arr[i];
                let mut j = i;
                while j >= gap && self.arr[j - gap] > temp {
                    self.arr[j] = self.arr[j - gap];
                    j = j - gap;
                }
                self.arr[j] = temp;
                i = i + 1;
            }
            gap = gap / 2;
        }
    }
    fn run(&mut self, iterations: i64, seed: i64) -> i64 {
        let mut state = seed;
        let mut checksum: i64 = 0;
        let mut c = 0;
        while c < iterations {
            let mut k = 0;
            while k < self.arr.len() {
                state = (state * 1664525 + 1013904223) & 2147483647;
                self.arr[k] = (state >> 8) & 65535;
                k = k + 1;
            }
            self.shells_sort();
            k = 0;
            while k < self.arr.len() {
                checksum = (checksum * 31 + self.arr[k]) & 2147483647;
                k = k + 1;
            }
            c = c + 1;
        }
        checksum
    }
}
fn main() {
    let args: Vec<String> = env::args().collect();
    assert!((2..=4).contains(&args.len()), "iterations [seed [warmup]]");
    let iterations = argument(&args, 1, 0);
    let seed = argument(&args, 2, 12345);
    let warmup = argument(&args, 3, 10000);
    let mut sorter = Sorter { arr: vec![0; 100] };
    let warmup_checksum = sorter.run(warmup, seed);
    let start = Instant::now();
    let checksum = sorter.run(iterations, seed);
    let elapsed = start.elapsed().as_nanos();
    println!("elapsed_ns={elapsed} checksum={checksum} warmup_checksum={warmup_checksum}");
}

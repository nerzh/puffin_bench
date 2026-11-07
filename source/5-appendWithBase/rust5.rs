use std::{env, time::Instant};

fn argument(args: &[String], index: usize, fallback: usize) -> usize {
    let value = args
        .get(index)
        .map(|s| s.parse::<usize>().expect("Invalid count"))
        .unwrap_or(fallback);
    assert!(value <= 2147483647, "Count is too large");
    value
}

fn run(iterations: usize) -> usize {
    let base = "x".repeat(10_000);
    let mut results = Vec::new();
    for i in 0..iterations {
        let mut s = base.clone();
        if i % 1000 == 0 {
            s.push_str("!");
        }
        results.push(s);
    }
    let mut total = 0;
    for s in &results {
        total += s.len();
    }
    total
}

fn main() {
    let args: Vec<String> = env::args().collect();
    assert!(args.len() <= 3, "iterations [warmup]");
    let iterations = argument(&args, 1, 5_000_000);
    let warmup = argument(&args, 2, 10_000);
    let warmup_total = run(warmup);
    let start = Instant::now();
    let total = run(iterations);
    let elapsed = start.elapsed().as_nanos();
    println!("elapsed_ns={elapsed} checksum={total} warmup_checksum={warmup_total}");
}

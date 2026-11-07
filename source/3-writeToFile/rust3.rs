use std::{env, fs::File, io::Write, time::Instant};
fn argument(args: &[String], index: usize, fallback: usize) -> usize {
    let value = args
        .get(index)
        .map(|s| s.parse::<usize>().expect("Invalid count"))
        .unwrap_or(fallback);
    assert!(value <= 2147483647, "Count is too large");
    value
}
fn run(iterations: usize) -> std::io::Result<usize> {
    let template = "test_text\n";
    let mut result = String::new();
    let mut count = 0;
    while count < iterations {
        result.push_str(template);
        count = count + 1;
    }
    let mut file = File::create("./store/rust.txt")?;
    file.write_all(result.as_bytes())?;
    file.flush()?;
    drop(file);
    Ok(result.len())
}
fn main() -> std::io::Result<()> {
    let args: Vec<String> = env::args().collect();
    assert!(args.len() <= 3, "lines [warmup_lines]");
    let iterations = argument(&args, 1, 80000000);
    let warmup = argument(&args, 2, 10000);
    let warmup_bytes = run(warmup)?;
    let start = Instant::now();
    let bytes = run(iterations)?;
    let elapsed = start.elapsed().as_nanos();
    println!("elapsed_ns={elapsed} bytes={bytes} warmup_bytes={warmup_bytes}");
    Ok(())
}

use std::fs::File;
use std::io::{Write, BufWriter};
use std::process::Command;

fn main() {

    let mut count         : i64    = 0;
    let path              = String::from("./store/rust.txt");
    let template_string   = String::from("test_text\n");
    let mut result_string = String::from("");

    while count < 8000000 {
        result_string.push_str(&template_string);
        count = count + 1;
    }

    let f = File::create(path).expect("Unable to create file");
    let mut f = BufWriter::new(f);
    f.write_all(result_string.as_bytes()).expect("Unable to write data");

    
    let output = Command::new("rustc").arg("--version").output().expect("failed to execute process");
    println!("{}", String::from_utf8_lossy(&output.stdout));
}
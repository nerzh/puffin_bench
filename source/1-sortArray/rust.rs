use std::process::Command;
use std::env;

// PAYLOAD
fn shells_sort(arr: &mut [i64]) {
    let n        : i64 = arr.len() as i64;
    let mut gap  : i64 = n/2;
    
    while gap > 0 {
        let mut i : i64 = gap.clone();
        while i < n {
            let temp : i64 = arr[i as usize].clone();
            let mut j : i64 = i.clone();
            while j >= gap && arr[(j - gap) as usize] > temp {
                arr[j as usize] = arr[(j - gap) as usize].clone();
                j      = j - gap;
            }
            arr[j as usize] = temp.clone();
            i      = i + 1;
        }
        gap = gap/2;
    }
}

// TEST
fn main() {
    let mut arr : [i64; 10] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
    let mut c   : i64       = 0;
    let mut c2  : i64       = 0;
    let i       : i64       = env::args().nth(1).unwrap().parse::<i64>().unwrap();

    while c < i  {
        while c2 < 10 {
            arr[c2 as usize] = 9 - c2;
            c2 = c2 + 1;
        }
        shells_sort(&mut arr);
        c  = c + 1;
        c2 = 0;
    }
    
    let output = Command::new("rustc").arg("--version").output().expect("failed to execute process");
    println!("{}", String::from_utf8_lossy(&output.stdout));
}
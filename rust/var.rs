use std::{f32, f64, i16, i32, i64, i8, isize, u16, u32, u64, u8, usize};

use std::io::stdin;

fn main() {// 主函数
    let num = 9; // 变量 默认不可变
    let mut age: i32 = 17; // 变量可变
    age += 1; // 分号少不了
    let let_x: char = 'x'; // 单引号才能编译
    let is_it_true: bool = true;
    let (_first_name, _last_name) = ("sara", "liu");

    println!("It is {0} that {1} is {0}", is_it_true, let_x);
    println!("{:.2}", 3.1415);
    println!("{} + 1 = {}", num, num + 1);
    println!("my age is {}", age);

    fn twisting() {
        println!("二进制: {:b}, 十六进制: {:x}, 八进制: {:o}", 10, 10, 10);
        println!("{ten:>ws$}", ten = 10, ws = 5);
        println!("{ten:>0ws$}", ten = 10, ws = 5);
    }

    twisting();
    print_type();
    calculator();
    scientific_calc();
}

fn print_type() {
    println!("Max i8 {}", i8::MAX);
    println!("Max i16 {}, Max i32 {}", i16::MAX, i32::MAX);
    println!("Max i64 {0}", i64::MAX);
    println!("Max u8 {0}, Max u16 {1}", u8::MAX, u16::MAX);
    println!("Max u32 {u32}, Max u64 {u64}", u32 = u32::MAX, u64 = u64::MAX);
    println!("Max isize {},  Max usize {}", isize::MAX, usize::MAX);
    println!("Max f32 {}", f32::MAX);
    println!("Max f64 {}", f64::MAX);

    println!("Min i8 {}", i8::MIN);
}

fn calculator() {
    println!("5+4= {}", 5 + 4);
    println!("5-4= {}", 5 - 4);
    println!("5*4= {}", 5 * 4);
    println!("15/4= {}", 15 / 4);
    println!("18%4= {}", 18 % 4);
}

fn scientific_calc() {
    let neg_4 = -4i32;
    println!("abs(-4)= {}", neg_4.abs());
    println!("2^6 = {}", 2i32.pow(6));
    println!("sqrt 9 = {}", 9f64.sqrt());
    println!("27 cbrt 9 = {}", 27f64.cbrt());
    println!("Round 1.45 = {}", 1.45f64.round());
    println!("Floor 1.45 = {}", 1.45f64.floor());
    println!("Ceiling 1.45 = {}", 1.45f64.ceil());
    println!("e ^2 = {}", 2f64.exp());
    println!("log(2)= {}", 2f64.ln());
    println!("log10(2) = {}", 2f64.log10());
    println!("90 to Radians = {}", 90f64.to_radians());
    println!("PI to Degrees = {}", 3.1415f64.to_degrees());
    println!("sin(3.1415) = {}", 3.1415f64.sin());

    println!("Max(4,5) = {}", 4f64.max(5f64));
    println!("Min(4,5) = {}", 4f64.min(5f64));
}

fn main() {
    hi("sara");

    println!("3+9 = {}", get_sum(3, 9));

    let sum = get_sum; // alias

    println!("3+7 = {}", sum(3, 7));

    let sum_nums = |x: i32, y: i32| x + y; //

    println!("6+7 = {}", sum_nums(6, 7));

    let ten = 10;
    let add_10 = |x: i32| x + ten;
    println!("23 add 10: {}", add_10(23));

    let vec1 = vec![1, 2, 3];
    let vec2 = vec1;
    // println!("vec1{:?}", vec1); // value used here after move

    let n1 = 1;

    let n2 = n1;

    println!("n1: {}", n1);
    println!("Sum of Vect: {}", sum_vects(&vec2));
}

fn hi(name: &str) {
    println!("Hello {}", name);
}

fn get_sum(num1: i32, num2: i32) -> i32 {
    let res = num1 + num2;
    return res;
}


fn sum_vects(v1: &Vec<i32>) -> i32 {
    let sum = v1.iter().fold(0, |mut sum, &x| {
        sum += x;
        sum
    });

    return sum;
}

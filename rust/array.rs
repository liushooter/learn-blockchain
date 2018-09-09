fn main() {
    let arr = [1, 2, 3];

    println!("{}", arr[0]);
    println!("{}", arr.len());
    println!("Second : {:?}", &arr[1..3]);

    let mut vect1 = vec![1, 2, 3, 4, 5];
    println!("item 2: {}", vect1[1]);

    for i in &vect1 {
        println!("Vect: {:?}", i);
    }

    vect1.push(6);
    vect1.pop();

    let my_tuple = ("de", 18);

    let my_tuple2: (&str, i8) = ("Derak", 33);

    println!("Name {}", my_tuple2.0);
    println!("Age {}", my_tuple.1);
}

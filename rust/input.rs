use std::io::stdin;

fn main() {
    'outer: loop {
        let number: i32 = 10;
        println!("Pick a Number: ");

        loop {
            let mut line = String::new();
            let input = stdin().read_line(&mut line);

            let guess: Option<i32> = input.ok().map_or(None, |_| line.trim().parse().ok());

            match guess {
                None => println!("enter a number"),

                Some(n) if n == number => {
                    println!("You guessed it");
                    break 'outer;
                }

                Some(n) if n < number => println!("Too Low"),
                Some(n) if n > number => println!("Too Hight"),

                Some(_) => println!("Error"),
            }
        }
    }
}

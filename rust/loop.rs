fn main() {
    let mut x = 1;
    let mut y = 1;

    loop {
        if x % 2 == 0 {
            println!("{}", x);
            x += 1;
            continue;
        }

        if x > 10 {
            break;
        }

        x += 1;
        continue;
    }

    while y <= 10 {
        println!("while {:?}", y);
        y += 1;
    }

    for z in 1..10 {
        println!("For: {:?}", z);
    }

    string_game();
}

fn string_game() {
    let rand_str = "this is random string";

    println!("length: {:?}", rand_str.len());

    let (fir, sec) = rand_str.split_at(6);
    println!("First: {}, Second: {}", fir, sec);

    let count = rand_str.chars().count();
    println!("count {:?}", count);

    let mut chars = rand_str.chars();
    let mut indiv_char = chars.next();

    loop {
        match indiv_char {
            Some(x) => println!("{}", x),
            None => break,
        }
        indiv_char = chars.next();
    }

    let mut iter = rand_str.split_whitespace();
    let mut indiv_word = iter.next();

    loop {
        match indiv_word {
            Some(x) => println!("{}", x),
            None => break,
        }
        indiv_word = iter.next();
    }

    let rand_str2 = "一时（いちじ）	二时（にじ）	三时（さんじ）四时（よじ）	五时（ごじ）	六时（ろくじ）\n 七时（しちじ）	八时（はちじ）	九时（くじ）	十时（じゅうじ）	十一时（じゅういちじ）	十二时（じゅうにじ）";
    let mut lines = rand_str2.lines();
    let mut indiv_line = lines.next();

    loop {
        match indiv_line {
            Some(x) => println!("{}", x),
            None => break,
        }

        indiv_line = lines.next();
    }

    println!("find い : {}", rand_str2.contains("い"));
}

fn main() {
    let mut c1 = Circle {
        x: 10.0,
        y: 10.0,
        radius: 25.0,
    };

    println!("X: {}, Y: {}, radius: {}", c1.x, c1.y, c1.radius);

    println!("Circle radius: {}", get_radius(&c1));

    println!("Circle X: {}", &c1.get_x());

    println!("Circle area: {}", &c1.area());

    let mut rect = Rectangle { h: 18.0, w: 32.0 };

    println!("rect area: {}", &rect.area());

    let hulk = Hero::Strong(100);
    let quickSilver = Hero::Fast;
    let spiderMan = Hero::Info {
        name: "spiderman".to_owned(),
        secret: "peter parker".to_owned(),
    };

    get_info(hulk);
    get_info(quickSilver);
    get_info(spiderMan);
}

struct Circle {
    x: f64,
    y: f64,
    radius: f64,
}

fn get_radius(circle: &Circle) -> f64 {
    circle.radius
}

impl Circle {
    pub fn get_x(&self) -> f64 {
        self.x
    }
}

struct Rectangle {
    h: f64,
    w: f64,
}

trait HasArea {
    fn area(&self) -> f64;
}

impl HasArea for Circle {
    // add code here
    fn area(&self) -> f64 {
        return 3.14159 * (self.radius * self.radius);
    }
}

impl HasArea for Rectangle {
    // add code here
    fn area(&self) -> f64 {
        return self.h * self.w;
    }
}

enum Hero {
    Fast,
    Strong(i32),
    Info { name: String, secret: String },
}

fn get_info(h: Hero) {
    match h {
        Hero::Fast => println!("Fast"),
        Hero::Strong(i) => println!("Lifts {} tons", i),
        Hero::Info { name, secret } => {
            println!("{} is {}", name, secret);
        }
    }
}

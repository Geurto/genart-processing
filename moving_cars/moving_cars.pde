Car[] cars;
int numCars = 1000;

class Car {
  color c;
  float car_length;
  float car_width;
  float xpos;
  float ypos;
  float speed;
  float speed_direction;
  boolean horizontal;
  
  Car() {
    this.car_length = random(10, 50);
    this.car_width = this.car_length * random(0.2, 0.5);
    float size_factor = (this.car_length*this.car_width) / (50 * 25);  // size divided by max_size
    float hue = 360*size_factor + 5*randomGaussian();
    this.c = color(hue, random(50), random(40, 90), 1.0);
    this.xpos = width/2 + (width/8) * randomGaussian();
    this.ypos = height/2 + (height/8) * randomGaussian();
    this.speed = randomGaussian() * 40/(this.car_length * this.car_width);
    
    // Determine direction of movement
    float f = random(0, 1);
    if (f > 0.75) {
      this.speed_direction = 1;
      this.horizontal = true;
    } else if (f > 0.5) {
      this.speed_direction = -1;
      this.horizontal = true;
    } else if (f > 0.25) {
      this.speed_direction = 1;
      this.horizontal = false;
    } else {
      this.speed_direction = -1;
      this.horizontal = false;
    }
    println("Set up new car with hue " + hue + ", position " + this.xpos + this.ypos + ", speed " + this.speed);
  }

  void move() {
    this.xpos = this.xpos + this.speed * this.speed_direction;
    if (this.xpos > width && this.speed_direction == 1) {
      this.xpos = 0;
    } else if (this.xpos < 0 && this.speed_direction == -1) {
      this.xpos = width;
    }
  }

  void display() {
    fill(c);
    noStroke();
    rect(this.xpos,this.ypos,this.car_length,this.car_width);
    
    // Draw car on other side when it falls off the map
    if (this.xpos > width - this.car_length && this.speed_direction == 1) {
      rect(0, this.ypos, this.car_length-(width-this.xpos), this.car_width);
    } else if (this.xpos < this.car_length && this.speed_direction == -1) {
      rect(width-(this.xpos-this.car_length), this.ypos, this.car_length-this.xpos, this.car_width);
    }
  }
}


void setup() {
  size(1600, 400);
  colorMode(HSB, 360, 100, 100, 1.0);
  
  cars = new Car[numCars];
  for (int i = 0; i < cars.length; i++) {
    cars[i] = new Car();
  }
}

void draw() {
  background(210, 50, 100, 1.0);
  for (int i = 0; i < cars.length; i++) {
    cars[i].move();
    cars[i].display();
  }
}

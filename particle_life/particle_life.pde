World world;

void setup() {
  fullScreen();
  colorMode(HSB, 360, 100, 100, 1.0);
  world = new World(5, 500);
}

void draw() {
  background(0, 0, 0);
  world.step();
  world.draw();
}
World world;
int num_types = 6;
int particles_per_type = 500;
int particle_size = 5;

void setup() {
  fullScreen();
  colorMode(HSB, 360, 100, 100, 1.0);
  world = new World(num_types, particles_per_type, particle_size);
  world.createParticles();
}

void draw() {
  background(0, 0, 0);
  world.step();
  world.draw();
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      for (int i = 0; i < num_types; i++) {
        world.addParticles(i, 100);
      }
    } else if (keyCode == DOWN) {
      world.removeRandomParticles(100);
    }
  } else {
    if (keyCode == ENTER) {
      world.restart();
    }
  }
}

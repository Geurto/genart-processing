class World {
  ArrayList<Particle> particles = new ArrayList<Particle>();
  RegionGraph regions;
  int num_colors, num_particles;
  int particle_size;
  float[][] attractions, min_dist, max_dist;
  
  World(int num_colors, int num_particles, int particle_size) {
    this.num_colors = num_colors;
    this.num_particles = num_particles;
    this.particle_size = particle_size;
  }
  
  void restart() {
    this.particles.clear();
    this.createParticles();
    this.createRegions();
  }
  
  void createRegions() {
    /* Region size should AT LEAST be the maximum attraction distance, so that any interacting particles are at most 1 region apart.
     * so num_columns = floor(width / MAX_DIST) etc. 
     */
    float d_max = 0;
    for (int t = 0; t < this.num_colors; t++) {
      float m = max(this.max_dist[t]);
      if (m > d_max) { d_max = m; }
    }

    int num_columns = floor(width / d_max);
    int num_rows = floor(height / d_max);
    this.regions = new RegionGraph(num_columns, num_rows);
    
    for (Particle p: this.particles) {
      Region r = this.regions.getRegion(p.x, p.y);
      r.particles.add(p);
    }
  }
  
  void createParticles() {
    // generate random attractions to other colours, as well as min/max distance for attractions
    this.attractions = new float[this.num_colors][this.num_colors];
    this.min_dist = new float[this.num_colors][this.num_colors];
    this.max_dist = new float[this.num_colors][this.num_colors];
    
    this.randomizeWeights();
    
    for (int c = 0; c < this.num_colors; c++) {
      this.addParticles(c, this.num_particles);
    }
  }
  
  void randomizeWeights() {
    for (int c = 0; c < this.num_colors; c++) {
      for (int i = 0; i < num_colors; i++) {
        attractions[c][i] = 0.25 * int(random(-4, 4));
        this.min_dist[c][i] = this.particle_size * random(1, 2);
        this.max_dist[c][i] = this.particle_size * random(5, 20);
      }
    }
    this.createRegions();
  }
  
  void addParticles(int type, int num_particles) {
    for (int p = 0; p < num_particles; p++) {
        this.particles.add(new Particle(type, this.num_colors, this.particle_size));
      }
  }
  
  void removeRandomParticles(int n) {
    for (int i = 0; i < n; i++) {
      if (this.particles.size() == 0) { break; }
      int index_to_remove = int(random(this.particles.size()));
      this.particles.remove(index_to_remove);
    }
  }
  
  void calculateInteraction(Particle p, Particle q) {
    float d_min = this.min_dist[p.type][q.type];
    float d_max = this.max_dist[p.type][q.type];
    
    // calculate forces between particles
    float dx = q.x - p.x;
    float dy = q.y - p.y;
    float dist = dist(p.x, p.y, q.x, q.y);
    
    if ((dist < 0.01) || (dist > d_max)) {
      return;
    }
    
    float f;
    if (dist > d_min) {
      f = this.attractions[p.type][q.type] * (1.0 - (2.0 * abs(dist - 0.5 * (d_max + d_min)) / (d_max - d_min)));
    } else {
      f = 2 * p.size * d_min * (1 / (d_min + 2 * p.size) - 1 / (dist + 2 * p.size));
    }
    p.vx += f * dx / dist;
    p.vy += f * dy / dist;
  }
  
  void step() {
    for (int i = 0; i < this.particles.size(); i++) {
      Particle p = this.particles.get(i);
      Region r = this.regions.getRegion(p.x, p.y);
      
      for (Particle q: r.particles) {
        this.calculateInteraction(p, q);
      }
      
      for (Region n: r.neighbours) {
        for (Particle q: n.particles) {
          this.calculateInteraction(p, q);
        }
      }
      p.step();  // step particle
      Region r_new = this.regions.getRegion(p.x, p.y);
      r_new.buffer.add(p);
    }
    
    for (Region r: this.regions.graph) {
      r.particles.clear();
      r.particles.addAll(r.buffer);
      r.buffer.clear();
    }
  }
  
  void draw() {
    background(0, 0, 0);
    for (int rr = 0; rr < this.regions.n_rows; rr++) {
      stroke(255);
      line(0, rr * this.regions.region_height, width, rr * this.regions.region_height);
    }
    for (int rc = 0; rc < this.regions.n_cols; rc++) {
      stroke(255);
      line(rc * this.regions.region_width, 0, rc * this.regions.region_width, height);
    }
    stroke(0);
    for (int i = 0; i < this.particles.size(); i++) {
      Particle part = this.particles.get(i);
      part.draw();
    }
  }
}

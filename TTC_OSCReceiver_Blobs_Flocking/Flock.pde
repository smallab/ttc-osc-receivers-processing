  class Flock {
  ArrayList<Boid> boids;

  Flock() {
    boids = new ArrayList<Boid>();
  }
  
  void run() {
    //Define a random direction in which the group will go
    PVector target = new PVector(random(width), random(height));
    for (Boid b : boids) {
      b.run(boids, predators, target);
    }
  }

  void addBoid(Boid b) {
    boids.add(b);
  }
}

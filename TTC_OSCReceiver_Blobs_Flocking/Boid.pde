class Boid {
  PVector location;
  PVector velocity;
  PVector acceleration;
  float r;

  float maxForce;
  float maxSpeed;

  Boid(float x, float y) {
    acceleration = new PVector();
    velocity = new PVector(random(-1, 1), random(-1, 1));
    location = new PVector(x, y);
    r = 5.0; //size of the boid
    maxSpeed = 4;
    maxForce = 0.1;
  }
  
  //Standard 'Euler integration' model
  void update() {
    velocity.add(acceleration);
    velocity.limit(maxSpeed);
    location.add(velocity);
    acceleration.mult(0);
  }
  
  //Newton's second law
  void applyForce(PVector force) {
    acceleration.add(force);
  }
  
  //Steering algorithm
  PVector seek(PVector target) {
    PVector desired = PVector.sub(target, location);
    desired.normalize();
    desired.mult(maxSpeed);
    desired.sub(velocity);
    desired.limit(maxForce);
    return desired;
  }
  
  //Stay inside the window
  PVector checkEdges() {
    //Left edge
    if (location.x < 25) {
      PVector desired = new PVector(maxSpeed, velocity.y); //Retain y speed but flee in x at maxSpeed
      desired.sub(velocity);
      desired.limit(maxForce);

      return desired;
    }

    //Right edge
    if (location.x > width-25) {
      PVector desired = new PVector(-maxSpeed, velocity.y);
      desired.sub(velocity);
      desired.limit(maxForce);

      return desired;
    }

    //Top edge
    if (location.y < 25) {
      PVector desired = new PVector(velocity.x, maxSpeed);
      PVector steer = PVector.sub(desired, velocity);
      steer.limit(maxForce);

      return steer;
    }

    //Bottom edge
    if (location.y > height-25) {
      PVector desired = new PVector(velocity.x, -maxSpeed);
      desired.sub(velocity);
      desired.limit(maxForce);

      return desired;
    }

    return new PVector();
  }
  
  //Prevent boids from being to close to one another
  PVector separate(ArrayList<Boid> boids) {
    float desiredSeparation = r*5; //This variable specifies how close is too close
    PVector sum = new PVector();
    int count = 0;

    for (Boid other : boids) {
      float d = PVector.dist(location, other.location);

      //d>0 makes sure the boid doesn't separate from itself
      if ((d > 0) && (d < desiredSeparation)) {
        PVector diff = PVector.sub(location, other.location);
        diff.normalize();

        //Scale the flee-vector based on how close the other boid is
        diff.div(d); 

        //Calculate the average diff
        sum.add(diff);
        count++;
      }
    }

    //Make sure there's at least one close boid
    if (count > 0) {
      sum.div(count);
      sum.setMag(maxSpeed);
      sum.sub(velocity);
      sum.limit(maxForce); 

      return sum;
    } else return new PVector();
  }
  
  //Stay close to the group
  PVector cohesion(ArrayList<Boid> boids) {
    float neighbourDist = 50; //Distance at which the boid can see the other boids 

    PVector sum = new PVector();
    int count = 0;
    for (Boid other : boids) {
      float d = PVector.dist(location, other.location);

      if ((d > 0) && (d < neighbourDist)) {
        sum.add(other.location);
        count++;
      }
    }

    if (count > 0) {
      sum.div(count);
      return seek(sum);
    } else return new PVector();
  }

  //Align with the rest of the surrouding group
  PVector align(ArrayList<Boid> boids) {
    float neighbourDist = 50; //Distance at which the boid can see the other boids 

    PVector sum = new PVector();
    int count = 0;
    for (Boid other : boids) {
      float d = PVector.dist(location, other.location);

      if ((d > 0) && (d < neighbourDist)) {
        sum.add(other.velocity);
        count++;
      }
    }

    if (count > 0) {
      sum.div(count);
      sum.normalize();
      sum.mult(maxSpeed);

      sum.sub(velocity);
      sum.limit(maxForce);
      return sum;
    } else return new PVector();
  }
  
  //Steer away from existing blobs, called Predators here
  PVector avoidPredators(ArrayList<Predator> predators) {
    float desiredSeparation = r*20; //This variable specifies how close is too close
    PVector sum = new PVector();
    int count = 0;

    for (Predator p : predators) {
      float d = PVector.dist(location, p.location);

      //d>0 makes sure the boid doesn't separate from itself
      if ((d > 0) && (d < desiredSeparation)) {
        PVector diff = PVector.sub(location, p.location);
        diff.normalize();

        //Scaling the flee-vector based on how close the other boid is
        diff.div(d); 

        //Calculate the average diff
        sum.add(diff);
        count++;
      }
    }

    //Make sure there's at least one close boid
    if (count > 0) {
      sum.div(count);
      sum.setMag(maxSpeed);
      sum.sub(velocity);
      sum.limit(maxForce); 

      return sum;
    } else return new PVector();
  }
  
  //React to the environment and to ohter boids
  void flock(ArrayList<Boid> boids, ArrayList<Predator> predators, PVector target) {
    //The 3 flocking rules
    PVector sep = this.separate(boids);
    PVector coh = this.cohesion(boids);
    PVector ali = this.align(boids);

    //Target-seeking and stay-inside-the-window rule
    PVector seek = this.seek(target);
    PVector edges = this.checkEdges();

    //Scale forces
    seek.mult(0.5);
    sep.mult(3);
    edges.mult(1.5);
    coh.mult(1);
    ali.mult(1.0);

    //Apply Forces
    this.applyForce(ali);
    this.applyForce(coh);
    this.applyForce(sep);

    //If there are any predators avoid them fast (fast meaning with great steering force in our algorithm)
    if (predators.size() >=1) {
      PVector pre = this.avoidPredators(predators);
      pre.mult(3);
      this.applyForce(pre);
    }

    this.applyForce(seek);
    this.applyForce(edges);
  }
  
  //Combine everything in one method to beautify the code
  void run(ArrayList<Boid> boids, ArrayList<Predator> predators, PVector target) {
    flock(boids, predators, target);
    this.update();
    this.display();
  }
  
  //Defining boid shape and orientation based on a size (r) and the direction of the speed vector
  void display() {
    float theta = velocity.heading() + PI/2;
    fill(190);
    noStroke();

    pushMatrix();
    translate(location.x, location.y);
    
    rotate(theta);
    beginShape();
    vertex(0, -r*2);
    vertex(-r, r*2);
    vertex(r, r*2);
    endShape(CLOSE);
    popMatrix();
    
  }
}

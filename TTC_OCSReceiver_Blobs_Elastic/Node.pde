class Node {

  PVector position, initialPos, velocity;
  float distance, maxSpeed = 15.0;
  int taille, rang;
  int initialIndex, currentIndex;
  float t;
  color coulour;
  Boolean first = true, transmit = false;


  Node (PVector _position, int _taille, color _coulour) {
    this.initialPos = PVector.add(_position, new PVector(random(-10, 10), random(-10, 10)));
    this.position = this.initialPos.copy();
    this.velocity = new PVector();
    this.distance = 25;
    this.taille = _taille;
    this.coulour = _coulour;
  }
  
  // Set index before any sorting has happened
  void setInitialIndex(int i) {
    this.initialIndex = i;
  }
  
  // Move the node
  void update() {
    this.position.add(this.velocity);
  }
  
  // Add the acceleration to the speed to see the impact on the node
  void applyForce(PVector force) {
    this.velocity.add(force);
  }

  void arrive(PVector target, float limit_value, boolean auth) {
    PVector desired = PVector.sub(target, this.position);
    
    // Limit $desired$ to a certain value so that the nodes don't go flying across the window
    if (auth) {
      desired.normalize();
      desired.mult(maxSpeed);
    }
    
    PVector steer = PVector.sub(desired, this.velocity);
    steer.limit(limit_value); //maxforce
    applyForce(steer);
  }
}

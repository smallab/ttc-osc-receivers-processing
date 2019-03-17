class Particle {

  PVector velocity;
  ArrayList<PVector> forces = new ArrayList<PVector>();
  float lifespan = 255;
  PShape partShape;
  float partSize;
  color couleur;

  Particle(PVector origin) {
    partSize = random(10,60);
    partShape = createShape();
    partShape.beginShape(QUAD);
    partShape.noStroke();
    partShape.texture(sprite);
    partShape.normal(0, 0, 1);
    partShape.vertex(-partSize/2, -partSize/2, 0, 0);
    partShape.vertex(+partSize/2, -partSize/2, sprite.width, 0);
    partShape.vertex(+partSize/2, +partSize/2, sprite.width, sprite.height);
    partShape.vertex(-partSize/2, +partSize/2, 0, sprite.height);
    partShape.endShape();
    
    rebirth(origin);
    lifespan = random(255);
  }

  PShape getShape() {
    return partShape;
  }
  
  void render() {
    shape(partShape);
  }
  
  void rebirth(PVector origin) {
    float a = random(TWO_PI);
    float speed = random(0.5,4);
    velocity = new PVector(cos(a), sin(a));
    velocity.mult(speed);
    lifespan = 255;
    partShape.resetMatrix();
    partShape.translate(origin.x, origin.y); 
    int color_index = int(random(3));
    couleur = colors[color_index];
    partShape.setTint(couleur);
  }
  
  boolean isDead() {
    if (lifespan < 0) {
     return true;
    } else {
     return false;
    } 
  }
  
  void addForce(int index, PVector force){
    forces.add(index, force);
  }
  void setForce(int index, PVector force){
    forces.set(index, force);
  }
  void applyForces() {
    for (PVector f : forces) {
      velocity.add(f);
    }
  }

  void update() {
    lifespan = lifespan - 1;
    applyForces();
    
    partShape.setTint(color(red(couleur), green(couleur), blue(couleur), lifespan));
    partShape.translate(velocity.x, velocity.y);
  }
}

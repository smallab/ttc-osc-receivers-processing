class WanderingSoot {
  // Single wandering soot
  
  float angleCos = 1.0;
  float angleSin = 1.0;
  float speed_x, speed_y;
  boolean sizeChange = true;
  int rand;
  PVector speedP = new PVector(0,0);
  PVector ref = new PVector(0,1);
  Vec2 pos, speed;
  
  Body noiraudeBody;
  
  WanderingSoot(float speedIndex) {
    //Defining Body at random location and random speed
    Vec2 location = box2d.coordPixelsToWorld((random(width-50)),(random(height-50))); 
    
    speed = new Vec2(random(speedIndex),random(speedIndex));
    
    BodyDef noiraude = new BodyDef();
    noiraude.type = BodyType.DYNAMIC;
    noiraude.position.set(location);
    noiraude.fixedRotation = true;
    noiraude.linearDamping = 0;
    
    // If object as a tendency to change suddenly and rapidly it's best to tell box2d to pay closer attention to it's speed by uncommenting the following line
    //noiraude.bullet = true;
    
    // Creating Body
    noiraudeBody = box2d.createBody(noiraude);
    noiraudeBody.setLinearVelocity(speed);
    
    // Defining Shape
    CircleShape cs = new CircleShape();
    float radius = box2d.scalarPixelsToWorld(15);
    cs.m_radius = radius;
    
    // Defining Fixture
    FixtureDef fd = new FixtureDef();
    fd.shape = cs;
    fd.density = 1;
    fd.friction = 0.4; //0
    fd.restitution = 1; //0.4
    
    // Assigning all defs to body
    noiraudeBody.createFixture(fd);
    
    // Exctracting position in pixel coordinates
    pos = box2d.getBodyPixelCoord(noiraudeBody);
    
  }
  
  void display() {
    // Exctracting position and speed
    pos = box2d.getBodyPixelCoord(noiraudeBody);
    speed = noiraudeBody.getLinearVelocity();
    
    // Assigning each coordinates of a Vec2 to a PVector
    speedP.x = speed.x;
    speedP.y = speed.y;
    
    // Calculating the angle at which to orient the eyes
    float alpha;
    if (speedP.x <= 0) {
      alpha = PVector.angleBetween(speedP,ref);
    } else {
      alpha = -PVector.angleBetween(speedP,ref);
    }
    
    angleCos = cos(alpha);
    angleSin = sin(alpha);
    
    //Display the soot
    this.Body();
    this.Eye();
    this.Iris();
  } 
  
  void Body() {
    // Creates the body of the soot
    noStroke();
    fill(#D0E7F7);
    
    // Make it flicker a bit
    if (sizeChange == true) {
      rand = int(random(3));
      sizeChange = false;
    } else {
      sizeChange = true;
    }
    
    ellipse(pos.x,pos.y,size+rand,size+rand);
  }
  
  void Eye() {
    // Creating the white part of the eyes of the soot and orienting in perpendicular to the direction it's moving
    noStroke();
    fill(255);
    ellipse(pos.x-4*angleCos,pos.y+4*angleSin,11,11);
    ellipse(pos.x+4*angleCos,pos.y-4*angleSin,11,11);
  }
  
  void Iris() {
    // Creating and orienting the black part of the eyes of the soot 
    noStroke();
    fill(0);
    ellipse(pos.x-3.5*angleCos,pos.y+3.5*angleSin,4,4);
    ellipse(pos.x+3.5*angleCos,pos.y-3.5*angleSin,4,4);
  }
  
  void isTossed() {
    // Checking for soots outside the window (who might have been ejected by a blob)
    if ((pos.x > width) || (pos.x < 0) || (pos.y < 0) || (pos.y > height)) {
      numberTossed += 1;
      tossed = true;
    }
  }
  
  void killBody() {
    // Allows to delete the soot from sootSystem
    box2d.destroyBody(this.noiraudeBody);
  }
}

class Drop {
  // Creates a class for the drops which soots are meant to bounce off of
  
  float x,y,w,h,m;
  float stepCounter = 0;
  
  Body Drop;
  
  Drop(float _x, float _y, float _w, float _h) {
    
    x = _x;
    y = _y;
    w = _w;
    h = _h;
    m = (w + h)/2;
    
    // Defining drop body
    BodyDef drop = new BodyDef();
    drop.position.set(box2d.coordPixelsToWorld(x,y));
    drop.type = BodyType.KINEMATIC;
    Drop = box2d.createBody(drop);
    
    //Circular drops
    CircleShape cs = new CircleShape();
    cs.m_radius = box2d.scalarPixelsToWorld(m/2);
    
    FixtureDef fd = new FixtureDef();
    fd.shape = cs;
    fd.density = 1;
    fd.friction = 0;
    fd.restitution = 15;
    
    Drop.createFixture(fd); 
  }
  
  void display() {
    // Shadow
    noStroke();
    fill(#EBC52E);
    ellipse(x+5,y+5,m,m); // Slight shift of x and y so that it creates a drop shadow
    
    // Actual blob
    noStroke();
    fill(#FFDF37);
    ellipse(x,y,m,m); 
  }
  
  void countingSteps() {
    // Counting every World's time step so that the drop can be killed a few steps after it's been created
    stepCounter += 1; 
    
    if (stepCounter >= 5) {
      box2d.destroyBody(Drop);
      autho = true;
    }
  }
}

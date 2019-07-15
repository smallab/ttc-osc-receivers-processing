class Boundary {
  // Creates the immovable objects that define the edges of the window

  ArrayList<Vec2> surface = new ArrayList<Vec2>();


  Boundary() {
    // Hard-coding the vertices for the boundary which is meant to be a rounded rectangle
    surface.add(new Vec2(15, 15));
    surface.add(new Vec2(width-15, 15));
    surface.add(new Vec2(width-15, height-15));
    surface.add(new Vec2(15, height-15));
    surface.add(new Vec2(15, 15));

    //Defining coords in World
    ChainShape chain = new ChainShape();
    Vec2[] vertices = new Vec2[surface.size()];

    for (int i = 0; i < surface.size(); i++) {
      vertices[i] = box2d.coordPixelsToWorld(surface.get(i));
    }
    chain.createChain(vertices, vertices.length);

    //Making it a body
    BodyDef bd = new BodyDef();
    bd.type = BodyType.STATIC;
    Body body = box2d.createBody(bd);
    body.createFixture(chain, 1);
  }

  void display() {
    noStroke();
    fill(#2D228A); //the actual background color
    rect(width/2,height/2, width-30, height-30, 10); // Rounded rectangle
  }
}

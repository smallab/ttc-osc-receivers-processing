void renderControlPanel() {
  controlPanel.beginDraw();
  controlPanel.blendMode(ADD);
  controlPanel.background(color(255, 15));
  // draw an arrow representing the wind force
  drawArrow(wind, new PVector(controlPanel.width/2.0, controlPanel.height/2.0+10));
  drawArrow(gravity, new PVector(controlPanel.width/2.0, controlPanel.height/2.0+10));
  // monitor frameRate, particles.size()
  controlPanel.textSize(12);
  controlPanel.textAlign(CENTER);
  controlPanel.text("frameRate: " + int(frameRate), controlPanel.width/2.0, 15);
  controlPanel.text("particle count: " + int(particles.size()), controlPanel.width/2.0, 30);
  controlPanel.endDraw();
}

// Renders a vector object 'v' as an arrow and a position 'loc'
void drawArrow(PVector v, PVector loc) {
  // Calculate length of vector, scale & limit it
  float len = constrain(v.mag()*500, 10, 50);

  // Create the shape group
  PShape arrow = createShape(GROUP);
  // Make two shapes
  controlPanel.ellipseMode(CORNER);
  PShape head = createShape(TRIANGLE, -15, len+10, 15, len+10, 0, len+25);
  head.setFill(color(255, 50));
  PShape body = createShape(RECT, -7.5, 10, 15, len);
  //body.scale(len);
  body.setFill(color(255, 50));
  // Add the two "child" shapes to the parent group
  arrow.addChild(body);
  arrow.addChild(head);

  // position and draw
  controlPanel.pushMatrix();
  // Translate to position to render vector
  controlPanel.translate(loc.x, loc.y);
  // Call vector heading function to get direction (note that pointing up is a heading of 0) and rotate
  arrow.rotate(v.heading());
  arrow.rotate(-PI/2.0);
  // draw
  controlPanel.shape(arrow);
  controlPanel.popMatrix();
}

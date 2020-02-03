class Predator {
  int offsetFC;
  boolean killable = false;
  PVector location = new PVector(), velocity;

  Predator(float _x, float _y) {
    location.x = _x;
    location.y = _y;
    offsetFC = frameCount;
  }
  
  //Check if a predator should still be alive (based on frameCount)
  void checkLife() {
    if (frameCount - offsetFC > 25) {
      killable = true;
    }
  }

  //Make a progressively growing circle
  void draw() {
    int t = frameCount - offsetFC;
    fill(190, 75);
    noStroke();
    ellipse(location.x, location.y, t*65/25, t*65/25);
  }
}

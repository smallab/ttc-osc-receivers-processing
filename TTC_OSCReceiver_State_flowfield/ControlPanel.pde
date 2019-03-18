void renderControlPanel() {
  controlPanel.beginDraw();
  controlPanel.blendMode(ADD);
  controlPanel.background(color(0, 50));
  // monitor frameRate
  controlPanel.textSize(12);
  controlPanel.textAlign(CENTER);
  controlPanel.text("frameRate: " + int(frameRate), controlPanel.width/2.0, 25);
  controlPanel.endDraw();
}

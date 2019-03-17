/**
 *  OSC Blobs Receiver – Particles
 *  https://github.com/smallab/ttc-osc-receivers-processing
 *
 *  Created for Tapioca Toys Cardboard
 *  https://tapioca.toys/cardboard
 *  
 *  Receives OSC messages from the OSC Blobs iPhone app
 *  https://itunes.apple.com/fr/app/osc-blobs-tapioca-toys/id1436978667?mt=8
 *  
 */

import oscP5.*;
import netP5.*;

OscP5 oscP5;
int last_id, latency, concurrent_amount, max_particle_level = 2;
OSCBlob[] blobs;
color[] colors = {color(235, 180, 49), color(199, 200, 196), color(245, 219, 65)};
ParticleSystem ps = new ParticleSystem();
ArrayList<Particle> particles = new ArrayList<Particle>();
PVector gravity, wind;
PImage sprite;  
PGraphics controlPanel;
boolean showControlPanel = true;

void setup() {
  size(720, 400, P2D);
  frameRate(60);
  background(0);
  colorMode(RGB, 255, 255, 255, 100);
  noStroke();
  ellipseMode(CENTER);
  orientation(LANDSCAPE);

  oscP5 = new OscP5(this, 14041);
  last_id = 0;
  latency = 5;
  concurrent_amount = 1024;
  blobs = new OSCBlob[concurrent_amount];

  controlPanel = createGraphics(200, 200);
  sprite = loadImage("sprite.png");
}

void draw() {
  // additive blending
  blendMode(ADD);

  // clear
  background(0);

  // calculate a wind and a gravity force based on mouse position
  float dx = map(mouseX, 0, width, -0.2, 0.2);
  wind = new PVector(dx, 0);
  float dy = map(mouseY, 0, height, -0.1, 0.1);
  gravity = new PVector(0, dy);

  // generate particles according to blobs
  for (int i=0; i<blobs.length-1; i++)
  {
    OSCBlob b = (OSCBlob)blobs[i];
    if (b != null && frameCount <= b.last_update+latency) {
      //PVector diff = PVector.sub(b.location, b.previous_location);
      ps.addParticle(b.location, gravity, wind);
    }
  }

  // update, draw, kill particles
  ps.updateParticles(gravity, wind);
  ps.renderParticles();
  ps.cleanupParticles();

  // show control panel
  if (showControlPanel){
    renderControlPanel();
    image(controlPanel, 0, 0);
  }
}

void keyPressed(){
  if (key == ' ') showControlPanel = !showControlPanel; 
}

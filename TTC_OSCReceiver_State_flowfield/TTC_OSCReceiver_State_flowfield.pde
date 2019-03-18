/**
 *  OSC State Receiver – Flow field
 *  https://github.com/smallab/ttc-osc-receivers-processing
 *
 *  Created for Tapioca Toys Cardboard
 *  https://tapioca.toys/cardboard
 *  
 *  Receives OSC messages from the OSC State iPhone app
 *  
 */

import oscP5.*;
import netP5.*;

OscP5 oscP5;
int last_id, latency, matrix_width, matrix_height, concurrent_amount;
OSCPixel[] osc_pixels;

PGraphics controlPanel;
boolean showControlPanel = true;

// Flowfield object
FlowField flowfield;
// An ArrayList of vehicles
ArrayList<Vehicle> vehicles;

void setup() {
  size(640, 480);
  frameRate(60);
  strokeWeight(0.5);
  rectMode(CENTER);
  
  oscP5 = new OscP5(this, 14041);
  last_id = 0;
  latency = 60;
  matrix_width = 32;
  matrix_height = 24;
  concurrent_amount = matrix_width*matrix_height;
  osc_pixels = new OSCPixel[concurrent_amount];

  for (int i=0; i<concurrent_amount; i++) {
    osc_pixels[i] = new OSCPixel(i, 0);
  }
  
  controlPanel = createGraphics(150, 50);
  
  // Make a new flow field with "resolution"
  flowfield = new FlowField((int)(width/(float)matrix_width));
  vehicles = new ArrayList<Vehicle>();
  // Make a whole bunch of vehicles with random maxspeed and maxforce values
  for (int i = 0; i < 120; i++) {
    vehicles.add(new Vehicle(new PVector(random(width), random(height)), random(2, 5), random(0.1, 0.5)));
  }
}

void draw() {
  background(0);

  pushMatrix();
  translate(width,0);
  scale(-1,1);
  for (int i=0; i<osc_pixels.length-1; i++)
  {
    OSCPixel b = (OSCPixel)osc_pixels[i];
    if (b != null) {
      noStroke();
      fill(b.gray);
      int x = (i%matrix_width);
      int y = floor(i/(float)matrix_width);
      //rect(x*width/(float)matrix_width, y*height/(float)matrix_height, width/(float)matrix_width, height/(float)matrix_height, 4.0);
      flowfield.setAndDisplay(x, y, b.gray);
    }
  }

  // Display the flowfield in "debug" mode
  //flowfield.display();
  // Tell all the vehicles to follow the flow field
  for (Vehicle v : vehicles) {
    v.follow(flowfield);
    v.run();
  }
  popMatrix();

  // show control panel
  if (showControlPanel){
    renderControlPanel();
    image(controlPanel, 0, 0);
  }
}

void keyPressed(){
  if (key == ' ') showControlPanel = !showControlPanel; 
}

// Make a new flowfield
void mousePressed() {
  flowfield.init();
}

void oscEvent(OscMessage theOscMessage) {
  // receive blobs as osc messages
  if (theOscMessage.checkAddrPattern("/tapiocatoys/state"))
  {
    if (theOscMessage.checkTypetag("ii"))
    {
      OSCPixel b = osc_pixels[theOscMessage.get(0).intValue()];
      b.gray = theOscMessage.get(1).intValue();
      return;
    }
  }
}

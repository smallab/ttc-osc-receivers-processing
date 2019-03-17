/**
 *  OSC State Receiver – Basic
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
}

void draw() {
  background(0);

  // Using an enhanced loop to iterate over each entry
  translate(width,0);
  scale(-1,1);
  for (int i=0; i<osc_pixels.length-1; i++)
  {
    OSCPixel b = (OSCPixel)osc_pixels[i];
    if (b != null) {
      noStroke();
      fill(b.gray);
      rect((i%matrix_width)*width/(float)matrix_width, floor(i/(float)matrix_width)*height/(float)matrix_height, width/(float)matrix_width, height/(float)matrix_height, 4.0);
    }
  }
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

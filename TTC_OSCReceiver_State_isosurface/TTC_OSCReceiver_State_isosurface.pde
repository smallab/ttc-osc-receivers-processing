/**
 *  OSC State Receiver – Iso Surface
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

// pshapes
PShape group;
int scale_factor, step;

void setup() {
  size(1024, 768, P3D);
  frameRate(60);

  oscP5 = new OscP5(this, 14041);
  last_id = 0;
  latency = 60;
  matrix_width = 32;
  matrix_height = 24;
  scale_factor = 20;
  step = 1;
  concurrent_amount = matrix_width*matrix_height;
  osc_pixels = new OSCPixel[concurrent_amount];
  for (int i=0; i<concurrent_amount; i++) {
    osc_pixels[i] = new OSCPixel(i, 0);
  }
  
  group = createShape(GROUP);
}

void draw() {
  // create group shape
  group = createShape(GROUP);
  for (int i=0; i<osc_pixels.length-matrix_width*step-1; i+=step)
  {
    // don't draw starting from line endings
    if (i == 0 || (i+step)%(matrix_width) != 0)
    {
      OSCPixel b0 = (OSCPixel)osc_pixels[i];
      OSCPixel b1 = (OSCPixel)osc_pixels[i+step];
      OSCPixel b2 = (OSCPixel)osc_pixels[matrix_width*step+i+step];
      OSCPixel b3 = (OSCPixel)osc_pixels[matrix_width*step+i];

      if (b0 != null)
      {
        int x0 = (i%matrix_width);
        int y0 = floor(i/(float)matrix_width);
        float z0 = b0.gray*0.25;

        int x1 = ((i+step)%matrix_width);
        int y1 = floor((i+step)/(float)matrix_width);
        float z1 = b1.gray*0.25;

        int x2 = ((i+step)%matrix_width);
        int y2 = floor(step + (i+step)/(float)matrix_width);
        float z2 = b2.gray*0.25;

        int x3 = (i%matrix_width);
        int y3 = floor(step + i/(float)matrix_width);
        float z3 = b3.gray*0.25;

        PShape s;
        s = createShape();
        s.beginShape( TRIANGLES );
        s.noStroke();
        s.fill(0, 255-b0.gray, 0);
        s.vertex(x0, y0, z0);
        s.fill(0, 255-b1.gray, 0);
        s.vertex(x1, y1, z1);
        s.fill(0, 255-b2.gray, 0);
        s.vertex(x2, y2, z2);

        s.fill(0, 255-b2.gray, 0);
        s.vertex(x2, y2, z2);
        s.fill(0, 255-b3.gray, 0);
        s.vertex(x3, y3, z3);
        s.fill(0, 255-b0.gray, 0);
        s.vertex(x0, y0, z0);
        s.endShape();
        group.addChild(s);
      }
    }
  }

  // drawing
  background(150);
  lights(); 
  pushMatrix();
  //rotateY(map(frameCount%width, 0, width, 0, TWO_PI));
  rotateY(PI);
  translate(-width/2 - matrix_width*scale_factor/2.0, height/2 - matrix_height*scale_factor/2.0);
  rotateX(-PI/8);
  scale(scale_factor, scale_factor, 2);
  shape(group, 0, 0);
  popMatrix();

  // monitor frameRate
  pushStyle();
  fill(255);
  textSize(12);
  textAlign(LEFT);
  text("frameRate: " + int(frameRate), 25, 25);
  popStyle();
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

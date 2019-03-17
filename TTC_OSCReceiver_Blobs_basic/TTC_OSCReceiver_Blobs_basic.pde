/**
 *  OSC Blobs Receiver – Basic
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
int last_id, latency, concurrent_amount;
OSCBlob[] blobs;

void setup() {
  size(640, 320);
  frameRate(60);
  strokeWeight(0.5);
  rectMode(CENTER);
  ellipseMode(CENTER);
  oscP5 = new OscP5(this, 14041);
  last_id = 0;
  latency = 5;
  concurrent_amount = 1024;
  blobs = new OSCBlob[concurrent_amount];
}

void draw() {
  background(0);

  // Using an enhanced loop to iterate over each entry
  for (int i=0; i<blobs.length-1; i++)
  {
    OSCBlob b = (OSCBlob)blobs[i];
    if (b != null && frameCount <= b.last_update+latency) {
      noStroke();
      fill(255, 230);
      ellipse(b.x, b.y, 3, 3);
      fill(255);
      text("b"+b.id, b.x+10, b.y);
      noFill();
      stroke(255);
      rect(b.x, b.y, b.w, b.h, 4.0);
    }
  }
}

void oscEvent(OscMessage theOscMessage) {
  // receive blobs as osc messages
  if (theOscMessage.checkAddrPattern("/tapiocatoys/blob"))
  {
    if (theOscMessage.checkTypetag("iiiii"))
    {
      if (theOscMessage.get(0).intValue() > last_id) {
        // new blob
        blobs[theOscMessage.get(0).intValue() % concurrent_amount] = new OSCBlob(theOscMessage.get(0).intValue(), theOscMessage.get(1).intValue(), theOscMessage.get(2).intValue(), theOscMessage.get(3).intValue(), theOscMessage.get(4).intValue(), frameCount); 
        // save max id value up until now
        last_id = theOscMessage.get(0).intValue();
      } else {
        // updating existing blob
        OSCBlob b = blobs[theOscMessage.get(0).intValue() % concurrent_amount];
        b.x = theOscMessage.get(1).intValue();
        b.y = theOscMessage.get(2).intValue();
        b.w = theOscMessage.get(3).intValue();
        b.h = theOscMessage.get(4).intValue();
        b.last_update = frameCount;
      }
      return;
    }
  }
}

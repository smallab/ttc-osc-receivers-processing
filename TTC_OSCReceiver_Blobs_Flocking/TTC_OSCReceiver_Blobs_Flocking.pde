/**
 *  OSC Blobs Receiver – Flocking
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

Flock flock;
ArrayList<Predator> predators = new ArrayList<Predator>();
Predators ps = new Predators();

void setup() {
  size(700, 360);
  smooth();
  rectMode(CENTER);
  ellipseMode(CENTER);

  oscP5 = new OscP5(this, 14041);
  last_id = 0;
  latency = 5;
  concurrent_amount = 1024;
  blobs = new OSCBlob[concurrent_amount];

  flock = new Flock();

  //Create a system of 300 boids, each starting at random positions
  for (int i = 0; i < 300; i++) {
    Boid b = new Boid(random(width), random(height));
    flock.addBoid(b);
  }
}

void draw() {
  background(190);
  fill(50);
  noStroke();
  rect(width/2, height/2, (width-20), (height-20), 20); //boundaries

  //Create new predator for every blob
  for (int i=0; i<blobs.length-1; i++)
  {
    OSCBlob b = (OSCBlob)blobs[i];
    if (b != null && frameCount <= b.last_update+latency) {
      if (b.first) {
        Predator p = new Predator(b.x-120, b.y-30);
        ps.addPredator(p);
      }
    }
  }

  //Update size and time-left-to-live for every predator
  if (predators.size() >= 1) {
    ps.updatePredators();
  }

  //Run the flock
  flock.run();
}

void oscEvent(OscMessage theOscMessage) {
  //Receive blobs as osc messages
  if (theOscMessage.checkAddrPattern("/tapiocatoys/blob"))
  {
    if (theOscMessage.checkTypetag("iiiii"))
    {
      if (theOscMessage.get(0).intValue() > last_id) {
        //New blob
        blobs[theOscMessage.get(0).intValue() % concurrent_amount] = new OSCBlob(theOscMessage.get(0).intValue(), theOscMessage.get(1).intValue(), theOscMessage.get(2).intValue(), theOscMessage.get(3).intValue(), theOscMessage.get(4).intValue(), frameCount); 
        //Save max id value up until now
        last_id = theOscMessage.get(0).intValue();
      } else {
        //Updating existing blob
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

/**
 *  OSC Blobs Receiver – Soot
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
import shiffman.box2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;

Box2DProcessing box2d;
OscP5 oscP5;
int last_id, latency, concurrent_amount;
OSCBlob[] blobs;

float size = 30;
wanderingSoot soot;
sootSystem sSystem = new sootSystem();
ArrayList<wanderingSoot> soots = new ArrayList<wanderingSoot>();
ArrayList<Drop> drops = new ArrayList<Drop>();

Boolean autho = false;
int numberTossed;
Boolean tossed = false;
Boundary bnd;


public void settings() {
  size(640,360);
}

void setup() {
  // Initialising the Box2d world
  box2d = new Box2DProcessing(this);
  box2d.createWorld();
  box2d.setGravity(0,0); // No gravity
  
  // Initialising the boundaries of the window
  bnd = new Boundary();
  
  frameRate(60);
  strokeWeight(0.5);
  rectMode(CENTER); 
  ellipseMode(CENTER);
  oscP5 = new OscP5(this, 14041);
  last_id = 0;
  latency = 5;
  concurrent_amount = 1024;
  
  blobs = new OSCBlob[concurrent_amount];
  sSystem.createSystem();
}

void draw() {
  // Checking for misplaced soots, deleting them and recreating them
  sSystem.garbageManagement();
  
  box2d.step(); // Advancing one time step further in the World
  
  // Displaying background and boundaries
  background(#D0E7F7);
  bnd.display();
  
  // Using an enhanced loop to iterate over each entry
  for (int i=0; i<blobs.length-1; i++) {
    OSCBlob b = (OSCBlob)blobs[i];
    if (b != null && frameCount <= b.last_update+latency) {
      Drop dp = new Drop(b.x,b.y,b.w,b.h);
      drops.add(dp);
    }
  }
  
  // Display and updating the blobs if there is at least one
  if (drops.size() >=1) {
    for (int i = 0; i < drops.size(); i++) {
      drops.get(i).countingSteps(); // Making sure to delete the blob after a certain time
      drops.get(i).display();
      
      // Removing the delete blob from the array
      if (autho == true) {
        autho = false; // Sets the authorization to delete the blob back to false so that all of them are not deleted at every step
        drops.remove(i);
      }
    }
  }
  
  //Updating the position and speed of every wandering soot
  sSystem.updateAll();
}

void oscEvent(OscMessage theOscMessage) {
  // Receive blobs as osc messages
  if (theOscMessage.checkAddrPattern("/tapiocatoys/blob"))
  {
    if (theOscMessage.checkTypetag("iiiii"))
    {
      if (theOscMessage.get(0).intValue() > last_id) {
        // New blob
        blobs[theOscMessage.get(0).intValue() % concurrent_amount] = new OSCBlob(theOscMessage.get(0).intValue(), theOscMessage.get(1).intValue(), theOscMessage.get(2).intValue(), theOscMessage.get(3).intValue(), theOscMessage.get(4).intValue(), frameCount); 
        // Save max id value up until now
        last_id = theOscMessage.get(0).intValue();
      } else {
        // Updating existing blob
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

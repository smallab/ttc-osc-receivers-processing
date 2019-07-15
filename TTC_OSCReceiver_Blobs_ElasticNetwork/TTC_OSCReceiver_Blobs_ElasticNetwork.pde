/**
 *  OSC Blobs Receiver – Elastic
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
import megamu.mesh.*;

// Change following line to true to be able to see the blob, the five nearest nodes
// and those linked to these, it helps debug things
Boolean debug = false;

OscP5 oscP5;
int last_id, latency, concurrent_amount;
OSCBlob[] blobs;


Voronoi myMesh;
Delaunay myDelaunay;
ArrayList<Node> nodes;
ArrayList<Node> sortedNodes;
PImage image;


public void settings() {
  size(700, 400);
}

void setup() {
  smooth();

  // Defining and loading the right image
  image = loadImage("donald40.png");

  // Initializing nodes
  nodes = new ArrayList();

  // Fill window based on pixels of the image
  image.loadPixels();
  for (int i = 0; i < image.pixels.length; i ++) {
    PVector position = new PVector ((i%image.width)*33, int(i/image.width)*33);
    nodes.add(new Node(position, 5, color(image.pixels[i])));
  } 

  image.updatePixels();

  // Settings
  frameRate(60);
  strokeWeight(0.5);
  rectMode(CENTER);
  ellipseMode(CENTER);

  // Necessary features for the OSC to work
  oscP5 = new OscP5(this, 14041);
  last_id = 0;
  latency = 5;
  concurrent_amount = 1024;
  blobs = new OSCBlob[concurrent_amount];
}


void draw() {
  // Extract all nodes positions (x and y) and store them in two-dimensional array
  float [][] nodePositions = new float[nodes.size()][2];
  for (int i = 0; i < nodes.size(); i++) {
    nodes.get(i).setInitialIndex(i);

    nodePositions[i][0]=nodes.get(i).position.x;
    nodePositions[i][1]=nodes.get(i).position.y;
  }

  // Creating the Voronoi mesh (for display) and Delaunay mesh (for link-based calculus) 
  // based on nodes positions 
  myMesh = new Voronoi(nodePositions);
  myDelaunay = new Delaunay(nodePositions);

  // Drawing regions
  MPolygon[] myRegions = myMesh.getRegions();
  for (int i = 0; i < myRegions.length; i++) {

    // Filling the regions with the color given by the corresponding node 
    Node node = nodes.get(i);
    fill(node.coulour);

    // Drawing region
    noStroke();
    myRegions[i].draw(this); // Drawing the shape of the region
  }

  // Using an enhanced loop to iterate over each entry
  for (int i = 0; i < blobs.length-1; i++)
  {
    OSCBlob b = (OSCBlob)blobs[i];
    if (b != null && frameCount <= b.last_update+latency) {

      // Set distances to blob for the upcoming sorting based on distance
      for (int j = 0; j < nodes.size(); j++) {
        nodes.get(j).distance = PVector.dist(nodes.get(j).position, new PVector(b.x - 120, b.y - 30));
      }

      // Visualise blob
      if (debug) {
        fill(#f5427b);
        ellipse(b.x-120, b.y - 30, 20, 20);
      }

      // Sort nodes based on proximity to the blob
      nodes = triFusMod(nodes);

      // Assigning new current index and extracting initial index
      int[] initialIndexes = {};

      for (int j = 0; j < nodes.size(); j++) {
        nodes.get(j).currentIndex = j;
        if (j < 5) {
          nodes.get(j).rang = 1;
          initialIndexes = append(initialIndexes, nodes.get(j).initialIndex);
        } else {
          nodes.get(j).rang = 10;
        }
      }

      // Update the five closest to the blob
      for (int j = 0; j < 5; j++) {
        Node nd = nodes.get(j);

        // Define the vector which holds the direction in which the node is ejected
        PVector target = PVector.sub(nd.position, new PVector(b.x - 120, b.y - 30));
        target.mult(10);
        // Define the actual coordiantes of the point defined by the previously defined vector and the original position of the node
        PVector realTarget = new PVector(nd.position.x, nd.position.y).add(target);

        // Apply the force
        nd.arrive(realTarget, 10, true);

        // Visualize the 5 nearest nodes
        if (debug) {
          fill(#aaed7f);
          ellipse(nd.position.x, nd.position.y, 20, 20);
        }

        // Sort the nodes directly linked to those who have a rang = 1
        int indexPrimaryNode = nd.initialIndex;
        int[] links = myDelaunay.getLinked(indexPrimaryNode);
        for (int l : links) {
          for (Node ndS : nodes) {
            // Select all nodes connected to thos of rang = 1 /!\ except those which already
            // have rang = 1, otherwise some of the 5 closest ones would be considered
            // like one of the linked ones
            if ((ndS.initialIndex == l) && (l != initialIndexes[0]) && (l != initialIndexes[1]) && (l != initialIndexes[2]) && (l != initialIndexes[3]) && (l != initialIndexes[4])) {
              ndS.rang = 2; // add a third type rang = 3?

              PVector target_2 = PVector.sub(ndS.initialPos, nd.position);
              target_2.mult(0.7);
              PVector realTarget_2 = PVector.add(ndS.initialPos, target_2);
              ndS.arrive(realTarget_2, 5, true);

              // Visualize the nodes linked to the 5 closest
              if (debug) {
                fill(#4287f5);
                ellipse(ndS.position.x, ndS.position.y, 20, 20);
              }

              break; // No need to go through the rest of the loop
            }
          }
        }
      }
    }
  }

  // Update nodes regardless of the user interaction and the creation of blobs: 
  // nodes exist throughout of the life of the sketch, and they're always impacted by external forces
  for (Node nd : nodes) {
    // Giving that calm, slowly moning water look and making the nodes come back to their original positions
    nd.arrive(PVector.add(nd.initialPos, new PVector(random(-0.7, 0.7), random(-0.5, 0.5))), 3, false);
    nd.update();
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

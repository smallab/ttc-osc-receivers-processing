## An OSC Blobs receiving sample based on Processing that produces a flocking-like, "predator VS preys" behavior
_(freely inspired from the © Daniel Shiffman NOC example)_

A Java-Processing sketch sample specially built for receiving blobs data in the shape of OpenSoundControl messages coming from the [free OSC Blobs iPhone app](https://itunes.apple.com/us/app/osc-blobs-tapioca-toys/id1436978667?mt=8) that's available on the App Store.

It works with [Processing 3.3.4](https://processing.org/download/ "download Processing") and later, and its [OSC library](http://www.sojamo.de/libraries/oscp5).

See it in action: [(VIDEO) OSC Blobs communicating with Processing sample on Mac](https://vimeo.com/388984928 "OSC Blobs communicating with Processing sample on Mac").

Receive everything on the `14041` port number, use `/tapiocatoys/blob` as message pattern and check for a `iiiii` typetag. The first integer is the id of the blob, and the four others are its cartesian position (x,y) based on your phone's resolution as well as the bounding box dimensions (w,h).

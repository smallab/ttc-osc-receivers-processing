## An OSC Blobs receiving Processing sample
A Java-Processing sketch sample specially built for receiving blob data in the shape of OpenSoundControl messages coming from the [free OSC Blobs iPhone app](https://itunes.apple.com/us/app/osc-blobs-tapioca-toys/id1436978667?mt=8) that's available on the App Store.

It works with [Processing 3.3.4](https://processing.org/download/ "download Processing") and later, and its [OSC library](http://www.sojamo.de/libraries/oscp5).

![OSC Blobs communicating with Processing sample on Mac](https://tapioca.toys/assets/img/tapioca-toys-osc-blobs-01.jpg "OSC Blobs communicating with Processing sample on Mac")

Receive everything on the `14041` port number, use `/tapiocatoys/blob` as message pattern and check for a `iiiii` typetag. The first integer is the id of the blob, and the four others are its position vector (x,y) as well as the bounding box dimensions (w,h).

![OSC Blobs communicating with Processing sample on Mac](https://tapioca.toys/assets/img/tapioca-toys-osc-blobs-02.png "OSC Blobs communicating with Processing sample on Mac")

Check out a demo video at https://vimeo.com/smallab/291807587.

void oscEvent(OscMessage theOscMessage) {
  // receive blobs as osc messages
  if (theOscMessage.checkAddrPattern("/tapiocatoys/blob"))
  {
    if (theOscMessage.checkTypetag("iiiii"))
    {
      if (theOscMessage.get(0).intValue() > last_id) {
        // new blob
        blobs[theOscMessage.get(0).intValue() % concurrent_amount] = new OSCBlob(
          theOscMessage.get(0).intValue(), 
          new PVector(theOscMessage.get(1).intValue(), theOscMessage.get(2).intValue()), 
          new PVector(theOscMessage.get(3).intValue(), theOscMessage.get(4).intValue()), 
          frameCount
          ); 
        // save max id value up until now
        last_id = theOscMessage.get(0).intValue();
      } else {
        // updating existing blob
        OSCBlob b = blobs[theOscMessage.get(0).intValue() % concurrent_amount];
        b.previous_location = b.previous_location;
        b.location = new PVector(theOscMessage.get(1).intValue(), theOscMessage.get(2).intValue());
        b.size = new PVector(theOscMessage.get(3).intValue(), theOscMessage.get(4).intValue());
        b.last_update = frameCount;
      }
      return;
    }
  }
}

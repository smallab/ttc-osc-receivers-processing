class sootSystem {
  //create several indicidual wandering soots
  
  float speedIndex;
  float[] speeds = { -5, 10, -15 };
  sootSystem() {
  }
  
  void addParticle() { 
    // Creating new soot
    wanderingSoot soot = new wanderingSoot(speedIndex);
    soots.add(soot);
  }
  
  void createSystem() {
    // Creates systems with various intial speeds
    for (int i = 0; i < 100 ; i++) {
      speedIndex = speeds[int(random(2))];
      this.addParticle();
    }
  }
  
  void updateAll() {
    // Displaying all soots
    for (int i = 0; i<soots.size() ; i++) {
      soots.get(i).display();
    }
  }
  
  void garbageManagement() {
    // Checking for misplaced soots, deleting them and recreating them
    
    for (int i = 0; i<soots.size() ; i++) {
      soots.get(i).isTossed();
      if (tossed == true) {
        soots.get(i).killBody();
        soots.remove(i);
        tossed = false;
      }
    }
    
    for (int i = 1; i <= numberTossed; i++) {
      speedIndex = speeds[int(random(2))];
      this.addParticle();
    }
    // Assigning 0 to numberTossed after having recreated all of the tossed ones
    numberTossed = 0;
  }
}

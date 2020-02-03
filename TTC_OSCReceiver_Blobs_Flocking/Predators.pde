class Predators {

  Predators() {
  }

  void addPredator(Predator p) {
    predators.add(p);
  }
  
  //Draw the predators and check for each one if it should still exist or not
  void updatePredators() {
    for (int i=0; i < predators.size(); i++) {
      predators.get(i).draw();
      predators.get(i).checkLife();
      if (predators.get(i).killable) {
        predators.remove(i);
      }
    }
  }
}

class ParticleSystem {
  ParticleSystem() {
  }

  void addParticle(PVector location, PVector gravity, PVector wind) {
    Particle part = new Particle(location);
    part.addForce(0, gravity);
    part.addForce(1, wind);
    particles.add(part);
  }

  void updateParticles(PVector gravity, PVector wind) {
    // update particles
    for (int i = 0; i < particles.size(); i++) {
      Particle part = particles.get(i);
      part.setForce(0, gravity);
      part.setForce(1, wind);
      part.update();
    }
  }

  void renderParticles() {
    // render particles
    for (int i = 0; i < particles.size(); i++) {
      Particle part = particles.get(i);
      part.render();
    }
  }

  void cleanupParticles() {
    // clean up dead particles
    for (int i = 0; i < particles.size(); i++) {
      Particle part = particles.get(i);
      if (part.isDead()) particles.remove(i);
    }
  }
}

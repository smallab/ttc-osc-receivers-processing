class OSCBlob {
  int id, last_update;
  PVector location, previous_location, size;
  OSCBlob(int _id, PVector _location, PVector _size, int _last_update) {
    id = _id;
    location = _location;
    previous_location = _location;
    size = _size;
    last_update = _last_update;
  }
}

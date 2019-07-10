/**
 *   This is a modified version of the Merge Sort to be able to sort the nodes
 *   based on their distances to the blob. 
 *   Instead of returning a sorted float[] it returns a sorted ArrayList<Node>
 *
 */

ArrayList<Node> fusionMod(ArrayList<Node> A, ArrayList<Node> B) {
  // This function merges two ALREADY sorted lists
  
  if (A.size() == 0) {
    return B;
  } else if (B.size() == 0) {
    return A;
  } else if (A.get(0).distance <= B.get(0).distance) { 
    ArrayList<Node> C = new ArrayList<Node>();
    ArrayList<Node> D = new ArrayList<Node>();
    D.add(A.get(0));
    for (int i = 1; i < A.size(); i++) {
      C.add(A.get(i));
    }
    for (Node d : fusionMod(C, B)) {
      D.add(d);
    }
    return D;
  } else {
    ArrayList<Node> C = new ArrayList<Node>();
    ArrayList<Node> D = new ArrayList<Node>();
    D.add(B.get(0));
    for (int i = 1; i < B.size(); i++) {
      C.add(B.get(i));
    }
    for (Node d : fusionMod(C, A)) {
      D.add(d);
    }
    return D;
  }
}

ArrayList<Node> triFusMod(ArrayList<Node> T) {
  // The idea is to cut the list into two separate ones and do a fusion of the sort of these two and repeat that
  
  if (T.size() <= 1) return T;
  else {
    ArrayList<Node> C = new ArrayList<Node>();
    ArrayList<Node> D = new ArrayList<Node>();
    for (int i = 0; i < floor(T.size()/2); i++) {
      C.add(T.get(i));
    }
    for (int i = floor(T.size()/2); i < T.size(); i++) {
      D.add(T.get(i));
    }

    return fusionMod(triFusMod(C), triFusMod(D));
  }
}

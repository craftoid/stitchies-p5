

////// HERALDRY //////

// heraldry is the medieval art + science, defining which colors may appear next to each other on a coat of arms ...

// function to return valid colors, gived the neighboring colors
interface HeraldryFn {
  int[] fn(int[] neighbor_ids);
}

class XStitchHeraldry implements HeraldryFn {
   int[]  fn(int[] neighbor_ids) {
     
     // white is always an option
     int[] tincture_ids = { 0 };
     
     // black and red may not touch
     if( !contains(neighbor_ids, 2)) {
       tincture_ids = append(tincture_ids, 1);
     }
     
     // and vice versa
     if( !contains(neighbor_ids, 1)) {
       tincture_ids = append(tincture_ids, 2); 
     }
     
     return tincture_ids;
   }
}


////// NEIGHBORS //////

// function to return neighbors of a cell
interface NeighborFn { 
  int[] fn(int[][] matrix, int x, int y);
}

// return preceding neighbors in a triangle-shaped grid 
class TriangleNeighbors implements NeighborFn {
  int[] fn(int[][] matrix, int x, int y) {
    int[] neighbors = new int[0];
    if(x > 0) {
      // left neighbor
      neighbors = append(neighbors, matrix[y][x-1]);
    }
    if(y > 0) {
      // top neighbor
      neighbors = append(neighbors, matrix[y-1][x]);
    }
    
    return neighbors;
  } 
}

// helper functions
boolean contains(int[] a, int e) {
  for(int element : a) if(element == e) return true;
  return false;
}




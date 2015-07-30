/* @pjs crisp=true; */

////////////////////////////////////////////////////////////
//                                                        //
//         S T I T C H Y - I D E N T I C O N S            //
//                                                        //
////////////////////////////////////////////////////////////

// (c) Martin Schneider 2012

// This is an interactive impelementation of the Stitchy Identicons a.k.a Stitchies
// Click it to enter your name and create your own.

// You can learn more about Stitchy Identicons here:
// http://www.k2g2.org/blog:bit.craft/stitchy_identicons

// Programmers Notes:

// - The sketch runs both in Java and Javascript mode.
// - It uses custom PDialog and Pmd5 libraries
// - The code is a direct port of my stitchie PHP-scripts
// - It's a little bit blown-up and could probably be implemented in a single line of code ;-)

import perceptify.pdialog.*;
import perceptify.pmd5.*;

Stitchy stitchy;
PDialog dialog;

void setup() {
  size(200, 200);
  noSmooth();
  stitchy = new Stitchy("Processing");
  dialog = new ModalPDialog(this);
  noLoop();
}

void draw() {
  background(#ffffff);
  stitchy.maximize(0.8);
  stitchy.center();
  stitchy.draw();
}

// asking the user for a string, so we can stitchify it ...
void mousePressed() {
  dialog.prompt("Enter your name");
}

void promptDone(String name) {
  stitchy = new Stitchy(name);
  redraw();
}




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




// displaying an icon with a silver lining and some layout magic

class Icon {
  
  PImage img;
  int x, y, w, h;
  int b = 2;

  void draw() {

    stroke(#cccccc);
    noFill();
    rect(int(x), int(y), w-1, h-1);
    image(img, x+b, y+b, w-2*b, h-2*b);
  }
    
  void center() {
     float d = min(width, height);
     x = (width - w) / 2;
     y = (height - h) / 2;
  }
      
  void resize(int _w, int _h) {
    w = _w; 
    h = _h;
  }
  
  void maximize(float factor) {
    int dmax = int(min(width, height) * factor);
    resize(dmax, dmax);
  }
  
}

// displaying a stitchy icon

class Stitchy extends Icon {
  
  String name;
  
  Stitchy(String name) {
    String code = Pmd5.encode(name);
    img = createStitchy(code);
    this.name = name;
  }
  
  // make sure the size of the actual image is a multiple of the pixel size
  // so all scaled pixels are of equal size
  
  void resize(int _w, int _h) {
    int d = img.width;
    w = int((_w - 2*b) / d) * d + 2*b; 
    h = int((_h - 2*b) / d) * d + 2*b;
  }
  
}

// fixing a pjs image bug (no bilinear filter when blitting an image in noSmooth mode)
void image(PGraphics img, int x0, int y0, int w1, int h1) {
  if(! img.smooth) {
    float w0 = img.width;
    float h0 = img.height;
    for(int y = 0; y < w1; y++) { 
      for(int x = 0; x < h1; x++) {
        int xs = int(x * h0 / h1);
        int ys = int(y * w0 / w1);
        color c = img.get(xs, ys);
        set(x0 + x, y0 + y, c);
      }
    }
  }
}






////// PATTERNS //////

int[][] heraldicPattern(int number, int colors, int size, HeraldryFn heraldy, NeighborFn neighbor) {
  
  int d = size * 2 - 1;
  int[][] matrix = new int[d][d];
  int counter = 0;
  
  // paint the background blue - just for testing
  for(int y = 0; y < d; y++) {
    for(int x = 0; x < d; x++) {
      matrix[y][x] = 3;
    }
  }
  
  // iterate over all cells below the matrix diagonal
  for(int x = 0; x < size; x++) {
    for(int y = 0; y <= x; y++) {
      
      // determine digits to be allowed
      int[] neighbor_digits = neighbor.fn(matrix, x, y);
      int[] allowed_digits = heraldy.fn(neighbor_digits);
      
      // select one
      int allowed_colors = allowed_digits.length;
      int selected_digit = allowed_digits[number %  allowed_colors];

      // add the cell below the diagonal
      matrix[x][y] = selected_digit;
      // add the reflection above the diagonal
      matrix[y][x] = selected_digit;
 
      // reduce the number
      number = int(int(number) / colors);
      
    }
  }
  
  return matrix;
}



PImage createStitchy(String seed) {
  
  // padding the seed so we have at least 6 digits - just in case
  seed = "000000".substring(0, max(6 - seed.length(), 0)) + seed;
  // println("Seed: " + seed);
  
  // use only the first 6 hex-digits as seed ( 24 bit = 16.777.216 possibilities )
  int number = unhex(seed.substring(0, 6));

  // red-white-black palette as used in hungarian x-stitch patterns
  color[] palette = { #ffffff, #000000, #ff0000, #cccccc };
  
  // 5 columns, triangle, 3 colors = 15 pixels * 3 colors (max 14.348.907 possibilities)
  int colors = 3;
  int columns = 5;
  HeraldryFn heraldryfn = new XStitchHeraldry();
  NeighborFn neighborfn = new TriangleNeighbors();

  // create x-stitch pattern
  int[][] matrix = heraldicPattern(number, colors, columns, heraldryfn, neighborfn);
 
  // create image from matrix
  int c = columns - 1;
  int d = 2 * columns - 1;
  PImage img = createImage(d, d, RGB); 
  img.loadPixels();
  
  // create 4 reflections from the matrix
  for (int y = 0; y < columns; y++) {
    for (int x = 0; x < columns; x++) {
      img.pixels[(c-y)*d + c+x] = palette[matrix[y][x]];
      img.pixels[(c-y)*d + c-x] = palette[matrix[y][x]];
      img.pixels[(c+y)*d + c+x] = palette[matrix[y][x]];
      img.pixels[(c+y)*d + c-x] = palette[matrix[y][x]];
    }
  }
  
  img.updatePixels();
  return img;
}




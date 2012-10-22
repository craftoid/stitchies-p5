
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



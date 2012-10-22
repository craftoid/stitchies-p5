
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




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






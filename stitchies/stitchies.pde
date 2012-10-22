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



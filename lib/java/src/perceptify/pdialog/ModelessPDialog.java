
package perceptify.pdialog;

import processing.core.*;

public class ModelessPDialog extends PDialog {
  public ModelessPDialog(PApplet app) {
    super(app);
    modal = false;
  } 
}


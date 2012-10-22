// PDialog v 0y.01 
// (c) Martin Schneider 2012

package perceptify.pdialog;

import processing.core.*;
import java.lang.reflect.*;
import javax.swing.JOptionPane;

public class PDialog {

  final static int YES = 0, NO = 1, CANCEL = -1;
  PApplet app;
  boolean modal;
  String appname;

  public PDialog(PApplet _app) {
    app = _app;
    appname = app.getClass().getName();
  }

  //////////////  processing functions  ////////////////

  public void alert(String msg) {
    new Alert(msg, "alertDone");
  };

  public void alert(String msg, String cb) {
    new Alert(msg, cb);
  }

  public void confirm(String msg) {
    new Confirm(msg, "confirmDone");
  }

  public void confirm(String msg, String cb) {
    new Confirm(msg, cb);
  }
  
  public void prompt(String msg) {
     new Prompt(msg, "promptDone");
  }

  public void prompt(String msg, String cb) {
     new Prompt(msg, cb);
  }


  //////////////  objects   ////////////////////////////

  abstract class Dialog {

    DialogThread t = new DialogThread();
    String msg;
    String cb;

    public class DialogThread extends Thread { 
      public void run() {
        if (modal) {
          show_modal();
        }
        else {
          show_dialog();
        };
        callback();
      };


      void show_modal() {
        app.stop();
        show();
        app.start();
      }

      void show_dialog() {
        show();
        app.firstMouse = true;
      }
    };

    abstract void show();
    abstract void callback();

    Dialog(String _msg, String _cb) {
      msg = _msg;
      cb = _cb;
      t.start();
    };
  }

  class Alert extends PDialog.Dialog {
    Alert(String msg, String cb) {
      super(msg, cb);
    }
    public void show() {
      javax.swing.JOptionPane.showMessageDialog(app.frame, msg, appname, JOptionPane.WARNING_MESSAGE);
    };
    void callback() {
      method(cb);
    }
  }

  class Confirm extends PDialog.Dialog {
    int result;
    Confirm(String msg, String cb) {
      super(msg, cb);
    }
    void show() {
      result = JOptionPane.showConfirmDialog(app.frame, msg, appname, JOptionPane.YES_NO_OPTION);
    }
    void callback() {
      method(cb, result);
    }
  }
  
  class Prompt extends PDialog.Dialog {
    String result;
    Prompt(String msg, String cb) {
      super(msg, cb); 
    }
    void show() {
      result = javax.swing.JOptionPane.showInputDialog(app.frame, msg, appname, JOptionPane.QUESTION_MESSAGE);
    }
    void callback() {
      Boolean success = method(cb, result);
      
      // the callback can return a boolean value
      if(success!=null && success.equals(Boolean.FALSE)) {
        // launch a new prompt when the callback returned false
        prompt(msg, cb);
      }
    }
  }


  //////////////  introspection for callbacks //////////

  private void method(String name) {
    app.method(name);
  }

  private Boolean method(String name, String msg) {
    Boolean result = null;
    try {
      Method method = app.getClass().getMethod(name, new Class[] { String.class });
      result = (Boolean) method.invoke(app, new Object[] { msg });
    } 
    catch(NoSuchMethodException e) {
      System.err.println("There is no public " + name + "(String msg) method " +
        "in the class " + getClass().getName());
    } 
    catch(Exception e) {
      e.printStackTrace();
    }
    return result;
  }

  private void method(String name, int state) {
    try {
      Method method = app.getClass()
      .getMethod(name, new Class[] { int.class });
      method.invoke(app, new Object[] { state });
    } 
    catch(NoSuchMethodException e) {
      System.err.println("There is no public " + name + "(int state) method " +
        "in the class " + getClass().getName());
    } 
    catch(Exception e) {
      e.printStackTrace();
    }
  }
}


// PDialog library v.001
// (c) Martin Schneider 2012

Processing.registerLibrary("pdialog", {
  init: 
    function(defaultScope) {
  
      function PDialog(app) {
        this.app = app;  
      };
  
      PDialog.prototype.alert = function(msg, cb) {
        var app = this.app;
        var cb = cb || "alertDone";
        window.alert(msg);
        app[cb] && app[cb]();
      };
  
      PDialog.prototype.confirm = function(msg, cb) {
        var app = this.app;
        var cb = cb || "confirmDone";
        var result = window.confirm(msg);
        var dialog_result = (result == true) ? PDialog.YES : (result == false) ? PDialog.NO : PDialog.CANCEL;
        app[cb] && app[cb](dialog_result);
      };
  
      PDialog.prototype.prompt = function(msg, cb) {
        var app = this.app;
        var cb = cb || "promptDone";
        var result = window.prompt(msg);
        var success = app[cb] && app[cb](result);
        if (success == false) {
          this.prompt(msg, cb);
        }
      };
   
      PDialog.YES = 1;
      PDialog.NO = 0;
      PDialog.CANCEL = -1;
  
      // Javascript always uses modal GUIs
      // If we really want modeless GUIs, we might want to use jquery.ui ..
      defaultScope.PDialog = PDialog;
      defaultScope.ModalPDialog = PDialog;
      
    }
  }
);


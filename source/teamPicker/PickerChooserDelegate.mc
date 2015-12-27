using Toybox.Graphics as Gfx;
using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Log4MonkeyC as Log;

class PickerChooserDelegate extends Ui.PickerDelegate {
	hidden var propertyHandler;
	hidden var logger;
	
    function initialize(propertyHandler){
      self.propertyHandler = propertyHandler;
      logger = Log.getLogger("PickerChooserDelegate");
    }

    function onCancel() {
        Ui.popView(Ui.SLIDE_IMMEDIATE);
    }

    function onAccept(values) {
   		logger.debug("selected: " + values[0] );
		var infoView = new InfoView();
		var mModel = new FootballTeamModel(propertyHandler, infoView.method(:onInfoUpdated),values[0]);
		Ui.switchToView(infoView, null, Ui.SLIDE_RIGHT);

    }
}

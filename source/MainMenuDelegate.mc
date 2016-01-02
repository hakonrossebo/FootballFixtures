using Log4MonkeyC as Log;
using Toybox.WatchUi as Ui;

class MainMenuDelegate extends Ui.MenuInputDelegate {
    hidden var logger;
    hidden var propertyHandler;

    function initialize(propertyHandler){
      self.propertyHandler = propertyHandler;
      logger = Log.getLogger("MainMenuDelegate");
    }

    function onMenuItem(item) {
        if ( item == :item_select_team ) {
        	logger.debug("m1");
        	Ui.pushView( new PickerChooser(), new PickerChooserDelegate(propertyHandler), Ui.SLIDE_IMMEDIATE );
            // Do something here

        }
    }
}

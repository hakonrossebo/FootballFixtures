using Log4MonkeyC as Log;
using Toybox.WatchUi as Ui;

class FootballTeamViewInputDelegate extends Ui.InputDelegate
{
    hidden var logger;
    hidden var propertyHandler;

    function initialize(propertyHandler){
      self.propertyHandler = propertyHandler;
      logger = Log.getLogger("FootballTeamViewInputDelegate");
    }

    function onKey(key) {
      logger.debug("key pressed :" +key.getKey() );
        if(key.getKey() == Ui.KEY_ENTER || key.getKey() == Ui.KEY_MENU) {
        	Ui.pushView( new PickerChooser(), new PickerChooserDelegate(propertyHandler), Ui.SLIDE_IMMEDIATE );
        	//Ui.pushView( new Rez.Menus.MainMenu(), new MainMenuDelegate(propertyHandler), Ui.SLIDE_UP );
        }
    }

}
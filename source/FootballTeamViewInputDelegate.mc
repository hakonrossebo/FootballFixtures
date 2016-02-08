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
        	//Ui.pushView( new PickerChooser(), new PickerChooserDelegate(propertyHandler), Ui.SLIDE_IMMEDIATE );
        	////////////////Ui.pushView( new Rez.Menus.MainMenu(), new MainMenuDelegate(propertyHandler), Ui.SLIDE_UP );

        //return [menuView,  new CustomMenuViewInputDelegate(menuView.method(:scrollMenuUp), menuView.method(:scrollMenuDown))]; 
    	//var menuView = new CustomMenuView(Constants.leagueTeams);
		var infoView = new InfoView(propertyHandler, -2);
		Ui.pushView(infoView, null, Ui.SLIDE_RIGHT);
    	
    	//Ui.switchToView( menuView, new CustomMenuViewInputDelegate(menuView, propertyHandler, menuView.method(:scrollMenuUp), menuView.method(:scrollMenuDown),  menuView.method(:getCurrentSelection)), Ui.SLIDE_IMMEDIATE );
    	//Ui.pushView( menuView, new CustomMenuViewInputDelegate(menuView, propertyHandler), Ui.SLIDE_IMMEDIATE );
        }
        propertyHandler = null;
		return true;
    }

}

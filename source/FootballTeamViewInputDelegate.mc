using Log4MonkeyC as Log;
using Toybox.WatchUi as Ui;

class FootballTeamViewInputDelegate extends Ui.InputDelegate
{
    hidden var logger;
    hidden var propertyHandler;
	hidden var onSelectedTeam;
	
    function initialize(propertyHandler, onSelectedTeam){
      self.propertyHandler = propertyHandler;
      self.onSelectedTeam = onSelectedTeam;
      logger = Log.getLogger("FootballTeamViewInputDelegate");
    }

    function onKey(key) {
      logger.debug("key pressed :" +key.getKey() );
        if(key.getKey() == Ui.KEY_ENTER || key.getKey() == Ui.KEY_MENU) {
	    	var menuView = new CustomMenuView(Constants.leagueTeams);
	    	Ui.pushView( menuView, new CustomMenuViewInputDelegate(menuView, onSelectedTeam, propertyHandler), Ui.SLIDE_IMMEDIATE );
        }
        propertyHandler = null;
		return true;
    }

}

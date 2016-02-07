using Toybox.Application as App;
using Toybox.System as Sys;
using Log4MonkeyC as Log;

class FootballTeamApp extends App.AppBase {

	hidden var startView;
	hidden var startViewInputDelegate;
    hidden var mModel;
    hidden var logger;
    hidden var propertyHandler;
    function initialize() {
        AppBase.initialize();
    }

    function onStart() {
  		Log.setLogConfig(Constants.getGlobalLoggerConfig());
    
  		logger = Log.getLogger("FootballTeamApp");
  		
		propertyHandler = new PropertyHandler();


    }

    //! onStop() is called when your application is exiting
    function onStop() {
    }

    //! Return the initial view of your application here
    function getInitialView() {
    	logger.debug("main - Starting application - main");
        //return [ infoView ];
        //return [ startView, startViewInputDelegate];

		logger.debug("fetching team info" );
		var teamFixturesInfo = propertyHandler.getTeamFixturesInfo(0);
		logger.debug("team info fetched" );
		if (teamFixturesInfo.dateValid && teamFixturesInfo.selectedTeamValid)
		{
			logger.debug("Ok at init. Switching view to FootballTeamView" );
			startView = new FootballTeamView(teamFixturesInfo);
			startViewInputDelegate = new FootballTeamViewInputDelegate(propertyHandler);
			//Ui.switchToView(new FootballTeamView(teamFixturesInfo), new FootballTeamViewInputDelegate(propertyHandler), Ui.SLIDE_RIGHT);
 			teamFixturesInfo = null;
	       	return [ startView, startViewInputDelegate];
			//return;
		}
		else
		{
			logger.debug("Creating infoView" );
			startView = new InfoView(propertyHandler, 0);
			startViewInputDelegate = null;
	       	return [ startView ];
			//mModel = new FootballTeamModel(propertyHandler, startView.method(:onInfoUpdated),0);
		}


    }

}

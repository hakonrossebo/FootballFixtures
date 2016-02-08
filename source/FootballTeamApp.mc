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

		logger.debug("fetching team info" );
		var teamFixturesInfo = propertyHandler.getTeamFixturesInfo(0);
		startView = new FootballTeamView(propertyHandler, teamFixturesInfo);
		startViewInputDelegate = new FootballTeamViewInputDelegate(propertyHandler);
		logger.debug("team info fetched" );
       	return [ startView, startViewInputDelegate];
       	
    }
}

using Toybox.Application as App;
using Toybox.System as Sys;
using Log4MonkeyC as Log;

class FootballTeamApp extends App.AppBase {

	hidden var infoView;
    hidden var mModel;
    hidden var logger;
    hidden var propertyHandler;
    function initialize() {
        AppBase.initialize();
    }

    //! onStart() is called on application start up
    function onStart() {
  		var config = new Log4MonkeyC.Config();
  		if (Constants.current_environment >= Constants.env_Debug) {
  			config.setLogLevel(Log.DEBUG);
  		}
  		else {
  			config.setLogLevel(Log.WARN);
  		}
  		Log4MonkeyC.setLogConfig(config);
  		logger = Log.getLogger("FootballTeamApp");
		propertyHandler = new PropertyHandler();
		
		infoView = new InfoView();
		mModel = new FootballTeamModel(propertyHandler, infoView.method(:onInfoUpdated),0);

    }

    //! onStop() is called when your application is exiting
    function onStop() {
    }

    //! Return the initial view of your application here
    function getInitialView() {
    	logger.debug("Starting application");
        return [ infoView];
        //return [ mainView, new FootballTeamViewInputDelegate(propertyHandler)];
    }

}

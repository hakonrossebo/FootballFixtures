using Toybox.Application as App;
using Toybox.System as Sys;
using Log4MonkeyC as Log;



var globalTeams = { 57 => "Arsenal",58 => "Aston Villa",1044 => "Bournemouth",61 => "Chelsea",354 => "Crystal",62 => "Everton",338 => "Foxes",64 => "Liverpool",65 => "ManCity",66 => "ManUnited",67 => "Newcastle",68 => "Norwich",340 => "Southampton",73 => "Spurs",70 => "Stoke",71 => "Sunderland",72 => "Swans",346 => "Watford",74 => "West Bromwich",563 => "West Ham" };

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
  		config.setLogLevel(Log.DEBUG);
  		Log4MonkeyC.setLogConfig(config);
  		logger = Log.getLogger("FootballTeamApp");
		
		infoView = new InfoView();
		propertyHandler = new PropertyHandler();
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

using Toybox.Application as App;
using Toybox.System as Sys;


var mainView;

var globalTeams = { 57 => "Arsenal",58 => "Aston Villa",1044 => "Bournemouth",61 => "Chelsea",354 => "Crystal",62 => "Everton",338 => "Foxes",64 => "Liverpool",65 => "ManCity",66 => "ManU",67 => "Newcastle",68 => "Norwich",340 => "Southampton",73 => "Spurs",70 => "Stoke",71 => "Sunderland",72 => "Swans",346 => "Watford",74 => "West Bromwich",563 => "West Ham" };

class FootballTeamApp extends App.AppBase {


    hidden var mModel;
    

    function initialize() {
        AppBase.initialize();
    }

    //! onStart() is called on application start up
    function onStart() {
	    var dev = Sys.getDeviceSettings();
	    if(dev.phoneConnected == false) {
	        mView = new WaitingConnectionView();
	        //Ui.switchToView(view, null, Ui.SLIDE_RIGHT);
	    }
	    else
	    {
	        mainView = new FootballTeamView();
	        mModel = new FootballTeamModel(mainView.method(:onInfoReady),0);
	    }
    }

    //! onStop() is called when your application is exiting
    function onStop() {
    }

    //! Return the initial view of your application here
    function getInitialView() {
        return [ mainView, new FootballTeamViewInputDelegate() ];
    }

}

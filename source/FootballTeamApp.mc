using Toybox.Application as App;
using Toybox.System as Sys;


var mainView;

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

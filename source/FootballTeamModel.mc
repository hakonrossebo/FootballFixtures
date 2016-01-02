using Toybox.Communications as Comm;
using Toybox.WatchUi as Ui;
using Toybox.Graphics;
using Toybox.System as Sys;
using Toybox.Application as App;
using Log4MonkeyC as Log;

class FootballTeamModel
{
    hidden var callbackHandler;
    hidden var logger;
    hidden var propertyHandler;
  	hidden var teamNextFixtures;
  	hidden var teamNextFixturesReceived = false;
  	hidden var teamPreviousFixtures;
  	hidden var teamPreviousFixturesReceived = false;
  	hidden var userTeamId = 0;
  	hidden var CONST_FIXTURE_DAYS = 20;
  	hidden var CONST_PREVIOUS_FIXTURE_DAYS = 14;
  	hidden var teamNextFixturesUrl = "";
  	hidden var teamPreviousFixturesUrl = "";

    function initialize(propertyHandler, callbackHandlerInfo, selectedNewTeamId)
    {
        self.propertyHandler = propertyHandler;
        logger = Log.getLogger("FootballTeamModel");
        callbackHandler = callbackHandlerInfo;
		try
		{
			var teamFixturesInfo = propertyHandler.getTeamFixturesInfo(selectedNewTeamId);
			if (teamFixturesInfo.dateValid && teamFixturesInfo.selectedTeamValid)
			{
				logger.debug("Switching view to FootballTeamView" );
				Ui.switchToView(new FootballTeamView(teamFixturesInfo), new FootballTeamViewInputDelegate(propertyHandler), Ui.SLIDE_RIGHT);
				teamFixturesInfo = null;
				return;
			}
			if (!teamFixturesInfo.selectedTeamValid)
			{
				//User need to select a team
				logger.debug("Switching view to PickerChooser" );
				Ui.pushView( new PickerChooser(), new PickerChooserDelegate(propertyHandler), Ui.SLIDE_IMMEDIATE );
				teamFixturesInfo = null;
				return;
			}
	    	logger.debug("TeamId is ok, but fixtures needs to be refreshed" );
          	var deviceSettings = Sys.getDeviceSettings();
    	    if(deviceSettings.phoneConnected == false) {
    	    	callbackHandler.invoke("No phone connection");
    	    	return;
    	    }
    	    userTeamId = teamFixturesInfo.getTeamId();
	    	logger.debug("TeamId to refresh: " + userTeamId );

			teamNextFixturesUrl = Lang.format("http://api.football-data.org/v1/teams/$1$/fixtures?timeFrame=n$2$", [userTeamId, CONST_FIXTURE_DAYS]);
			teamPreviousFixturesUrl = Lang.format("http://api.football-data.org/v1/teams/$1$/fixtures?timeFrame=p$2$", [userTeamId, CONST_PREVIOUS_FIXTURE_DAYS]);
			if (Constants.current_environment == Constants.env_OfflineTesting)
			{
				logger.debug("Using localhost test json");
				teamNextFixturesUrl = "http://localhost:3000/nextfixtures";
				teamPreviousFixturesUrl = "http://localhost:3000/previousfixtures";			
			}
		
  	    	logger.debug("Fetching data from web");
			var token = Ui.loadResource (Rez.Strings.API_Token);
			var options = {
			    :method => Comm.HTTP_REQUEST_METHOD_GET,
			    :headers => { "X-Auth-Token" => token,
			    			  "X-Response-Control" => "minified" 	 }
			};

			Comm.makeJsonRequest(teamNextFixturesUrl, {}, options, method(:onReceiveNextFixtures));
			Comm.makeJsonRequest(teamPreviousFixturesUrl, {}, options, method(:onReceivePreviousFixtures));
	    	logger.debug("Invoked json API requests" );
	        callbackHandler.invoke(Ui.loadResource(Rez.Strings.MainLoading));
			teamFixturesInfo = null;
	        
		}
		catch (ex)
		{
	        callbackHandler.invoke("Error");
			logger.error("Error: " + ex.getErrorMessage());    
		}
    }


    function onReceiveNextFixtures(responseCode, data)
    {
        if( responseCode == 200 )
        {
            logger.debug("Received team fixtures info ok");
            teamNextFixturesReceived = true;
            teamNextFixtures = data;
            onReceiveCheckComplete(true, Ui.loadResource(Rez.Strings.MainNextFixtures));
        }
        else
        {
            logger.error("Received team fixtures info failed");
            onReceiveCheckComplete(false, Ui.loadResource(Rez.Strings.MainNextFixtures));
        }
    }
    function onReceivePreviousFixtures(responseCode, data)
    {
        if( responseCode == 200 )
        {
            logger.debug("Received team Previous fixtures info ok");
            teamPreviousFixturesReceived = true;
            teamPreviousFixtures = data;
            onReceiveCheckComplete(true, Ui.loadResource(Rez.Strings.MainPreviousFixtures));
        }
        else
        {
            logger.error("Received team Previous fixtures info failed");
            onReceiveCheckComplete(false, Ui.loadResource(Rez.Strings.MainPreviousFixtures));
        }
    }

    function onReceiveCheckComplete(status, receiveType)
    {
        logger.debug("Receive complete check");
    	if (!status)
    	{
    		callbackHandler.invoke( "Failed to load\nError: " + status );
    		return;
    	}
    	if (teamNextFixturesReceived && teamPreviousFixturesReceived)
    	{
    		logger.debug("Receive complete check - ok");
    		var teamFixturesInfo = propertyHandler.setTeamFixturesInfo(teamNextFixtures, teamPreviousFixtures, userTeamId);
    		teamNextFixtures = null;
    		teamPreviousFixtures = null;
            callbackHandler.invoke(Ui.loadResource(Rez.Strings.MainFinished));
			Ui.switchToView(new FootballTeamView(teamFixturesInfo), new FootballTeamViewInputDelegate(propertyHandler), Ui.SLIDE_RIGHT);
			teamFixturesInfo = null;
    	}
    	else
    	{
            callbackHandler.invoke(Ui.loadResource(Rez.Strings.MainFinished) + " " + receiveType);
    	}
	}
}

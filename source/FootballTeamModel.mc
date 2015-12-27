using Toybox.Communications as Comm;
using Toybox.WatchUi as Ui;
using Toybox.Graphics;
using Toybox.System as Sys;
using Toybox.Application as App;
using Log4MonkeyC as Log;

//Testfix branch test
class FootballTeamModel
{
    hidden var notify;
    hidden var bUpdateSettings = false;
    hidden var logger;
  	hidden var teamNextFixtures;
    hidden var propertyHandler;
  	hidden var teamNextFixturesReceived = false;
  	hidden var teamPreviousFixtures;
  	hidden var teamPreviousFixturesReceived = false;
  	hidden var userPref_TeamID = 64;
  	hidden var CONST_FIXTURE_DAYS = 20;
  	hidden var CONST_PREVIOUS_FIXTURE_DAYS = 14;
  	hidden var teamInfoUrl = "";
  	hidden var teamNextFixturesUrl = "";
  	hidden var teamPreviousFixturesUrl = "";
  	var dict = {
  		"lastModified" => Time.now().value(),
  		"teamId" => 0,
  		"nextFixtures" => {},
  		"previousFixtures" => {}
  		 };
  	//hidden var progressBar;

    function initialize(propertyHandler, handler, selectedTeamId)
    {
        self.propertyHandler = propertyHandler;
        logger = Log.getLogger("FootballTeamModel");
        notify = handler;
		try
		{
			
	        var app = App.getApp();
	        var storedTeamInfo = app.getProperty("TeamFixtureInfoJson");
	        if(null!=storedTeamInfo && selectedTeamId == 0)
	        {
				if (settingsValid(storedTeamInfo))
				{
		        	 logger.debug("Using data from settings");
		            teamNextFixturesReceived = true;
		            teamNextFixtures = storedTeamInfo["nextFixtures"];
		            teamPreviousFixturesReceived = true;
		            teamPreviousFixtures = storedTeamInfo["previousFixtures"];
		            userPref_TeamID = storedTeamInfo["teamId"];
		            onReceiveCheckComplete(true, Ui.loadResource(Rez.Strings.MainAll));
					return;
				}
				else
				{
					logger.debug("Using only id from settings");
					userPref_TeamID = storedTeamInfo["teamId"];
				}
	        }
	        if (selectedTeamId > 0)
	        {
	        	logger.debug("User selected new team: " + selectedTeamId);
	        	userPref_TeamID = selectedTeamId;
	        }

          var deviceSettings = Sys.getDeviceSettings();
    	    if(deviceSettings.phoneConnected == false) {
    	        var waitingView = new WaitingConnectionView();
    	        Ui.switchToView(waitingView, null, Ui.SLIDE_RIGHT);
    	    }

			teamNextFixturesUrl = Lang.format("http://api.football-data.org/v1/teams/$1$/fixtures?timeFrame=n$2$", [userPref_TeamID, CONST_FIXTURE_DAYS]);
			teamPreviousFixturesUrl = Lang.format("http://api.football-data.org/v1/teams/$1$/fixtures?timeFrame=p$2$", [userPref_TeamID, CONST_PREVIOUS_FIXTURE_DAYS]);

	        bUpdateSettings = true;
  	    	logger.debug("Using data from web");
	        storedTeamInfo="empty";
	        //progressBar = new Ui.ProgressBar( "Processing", null );
	        //Ui.pushView( progressBar, null, Ui.SLIDE_DOWN );
			var token = Ui.loadResource (Rez.Strings.API_Token);
			var options = {
			    :method => Comm.HTTP_REQUEST_METHOD_GET,
			    :headers => { "X-Auth-Token" => token,
			    			  "X-Response-Control" => "minified" 	 }
			};
	    	logger.debug("Called for info through API" );

			Comm.makeJsonRequest(teamNextFixturesUrl, {}, options, method(:onReceiveNextFixtures));
			Comm.makeJsonRequest(teamPreviousFixturesUrl, {}, options, method(:onReceivePreviousFixtures));

	        notify.invoke(Ui.loadResource(Rez.Strings.MainLoading));
	        //progressBar.setDisplayString( "Loading" );
		}
		catch (ex)
		{
	        notify.invoke("Error");
			logger.error("Error");
		}

    }

	function settingsValid(storedTeamInfo)
	{
		var lastUpdated = new Time.Moment(storedTeamInfo["lastModified"].toLong());
		var timeNow = Time.now();
        var duration = timeNow.subtract(lastUpdated);
		logger.debug("Duration since last settings (s) " + duration.value());
		if (duration.value() > 60*60*6)
		{
			return false;
		}
		else
		{
			return true;
		}
	}

    function onReceiveNextFixtures(responseCode, data)
    {
        if( responseCode == 200 )
        {
            logger.debug("Received team fixtures info ok");
            teamNextFixturesReceived = true;
            teamNextFixtures = data;
            onReceiveCheckComplete(true, "NextFixtures");
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
            onReceiveCheckComplete(true, "PreviousFixtures");
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
    		notify.invoke( "Failed to load\nError: " + responseCode.toString() );
    		return;
    	}
    	if (teamNextFixturesReceived && teamPreviousFixturesReceived)
    	{
    		    logger.debug("Receive complete check - ok");
            var info = new FootballTeamInfo();
            info.teamId = userPref_TeamID;
            info.name = globalTeams[userPref_TeamID];
            info.nextFixtures = teamNextFixtures;
            info.previousFixtures = teamPreviousFixtures;
            logger.debug(info.name);
            notify.invoke(info);
            //Ui.popView( Ui.SLIDE_UP );

			if (bUpdateSettings)
			{
		        var app = App.getApp();
		        dict["nextFixtures"] = info.nextFixtures;
		        dict["previousFixtures"] = info.previousFixtures;
		        dict["teamId"] = info.teamId;
		        dict["lastModified"] = Time.now().value();
		        var storedTeamInfo = app.setProperty("TeamFixtureInfoJson", dict);
				app.saveProperties();
			}
    	}
    	else
    	{
	        //progressBar.setDisplayString( receiveType + " done" );
            notify.invoke(Ui.loadResource(Rez.Strings.MainFinished) + " " + receiveType);
    	}
	}
}

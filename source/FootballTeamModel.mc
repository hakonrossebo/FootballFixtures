using Toybox.Communications as Comm;
using Toybox.WatchUi as Ui;
using Toybox.Graphics;
using Toybox.System as Sys;
using Toybox.Application as App;


class FootballTeamModel
{
    hidden var notify;
    hidden var bUpdateSettings = false;
	hidden var teamInfo;
	hidden var teamInfoReceived = false;
	hidden var teamNextFixtures;
	hidden var teamNextFixturesReceived = false;
	hidden var teamPreviousFixtures;
	hidden var teamPreviousFixturesReceived = false;
	hidden var userPref_TeamID = 64;
	hidden var CONST_FIXTURE_DAYS = 20;
	hidden var CONST_PREVIOUS_FIXTURE_DAYS = 14;
	hidden var teamInfoUrl = Lang.format("http://api.football-data.org/v1/teams/$1$", [userPref_TeamID]);
	hidden var teamNextFixturesUrl = Lang.format("http://api.football-data.org/v1/teams/$1$/fixtures?timeFrame=n$2$", [userPref_TeamID, CONST_FIXTURE_DAYS]);
	hidden var teamPreviousFixturesUrl = Lang.format("http://api.football-data.org/v1/teams/$1$/fixtures?timeFrame=p$2$", [userPref_TeamID, CONST_PREVIOUS_FIXTURE_DAYS]);
	var dict = { 
		"teamName" => "abc", 
		"lastModified" => Time.now().value(),
		"teamInfo" => {},
		"nextFixtures" => {},
		"previousFixtures" => {}
		 };
	//hidden var progressBar;
		
    function initialize(handler)
    {
        notify = handler;
        var app = App.getApp();
        var storedTeamInfo = app.getProperty("TeamInfoJson");
        if(null!=storedTeamInfo && settingsValid(storedTeamInfo))
        {
        	Sys.println("Using data from settings");
            teamNextFixturesReceived = true;
            teamNextFixtures = storedTeamInfo["nextFixtures"];
            teamPreviousFixturesReceived = true;
            teamPreviousFixtures = storedTeamInfo["previousFixtures"];
            teamInfoReceived = true;
            teamInfo = storedTeamInfo["teamInfo"];
            onReceiveCheckComplete(true, "All");
			return;            
        }
        bUpdateSettings = true;
    	Sys.println("Using data from web");
        storedTeamInfo="empty";
        //progressBar = new Ui.ProgressBar( "Processing", null );
        //Ui.pushView( progressBar, null, Ui.SLIDE_DOWN );
		var token = Ui.loadResource (Rez.Strings.API_Token);
		var options = {
		    :method => Comm.HTTP_REQUEST_METHOD_GET,
		    :headers => { "X-Auth-Token" => token,
		    			  "X-Response-Control" => "minified" 	 }
		};
    	Sys.println("Called for info through API" );
    	
		Comm.makeJsonRequest(teamInfoUrl, {}, options, method(:onReceiveTeamInfo));
		Comm.makeJsonRequest(teamNextFixturesUrl, {}, options, method(:onReceiveNextFixtures));
		Comm.makeJsonRequest(teamPreviousFixturesUrl, {}, options, method(:onReceivePreviousFixtures));

        notify.invoke("Loading\nInfo");
        //progressBar.setDisplayString( "Loading" );
    }

	function settingsValid(storedTeamInfo)
	{
		var lastUpdated = new Time.Moment(storedTeamInfo["lastModified"].toLong());
		var timeNow = Time.now();
        var duration = timeNow.subtract(lastUpdated);
		Sys.println("Duration since last settings (s) " + duration.value());
		if (duration.value() > 60*60)
		{
			return false;
		}
		else
		{
			return true;
		}
	}
	
    function onReceiveTeamInfo(responseCode, data)
    {
        if( responseCode == 200 )
        {
            Sys.println("Received team info ok");
            teamInfoReceived = true;
            teamInfo = data;
            onReceiveCheckComplete(true, "TeamInfo");
        }
        else
        {
            Sys.println("Received team info failed");
            onReceiveCheckComplete(false, "TeamInfo");
        }
    }

    function onReceiveNextFixtures(responseCode, data)
    {
        if( responseCode == 200 )
        {
            Sys.println("Received team fixtures info ok");
            teamNextFixturesReceived = true;
            teamNextFixtures = data;
            onReceiveCheckComplete(true, "NextFixtures");
        }
        else
        {
            Sys.println("Received team fixtures info failed");
            onReceiveCheckComplete(false, "NextFixtures");
        }
    }
    function onReceivePreviousFixtures(responseCode, data)
    {
        if( responseCode == 200 )
        {
            Sys.println("Received team Previous fixtures info ok");
            teamPreviousFixturesReceived = true;
            teamPreviousFixtures = data;
            onReceiveCheckComplete(true, "PreviousFixtures");
        }
        else
        {
            Sys.println("Received team Previous fixtures info failed");
            onReceiveCheckComplete(false, "PreviousFixtures");
        }
    }

    function onReceiveCheckComplete(status, receiveType)
    {
        Sys.println("Receive complete check");
    	if (!status)
    	{
    		notify.invoke( "Failed to load\nError: " + responseCode.toString() );
    		return;
    	}
    	if (teamInfoReceived && teamNextFixturesReceived && teamPreviousFixturesReceived)
    	{
    		Sys.println("Receive complete check - ok");
            var info = new FootballTeamInfo();
            info.teamId = userPref_TeamID;
            info.name = teamInfo["shortName"];
            info.teamInfo = teamInfo;
            info.nextFixtures = teamNextFixtures;
            info.previousFixtures = teamPreviousFixtures;
            Sys.println(info.name);
            notify.invoke(info);
            //Ui.popView( Ui.SLIDE_UP );

			if (bUpdateSettings)
			{
		        var app = App.getApp();
		        dict["nextFixtures"] = info.nextFixtures;
		        dict["previousFixtures"] = info.previousFixtures;
		        dict["teamInfo"] = info.teamInfo;
		        dict["lastModified"] = Time.now().value();
		        var storedTeamInfo = app.setProperty("TeamInfoJson", dict);
				app.saveProperties();
			}
    	}
    	else
    	{
	        //progressBar.setDisplayString( receiveType + " done" );
            notify.invoke("Finished " + receiveType);
    	}
	}
}
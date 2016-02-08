using Toybox.Communications as Comm;
using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Application as App;
using Toybox.Time as Time;
using Log4MonkeyC as Log;



class FootballTeamView extends Ui.View {
	hidden var showInfoText = true;
	hidden var infoText = "Preparing..";
    hidden var mFootballTeamInfo = "";
    hidden var mTeamId = "";
    hidden var mTeamName = "--";
    hidden var mNextMatch = "--";
    hidden var mPreviousMatch = "--";
    hidden var mNextMatches =  ["--", "--", "--" ];
    hidden var mNextMatchDuration = "--";
    hidden var logger;
    //hidden var teamFixturesInfo;
	hidden var propertyHandler;
	
    function initialize(propertyHandler){
    
    	logger = Log.getLogger("FootballTeamView");
        self.propertyHandler = propertyHandler;
    	//self.teamFixturesInfo = teamFixturesInfo;
    }

    //! Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.FootballTeam(dc));
    }

    //! Restore the state of the app and prepare the view to be shown
    function onShow() {
		//prepareMainData();
    }

	function prepareMainData(teamFixturesInfo){
    	logger.debug("showing main view");
		if (teamFixturesInfo.dateValid && teamFixturesInfo.selectedTeamValid)
		{
	    	prepareViewInfo(teamFixturesInfo);
		}

		else if (!teamFixturesInfo.selectedTeamValid)
		{
			logger.debug("Need to select team" );
	    	var menuView = new CustomMenuView(Constants.leagueTeams);
	    	var menuViewInputDelegate = new CustomMenuViewInputDelegate(menuView, method(:onSelectedTeam), propertyHandler);
			//teamFixturesInfo = null;
			onInfoUpdated("Press menu to select team");
			//Ui.pushView(menuView, menuViewInputDelegate, Ui.SLIDE_RIGHT);
		}
		
		else
		{
			logger.debug("Need to refresh" );
			loadDataFromWeb(0);
		}
	
	}

    function onInfoUpdated(info)
    {
        logger.debug("Inside info updated: " + info);
        infoText = info;
        Ui.requestUpdate();
	}
    function onFixturesModelUpdated(teamFixturesInfo)
    {
    	showInfoText = true;
    	onInfoUpdated("Data fetched..");
        logger.debug("Inside onFixturesModelUpdated");
        prepareMainData(teamFixturesInfo);
	}


    function onSelectedTeam(selectedItem)
    {
    	showInfoText = true;
    	onInfoUpdated("Team selected");
    	loadDataFromWeb(selectedItem);
	}


	function loadDataFromWeb(selectedItem) {
		logger.debug("Starting model - get fixture data: " + selectedItem );
        var mModel = new FootballTeamModel(propertyHandler, method(:onInfoUpdated), method(:onFixturesModelUpdated),selectedItem);
        var result = mModel.getFixtureData();
        if (result == -1) {

	    	onInfoUpdated("Model from web - no data");
	        logger.debug("Model from web - no data!");
        }
	
	}

    //! Update the view
    function onUpdate(dc) {
    	if (showInfoText) {
	        dc.setColor( Gfx.COLOR_BLACK, Gfx.COLOR_BLACK );
	        dc.clear();
	        dc.setColor( Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT );
	        dc.drawText( dc.getWidth() / 2, dc.getHeight() / 2 - 6, Gfx.FONT_MEDIUM, infoText, Gfx.TEXT_JUSTIFY_CENTER );
    	
    	}
    	else
    	{
	        var TeamName = View.findDrawableById("TeamName");
	        TeamName.setText(mFootballTeamInfo);
	
	        var txtPreviousMatch = View.findDrawableById("txtLastMatch");
	        txtPreviousMatch.setText(mPreviousMatch);
	
			var txtNextMatchDuration = View.findDrawableById("txtNextMatchDuration");
	        txtNextMatchDuration.setText(mNextMatchDuration);
	
	        var txtNextMatch1 = View.findDrawableById("txtNextMatch1");
	        txtNextMatch1.setText(mNextMatches[0]);
	
	        var txtNextMatch2 = View.findDrawableById("txtNextMatch2");
	        txtNextMatch2.setText(mNextMatches[1]);
	
	        // Call the parent onUpdate function to redraw the layout
	        View.onUpdate(dc);
    	
    	}
    }

    //! Called when this View is removed from the screen. Save the
    //! state of your app here.
    function onHide() {
    	//teamFixturesInfo = null;
    	//propertyHandler = null;	
    }

    function prepareViewInfo(teamFixturesInfo)
    {
        logger.debug("Inside prepareViewInfo");
		try
		{
	        if (1==1)
	        {
	        	showInfoText = false;
	        	logger.debug("Inside infoready - instance ok");
				logger.debug("Used memory:");
				logger.debug(Sys.getSystemStats().usedMemory);
	        	var durationTest = teamFixturesInfo.getNextFixtureDuration();
	            mFootballTeamInfo = Constants.leagueTeams[teamFixturesInfo.getTeamId()];
	            logger.debug("team: " + mFootballTeamInfo);
	            mTeamId = teamFixturesInfo.getTeamId();
	            setLastFixtureInfo(teamFixturesInfo);
				setFixtureInfo(teamFixturesInfo);
				logger.debug("Used memory:");
				logger.debug(Sys.getSystemStats().usedMemory);
	        }
	        else 
	        {
	            mFootballTeamInfo = "View error";
				logger.debug("View error. No dictionary with info from model.");
	        }
	        //teamFixturesInfo = null;
		}
		catch (ex)
		{
			mFootballTeamInfo = "Error";
			logger.error("Error: " + ex.getErrorMessage());
		}
		logger.debug("Requesting UI update");
        Ui.requestUpdate();
    }
    function setFixtureInfo(teamFixturesInfo)
    {
		try
		{
			logger.debug("Inside setFixtureInfo");
			var fixtures = teamFixturesInfo.getNextFixtures();
	        mNextMatches[0] = getFixture(fixtures["fixtures"][0]);
	        mNextMatches[1] = getFixture(fixtures["fixtures"][1]);
	        mNextMatchDuration = DateTimeUtils.formatDurationToDDHHMM(teamFixturesInfo.getNextFixtureDuration());
		}
		
		catch (ex)
		{
			mFootballTeamInfo = "Error";
			logger.error("Error in setFixtureInfo");
		}

    }
    function setLastFixtureInfo(teamFixturesInfo)
    {
		var fixtures = teamFixturesInfo.getPreviousFixtures();
	    var last = fixtures["count"] - 1;
        mPreviousMatch = getLastFixture(fixtures["fixtures"][last]);
    }
    function getFixture(fixture)
    {
    	var fixtureTemplate = "$1$ $2$ $3$";
        var fixtureLocation = Ui.loadResource(Rez.Strings.MainFixtureAway);
        var fixtureOpponent = Constants.leagueTeams[fixture["htId"]];
        if (fixture["htId"] == mTeamId)
        {
        	fixtureOpponent = Constants.leagueTeams[fixture["atId"]];
        	fixtureLocation = Ui.loadResource(Rez.Strings.MainFixtureHome);
        }
        var fixtureDateMoment = DateTimeUtils.parseISO8601DateToMoment(fixture["date"]);
        var formattedDate = DateTimeUtils.getFormattedDateDDMMHHmm(fixtureDateMoment);


        var result = Lang.format(fixtureTemplate, [formattedDate, fixtureLocation, fixtureOpponent ]);
        return result;
    }

    function getLastFixture(fixture)
    {
		logger.error("Get last fixture info");
    	//fixtureTemplateTest = "2-0 (H) Chelsea";
    	var fixtureTemplate = "$1$ $2$ $3$";
        var fixtureResultTemplate = "$1$-$2$";
        var homeTeamResult = fixture["res"]["ght"];
        var awayTeamResult = fixture["res"]["gat"];
		logger.error("results fetched");
        var fixtureResult = Lang.format(fixtureResultTemplate, [homeTeamResult, awayTeamResult]);

        var fixtureLocation = Ui.loadResource(Rez.Strings.MainFixtureAway);
        var fixtureOpponent = Constants.leagueTeams[fixture["htId"]];
        if (fixture["htId"] == mTeamId)
        {
        	fixtureOpponent = Constants.leagueTeams[fixture["atId"]];
        	fixtureLocation = Ui.loadResource(Rez.Strings.MainFixtureHome);
        }
        var result = Lang.format(fixtureTemplate, [fixtureResult, fixtureLocation, fixtureOpponent ]);
        return result;
    }
}

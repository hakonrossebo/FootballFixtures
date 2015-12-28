using Toybox.Communications as Comm;
using Toybox.WatchUi as Ui;
using Toybox.Graphics;
using Toybox.System as Sys;
using Toybox.Application as App;
using Toybox.Time as Time;
using Log4MonkeyC as Log;



class FootballTeamView extends Ui.View {
    hidden var mFootballTeamInfo = "";
    hidden var mTeamId = "";
    hidden var mTeamName = "--";
    hidden var mNextMatch = "--";
    hidden var mPreviousMatch = "--";
    hidden var mNextMatches =  ["--", "--", "--" ];
    hidden var mNextMatchDuration = "--";
    hidden var mModel;
    hidden var logger;

    function initialize(teamFixturesInfo){
    	logger = Log.getLogger("FootballTeamView");
    	prepareViewInfo(teamFixturesInfo);
    }

    //! Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.FootballTeam(dc));
    }

    //! Restore the state of the app and prepare the view to be shown
    function onShow() {
    	logger.debug("showing main view");
    }

    //! Update the view
    function onUpdate(dc) {
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

    //! Called when this View is removed from the screen. Save the
    //! state of your app here.
    function onHide() {
    }

    function prepareViewInfo(teamFixturesInfo)
    {
        logger.debug("Inside prepareViewInfo");
		try
		{
	        if (1==1)
	        {
	        	logger.debug("Inside infoready - instance ok");
	            mFootballTeamInfo = globalTeams[teamFixturesInfo.getTeamId()];
	            logger.debug("team: " + mFootballTeamInfo);
	            mTeamId = teamFixturesInfo.getTeamId();
	            setLastFixtureInfo(teamFixturesInfo.getPreviousFixtures());
				setFixtureInfo(teamFixturesInfo.getNextFixtures());
				logger.debug("Used memory:");
				logger.debug(Sys.getSystemStats().usedMemory);
	        }
	        else 
	        {
	            mFootballTeamInfo = "View error";
				logger.debug("View error. No dictionary with info from model.");
	        }
	        teamFixturesInfo = null;
		}
		catch (ex)
		{
			mFootballTeamInfo = "Error";
			logger.error("Error: " + ex.getErrorMessage());
		}
        Ui.requestUpdate();
    }
    function setFixtureInfo(fixtures)
    {
		try
		{
	        mNextMatches[0] = getFixture(fixtures["fixtures"][0]);
	        mNextMatches[1] = getFixture(fixtures["fixtures"][1]);
	        mNextMatchDuration = getNextFixtureDuration(fixtures["fixtures"][0]);
		}
		catch (ex)
		{
			mFootballTeamInfo = "Error";
			logger.error("Error in setFixtureInfo");
		}

    }
    function setLastFixtureInfo(fixtures)
    {
	    var last = fixtures["count"] - 1;
        mPreviousMatch = getLastFixture(fixtures["fixtures"][last]);
    }
    function getFixture(fixture)
    {
    	var fixtureTemplate = "$1$ $2$ $3$";
        var fixtureLocation = Ui.loadResource(Rez.Strings.MainFixtureAway);
        var fixtureOpponent = fixture["homeTeamName"];
        if (fixture["homeTeamId"] == mTeamId)
        {
        	fixtureOpponent = fixture["awayTeamName"];
        	fixtureLocation = Ui.loadResource(Rez.Strings.MainFixtureHome);
        }
        var fixtureDateMoment = parseISO8601DateToMoment(fixture["date"]);
        var formattedDate = getFormattedDate(fixtureDateMoment);


        var result = Lang.format(fixtureTemplate, [formattedDate, fixtureLocation, fixtureOpponent ]);
        return result;
    }
    function getNextFixtureDuration(fixture)
    {
        var fixtureDateMoment = parseISO8601DateToMoment(fixture["date"]);
        var duration = fixtureDateMoment.subtract(Time.now());
	       logger.debug(duration.value());
		var formattedDuration = format_duration(duration.value());
        return formattedDuration;
    }

    function getLastFixture(fixture)
    {
    	//fixtureTemplateTest = "2-0 (H) Chelsea";
    	var fixtureTemplate = "$1$ $2$ $3$";
        var fixtureResultTemplate = "$1$-$2$";
        var homeTeamResult = fixture["result"]["goalsHomeTeam"];
        var awayTeamResult = fixture["result"]["goalsAwayTeam"];
        var fixtureResult = Lang.format(fixtureResultTemplate, [homeTeamResult, awayTeamResult]);

        var fixtureLocation = Ui.loadResource(Rez.Strings.MainFixtureAway);
        var fixtureOpponent = fixture["homeTeamName"];
        if (fixture["homeTeamId"] == mTeamId)
        {
        	fixtureOpponent = fixture["awayTeamName"];
        	fixtureLocation = Ui.loadResource(Rez.Strings.MainFixtureHome);
        }
        var result = Lang.format(fixtureTemplate, [fixtureResult, fixtureLocation, fixtureOpponent ]);
        return result;
    }

    function parseISO8601DateToMoment(dateStr)
    {
    	// example - 2015-12-28T17:30:00Z
		try
		{
			var year = dateStr.substring(0, 4).toNumber();
			var month = dateStr.substring(5, 7).toNumber();
			var day = dateStr.substring(8, 10).toNumber();
			var hour = dateStr.substring(11, 13).toNumber();
			var minute = dateStr.substring(14, 16).toNumber();
			var dateTime = Time.Gregorian.moment({:year=>year,:month=>month,:day=>day, :hour=>hour,:minute=>minute,:second=>0});
			return dateTime;
		}
		catch (ex)
		{
			logger.error("Error - defaulting time to now");
			return Time.now();
		}
    }
    function getFormattedDate(dateTime)
    {
    	var shortDate = Time.Gregorian.info(dateTime, Toybox.Time.FORMAT_SHORT);
    	return Lang.format("$1$/$2$ $3$:$4$", [shortDate.day, shortDate.month, shortDate.hour.format("%02d"), shortDate.min.format("%02d")]);
    }

	function format_duration(seconds) {
		try
		{
			var days = seconds / 86400;
			days = days.toLong();
			seconds -= days * 86400;
			var hours = seconds / 3600;
			hours = hours.toLong() % 24;
			seconds -= hours * 3600;
			var minutes = seconds / 60;
			minutes = minutes.toLong() % 60;
		    return Lang.format(Ui.loadResource(Rez.Strings.MainMatchIn) + "$1$:$2$:$3$", [days, hours.format("%02d"), minutes.format("%02d")]);
		}
		catch (ex)
		{
			logger.error("Error in date formatting");
			return "0:0:0";
		}

	}
}

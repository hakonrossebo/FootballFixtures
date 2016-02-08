using Log4MonkeyC as Log;
using Toybox.Application as App;

class PropertyHandler {
	hidden const OLD_SETTINGS_IDENTITY = "TeamFixtureInfoJson";
	hidden const CURRENT_SETTINGS_IDENTITY = "TeamFixtureInfoJson_v23";
	hidden var logger;

	// Constructor
	function initialize() {
		logger = Log.getLogger("PropertyHandler" );
	}

	function getTeamFixturesInfo(selectedNewTeamId){
		var fixturesInfo = new FixturesInfo();
		if (selectedNewTeamId != 0) // && (selectedNewTeamId != storedTeamInfo.getTeamId()))
		{
			logger.debug("User changed team Id. Returning setting with only team id.");
			fixturesInfo.setTeamId(selectedNewTeamId);
			fixturesInfo.dateValid = false;
			fixturesInfo.selectedTeamValid = true;
			return fixturesInfo;
		}
		var storedTeamInfo = new FixturesInfo();
		var app = App.getApp();
		storedTeamInfo.properties = app.getProperty(CURRENT_SETTINGS_IDENTITY);
		if(storedTeamInfo.checkValidProperties())
		{
			removeOldProperties(app);
			if (!storedTeamInfo.validatePropertiesNeedsRefresh())
			{
				logger.debug("Using valid data from settings");
				fixturesInfo.properties = storedTeamInfo.properties;
				fixturesInfo.dateValid = true;
				fixturesInfo.selectedTeamValid = true;
				storedTeamInfo = null;
				return fixturesInfo;
			}
			logger.debug("Using only team id from settings. Returning settings with only team id.");
			fixturesInfo.properties = storedTeamInfo.properties;
			fixturesInfo.dateValid = false;
			fixturesInfo.selectedTeamValid = true;
			storedTeamInfo = null;
			return fixturesInfo;
		}

		var storedOldTeamInfo = app.getProperty(OLD_SETTINGS_IDENTITY);
		if(null!=storedOldTeamInfo)
		{
			logger.debug("Using only id from old settings. Removing old settings.");
			fixturesInfo.setTeamId(storedOldTeamInfo["teamId"]);
			fixturesInfo.dateValid = false;
			fixturesInfo.selectedTeamValid = true;
			app.deleteProperty(OLD_SETTINGS_IDENTITY);
			app.saveProperties();
			storedOldTeamInfo = null;
			return fixturesInfo;
		}
		else 
		{
			storedOldTeamInfo = null;
			logger.debug("No settings exists. Using clean property template.");
			return fixturesInfo;
		}
	}
	
	function removeOldProperties(app) {
		var storedOldTeamInfo = app.getProperty(OLD_SETTINGS_IDENTITY);
		if(null!=storedOldTeamInfo)
		{
			app.deleteProperty(OLD_SETTINGS_IDENTITY);
			app.saveProperties();
			storedOldTeamInfo = null;
		}
	}
	

	function setTeamFixturesInfo(nextFixtures, previousFixtures, teamId)
	{
		logger.debug("Setting team fixtures info property");
		var fixturesInfo = new FixturesInfo();
		var app = App.getApp();
		fixturesInfo.setNextFixtures(nextFixtures);
		fixturesInfo.setPreviousFixtures(previousFixtures);
		fixturesInfo.setTeamId(teamId);
		fixturesInfo.updateLastModifiedDate();
		fixturesInfo.dateValid = true;
		fixturesInfo.selectedTeamValid = true;

		var storedTeamInfo = app.setProperty(CURRENT_SETTINGS_IDENTITY, fixturesInfo.properties);
		app.saveProperties();
		return fixturesInfo;
	}



}

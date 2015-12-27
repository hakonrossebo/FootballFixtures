using Log4MonkeyC as Log;
using Toybox.Application as App;

class FootballFixturesPropertyInfo {
	
}


class PropertyHandler {
	hidden const OLD_SETTINGS_IDENTITY = "TeamFixtureInfoJson";
	hidden const CURRENT_SETTINGS_IDENTITY = "TeamFixtureInfoJson_v2";
	hidden var logger;
	hidden var propertyTemplate = {
		"dateValid" => false,
		"selectedTeamValid" => false,
		"lastModified" => Time.now().value(),
		"nextFixtureDate" => null,
		"teamId" => 0,
		"nextFixtures" => {},
		"previousFixtures" => {}
	};



	// Constructor
	function initialize() {
		logger = Log.getLogger("PropertyHandler" );
	}


	function getTeamFixturesInfo(selectedNewTeamId){
		var app = App.getApp();
		var storedTeamInfo = app.getProperty(CURRENT_SETTINGS_IDENTITY);
		if(null!=storedTeamInfo)
		{
			removeOldProperties(app);
			if (selectedNewTeamId != 0 && (selectedNewTeamId != storedTeamInfo["teamId"]))
			{
				logger.debug("User changed team Id. Returning setting with only team id.");
				propertyTemplate["teamId"] = selectedNewTeamId;
				propertyTemplate["selectedTeamValid"] = true;
				propertyTemplate["dateValid"] = false;
				return propertyTemplate;
			}
			if (settingsValid(storedTeamInfo))
			{
				logger.debug("Using valid data from settings");
				storedTeamInfo["dateValid"] = true;
				storedTeamInfo["selectedTeamValid"] = true;
				return storedTeamInfo;
			}
			logger.debug("Using only team id from settings. Returning settings with only team id.");
			storedTeamInfo["dateValid"] = false;
			storedTeamInfo["selectedTeamValid"] = true;
			storedTeamInfo["teamId"] = storedTeamInfo["teamId"];
			return storedTeamInfo;
		}

		var storedOldTeamInfo = app.getProperty(OLD_SETTINGS_IDENTITY);
		if(null!=storedOldTeamInfo)
		{
			logger.debug("Using only id from old settings. Removing old settings.");
			propertyTemplate["teamId"] = storedOldTeamInfo["teamId"];
			propertyTemplate["selectedTeamValid"] = true;
			propertyTemplate["dateValid"] = false;
			app.deleteProperty(OLD_SETTINGS_IDENTITY);
			app.saveProperties();
			return propertyTemplate;
		}
		else 
		{
			logger.debug("No settings exists. Using clean property template.");
			return propertyTemplate;
		}
	}
	
	function removeOldProperties(app) {
		var storedOldTeamInfo = app.getProperty(OLD_SETTINGS_IDENTITY);
		if(null!=storedOldTeamInfo)
		{
			app.deleteProperty(OLD_SETTINGS_IDENTITY);
			app.saveProperties();
		}
	}
	

	function setTeamFixturesInfo(nextFixtures, previousFixtures, teamId)
	{
		logger.debug("Setting team fixtures info property");
		var app = App.getApp();
		propertyTemplate["nextFixtures"] = nextFixtures;
		propertyTemplate["previousFixtures"] = previousFixtures;
		propertyTemplate["teamId"] = teamId;
		propertyTemplate["lastModified"] = Time.now().value();
		propertyTemplate["nextFixtureDate"] = Time.now().value();
		propertyTemplate["selectedTeamValid"] = true;
		propertyTemplate["dateValid"] = true;
		var storedTeamInfo = app.setProperty(CURRENT_SETTINGS_IDENTITY, propertyTemplate);
		app.saveProperties();
		return propertyTemplate;
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


}

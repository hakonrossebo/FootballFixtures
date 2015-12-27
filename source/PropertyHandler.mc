using Log4MonkeyC as Log;
using Toybox.Application as App;

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


	function getTeamFixturesInfo(){
		var app = App.getApp();
		var storedTeamInfo = app.getProperty(CURRENT_SETTINGS_IDENTITY);
		if(null!=storedTeamInfo)
		{
			if (settingsValid(storedTeamInfo))
			{
				logger.debug("Using data from settings");
				storedTeamInfo.dateValid = true;
				storedTeamInfo.selectedTeamValid = true;
				return storedTeamInfo;
			}
			else
			{
				logger.debug("Using only id from settings");
				storedTeamInfo.dateValid = false;
				storedTeamInfo.selectedTeamValid = true;
				storedTeamInfo.teamId = storedTeamInfo["teamId"];
				return storedTeamInfo;
			}
		}

		var storedOldTeamInfo = app.getProperty(OLD_SETTINGS_IDENTITY);
		if(null!=storedOldTeamInfo)
		{
			logger.debug("Using only id from old settings");
			propertyTemplate.teamId = storedOldTeamInfo["teamId"];
			propertyTemplate.selectedTeamValid = true;
			return propertyTemplate;
		}
		else {
			return propertyTemplate;
		}
	}

	function setProperties(nextFixtures, previousFixtures, teamId)
	{
		var app = App.getApp();
		propertyTemplate["nextFixtures"] = nextFixtures;
		propertyTemplate["previousFixtures"] = previousFixtures;
		propertyTemplate["teamId"] = teamId;
		propertyTemplate["lastModified"] = Time.now().value();
		propertyTemplate["nextFixtureDate"] = Time.now().value();
		propertyTemplate["selectedTeamValid"] = true;
		propertyTemplate["dateValid"] = true;
		var storedTeamInfo = app.setProperty(CURRENT_SETTINGS_IDENTITY, newProperties);
		app.saveProperties();
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

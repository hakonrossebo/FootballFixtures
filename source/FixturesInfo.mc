using Log4MonkeyC as Log;
using Toybox.Application as App;

class FixturesInfo {
	hidden var logger;
	var properties = {
		"lastModified" => Time.now().value(),
		"nextFixtureDate" => null,
		"teamId" => 0,
		"nextFixtures" => {},
		"previousFixtures" => {}
	};
	var dateValid = false;
	var selectedTeamValid = false;



	// Constructor
	function initialize() {
		logger = Log.getLogger("FixturesInfo" );
	}
	function getNextFixtureDate() {
		return Time.now().value();
	}	
	function updateLastModifiedDate() {
		properties["lastModified"] = Time.now().value();	
	}
	function setTeamId(teamId) {
		properties["teamId"] = teamId;	
	}
	function setNextFixtures(nextFixtures) {
		properties["nextFixtures"] = nextFixtures;	
	}
	function setPreviousFixtures(previousFixtures) {
		properties["previousFixtures"] = previousFixtures;	
	}
	
	function getTeamId() {
		return properties["teamId"];
	}
	function getNextFixtures() {
		return properties["nextFixtures"];	
	}
	function getPreviousFixtures() {
		return properties["previousFixtures"];	
	}

    function getLastUpdatedDuration() {
		var lastUpdated = new Time.Moment(properties["lastModified"].toLong());
		var timeNow = Time.now();
        var lastUpdatedDuration = timeNow.subtract(lastUpdated);
		logger.debug("getLastUpdatedDuration. Duration since last settings (s) " + lastUpdatedDuration.value());
        return lastUpdatedDuration.value();
    }

    function getNextFixtureDuration()
    {	
    	var fixture = properties["nextFixtures"]["fixtures"][0];
        var fixtureDateMoment = DateTimeUtils.parseISO8601DateToMoment(fixture["date"]);
        var duration = fixtureDateMoment.subtract(Time.now());
        logger.debug("Next fixture duration: " + duration.value());
        return duration.value();
    }
    
    function checkValidProperties() {
    	return null != properties;
    }
    
    
    
	function validatePropertiesNeedsRefresh()
	{
		var MINUTE = 60;
		var HOUR = MINUTE*60;
		var DAY = HOUR*24;
		var MAX_DURATION_PAST_CURRENT_TIME = (HOUR*4) * (-1);
		var MAX_DURATION_SINCE_LAST_UPDATE_TIME = DAY*7;
		var result = false;
        logger.debug("Checking refresh. MAX_DURATION_PAST_CURRENT_TIME: " + MAX_DURATION_PAST_CURRENT_TIME);
		var nextFixtureDuration = getNextFixtureDuration();
		var lastUpdatedDuration = getLastUpdatedDuration();
		if (nextFixtureDuration < MAX_DURATION_PAST_CURRENT_TIME)
		{
	        logger.debug("nextFixtureDuration < MAX_DURATION_PAST_CURRENT_TIME, checking last updated time");
			if (lastUpdatedDuration > HOUR)
			{
		        logger.debug("lastUpdatedDuration > HOUR, refreshing");
				result = true;
			}
		}
		logger.debug("Checking if properties needs to be refreshed anyways..");
		if (lastUpdatedDuration > MAX_DURATION_SINCE_LAST_UPDATE_TIME)
		{
			result = true;
		}
        logger.debug("Return value from validatePropertiesNeedsRefresh: " + result);
		return result;
	}
}

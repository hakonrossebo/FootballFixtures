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
    function getNextFixtureDuration()
    {	
    	var fixture = properties["nextFixtures"]["fixtures"][0];
        var fixtureDateMoment = DateTimeUtils.parseISO8601DateToMoment(fixture["date"]);
        var duration = fixtureDateMoment.subtract(Time.now());
        logger.debug("Next fixture duration: " + duration.value());
        return duration;
    }
    
    function checkValidProperties() {
    	return null != properties;
    }
    
	function validatePropertiesNeedsRefresh()
	{
		var lastUpdated = new Time.Moment(properties["lastModified"].toLong());
		var timeNow = Time.now();
        var duration = timeNow.subtract(lastUpdated);
		logger.debug("Validate refresh. Duration since last settings (s) " + duration.value());
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
